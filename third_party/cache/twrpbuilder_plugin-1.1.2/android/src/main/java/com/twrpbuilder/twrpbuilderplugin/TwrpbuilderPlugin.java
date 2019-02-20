package com.twrpbuilder.twrpbuilderplugin;

import android.annotation.TargetApi;
import android.os.Build;
import android.os.Environment;
import android.util.Log;

import com.stericson.RootTools.RootTools;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.zip.GZIPOutputStream;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import eu.chainfire.libsuperuser.Shell;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * TwrpbuilderPlugin
 */
public class TwrpbuilderPlugin implements MethodCallHandler {

    private static final int MIN_BACKUP_SIZE = 3000000;
    private final static
    String[] file = new String[]{
            "RECOVERY",
            "Recovery",
            "FOTAKernel",
            "fotakernel",
            "recovery"
    };
    private static final String BuildModel = Build.MODEL;
    private static final String BuildBoard = Build.BOARD;
    private static final String BuildBrand = Build.BRAND;
    private static final String BuildFingerprint = Build.FINGERPRINT;
    private static final String BuildProduct = Build.PRODUCT;
    private static String TAG = TwrpbuilderPlugin.class.getSimpleName();
    private static String Sdcard = Environment.getExternalStorageDirectory().getPath() + File.separator;
    private static String Sdcard2 = Environment.getExternalStorageDirectory().getPath();
    private static boolean isOldMTK = false;

    //public static boolean ROOT_GRANTED;

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "twrpbuilder_plugin");
        channel.setMethodCallHandler(new TwrpbuilderPlugin());
    }

    private static String command(String command) {
        return Shell.SH.run(command).toString().replace("[", "").replace("]", "");
    }

    private static String suCommand(String command) {
        return Shell.SU.run(command).toString();
    }

    private static String getBuildModel() {
        return BuildModel;
    }

    private static String getBuildFingerprint() {
        return BuildFingerprint;
    }

    private static String getBuildProduct() {
        return BuildProduct;
    }

    private static String getBuildBoard() {
        if (BuildBoard.equals("unknown")) {
            String hello = command("getprop ro.board.platform");
            if (hello.isEmpty()) {
                if (command("getprop ro.mediatek.platform").isEmpty()) {
                    return BuildBoard;
                } else {
                    return command("getprop ro.mediatek.platform");
                }
            } else {
                return hello;
            }
        } else {
            return BuildBoard;
        }
    }

    private static String getBuildBrand() {
        return BuildBrand;
    }

    private static String getBuildAbi() {
        return command("getprop ro.product.cpu.abi");
    }

    private static String getSdCard() {
        return Sdcard2;
    }

    private static String buildProp() {
        String data = "# Build.prop v1\n";
        data += "ro.product.brand=" + getBuildBrand() + "\n";
        data += "ro.board.platform=" + getBuildBoard() + "\n";
        data += "ro.product.model=" + getBuildModel() + "\n";
        data += "ro.build.product=" + getBuildProduct() + "\n";
        data += "ro.build.fingerprint=" + getBuildFingerprint() + "\n";
        data += "ro.product.cpu.abi=" + getBuildAbi();
        return data;
    }

    private static boolean isOldMtk() {
        return isOldMTK;
    }

    private static String getRecoveryMount() {
        String recoveryMount = "";
        String output = Shell.SU.run("find /dev/block/platform -type d -name by-name ").toString().replace("[", "").replace("]", "");
        if (output.isEmpty()) {
            output = Shell.SU.run("ls /dev/recovery").toString().replace("[", "").replace("]", "");
            if (!output.isEmpty()) {
                isOldMTK = true;
                recoveryMount = output;
                Log.d(TAG, "Outputt" + output);
            }
        } else {
            for (String f : file) {
                String output2 = Shell.SU.run("ls " + output + File.separator + f).toString().replace("[", "").replace("]", "");
                if (!output2.isEmpty()) {
                    recoveryMount = output2;
                    Log.d(TAG, "Outputt2" + output2);
                    break;
                }

            }
        }
        Log.d(TAG, "Output" + output);
        return recoveryMount;
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        switch (call.method) {
            case "isAccessGiven":
                try {
                    result.success(isAccessGiven());
                } catch (IOException e) {
                    result.error("Error", e.getMessage(), null);
                    Log.e(TAG, e.getMessage());
                }
                break;
            case "command":
                result.success(command(call.argument("command").toString()));
                break;
            case "cp":
                try {
                    result.success(cp(call.argument("src").toString(), Sdcard + call.argument("dest").toString()));
                } catch (IOException e) {
                    result.error("Error", e.getMessage(), null);
                    Log.e(TAG, e.getMessage());
                }
                break;
            case "mkdir":
                result.success(mkdir(call.argument("dir").toString()));
                break;
            case "getBuildModel":
                result.success(getBuildModel());
                break;
            case "getBuildFingerprint":
                result.success(getBuildFingerprint());
                break;
            case "getBuildProduct":
                result.success(getBuildProduct());
                break;
            case "getBuildBrand":
                result.success(getBuildBrand());
                break;
            case "getBuildBoard":
                result.success(getBuildBoard());
                break;
            case "getBuildAbi":
                result.success(getBuildAbi());
                break;
            case "getSdCard":
                result.success(getSdCard());
                break;
            case "buildProp":
                result.success(buildProp());
                break;
            case "isOldMtk":
                result.success(isOldMtk());
                break;
            case "getRecoveryMount":
                result.success(getRecoveryMount());
                break;
            case "suCommand":
                result.success(suCommand(call.argument("command").toString()));
                break;
            case "compressGzipFile":
                try {
                    result.success(compressGzipFile(call.argument("file").toString(), call.argument("gZipFile").toString()));
                } catch (IOException e) {
                    result.error("Error", e.getMessage(), null);
                    Log.e(TAG, e.getMessage());
                }
                break;
            case "createBuildProp":
                try {
                    result.success(createBuildProp(call.argument("filename").toString(), Sdcard + call.argument("data").toString()));
                } catch (FileNotFoundException e) {
                    result.error("Error", e.getMessage(), null);
                    Log.e(TAG, e.getMessage());
                }
                break;
            case "zip":
                try{
                    result.success(zip(call.argument("files").toString().split(","), Sdcard + call.argument("zipFile").toString()));
                }catch (IOException e){
                    result.error("Error", e.getMessage(), null);
                    Log.e(TAG, e.getMessage());
                }
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    private boolean isAccessGiven() throws IOException {
        return RootTools.isAccessGiven();
    }

    private Object cp(String src, String dst) throws IOException {
        FileInputStream var2 = new FileInputStream(src);
        FileOutputStream var3 = new FileOutputStream(dst);
        byte[] var4 = new byte[1024];

        int var5;
        while ((var5 = var2.read(var4)) > 0) {
            var3.write(var4, 0, var5);
        }

        var2.close();
        var3.close();
        return null;
    }

    private Object mkdir(String name) {
        String fileStatus = "";
        File makedir = new File(Sdcard + name);
        Log.d(TAG, "Request to make dir " + name + " received!");
        boolean success;
        if (!makedir.exists()) {
            success = makedir.mkdirs();
            if (success) {
                Log.i(TAG, "Dir " + name + " created successfully!");
                fileStatus = "Success";
            } else {
                Log.e(TAG, "Failed to make dir " + name);
                fileStatus = "Failed!";
            }
        } else {
            Log.i(TAG, name + " dir already exists!");
            fileStatus = "Exists";
        }
        return fileStatus;
    }

    private Object createBuildProp(String filename, String data) throws FileNotFoundException {
        PrintWriter writer;
        writer = new PrintWriter(new FileOutputStream(Sdcard + "TWRPBuilderF/" + filename, false));
        writer.println(data);
        writer.close();
        return null;
    }

    private boolean compressGzipFile(String file, String gzipFile) throws IOException {
        boolean failed = false;
        FileInputStream fis = new FileInputStream(file);
        FileOutputStream fos = new FileOutputStream(gzipFile);
        GZIPOutputStream gzipOS = new GZIPOutputStream(fos);
        byte[] buffer = new byte[1024];
        int len;
        while ((len = fis.read(buffer)) != -1) {
            gzipOS.write(buffer, 0, len);
        }
        //close resources
        gzipOS.close();
        fos.close();
        fis.close();
        if (new File(gzipFile).length() < MIN_BACKUP_SIZE) {
            failed = true;
            new File(gzipFile).delete();
        }
        return failed;
    }

    @TargetApi(Build.VERSION_CODES.KITKAT)
    private Object zip(String[] files, String zipFile) throws IOException{
        BufferedInputStream origin;
        try (ZipOutputStream out = new ZipOutputStream(new BufferedOutputStream(new FileOutputStream(zipFile)))) {
            byte data[] = new byte[1024];

            for (String file : files) {
                FileInputStream fi = new FileInputStream(file);
                origin = new BufferedInputStream(fi, 1024);
                try {
                    ZipEntry entry = new ZipEntry(file.substring(file.lastIndexOf("/") + 1));
                    out.putNextEntry(entry);
                    int count;
                    while ((count = origin.read(data, 0, 1024)) != -1) {
                        out.write(data, 0, count);
                    }
                } finally {
                    origin.close();
                }
            }
        }
        return null;
    }
}
