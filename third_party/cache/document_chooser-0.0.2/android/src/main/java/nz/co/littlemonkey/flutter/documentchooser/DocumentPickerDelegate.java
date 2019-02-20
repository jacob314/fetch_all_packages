package nz.co.littlemonkey.flutter.documentchooser;

import android.app.Activity;
import android.content.ClipData;
import android.content.ContentResolver;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.util.Log;
import android.webkit.MimeTypeMap;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class DocumentPickerDelegate implements PluginRegistry.ActivityResultListener,
        PluginRegistry.RequestPermissionsResultListener {

    static final int PICK_SINGLE = 42;
    static final int PICK_MULTIPLE = 52;

    private final Activity activity;
    private final File externalFilesDirectory;
    private MethodChannel.Result pendingResult;

    public DocumentPickerDelegate(Activity activity, File externalFilesDirectory) {
        this.activity = activity;
        this.externalFilesDirectory = externalFilesDirectory;
    }

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent data) {

        switch (requestCode) {
            case PICK_SINGLE:
                handleSingleResult(resultCode, data);
                break;
            case PICK_MULTIPLE:
                handleMultipleResult(resultCode, data);
                break;
            default:
                return false;
        }
        return true;
    }

    private void handleMultipleResult(int resultCode, Intent data) {
        if (resultCode == Activity.RESULT_OK) {


            try {
                ClipData clipData = data.getClipData();
                List<String> result = new ArrayList<String>();
                if (clipData != null) {
                    for (int i = 0; i < clipData.getItemCount(); i++) {
                        ClipData.Item item = clipData.getItemAt(i);
                        Uri uri = item.getUri();
                        Log.i("DOCUMENT CHOOSER", "Document Uri: " + uri.toString());
                        String url = copyToLocal(uri);
                        result.add(url);
                    }
                }
                pendingResult.success(result);
            }catch(IOException e){
                pendingResult.success(null);
            }
        }else{
            pendingResult.success(null);
        }

    }

    private void handleSingleResult(int resultCode, Intent data) {
        if (resultCode == Activity.RESULT_OK) {
            Uri uri = null;
            if (data != null) {
                uri = data.getData();
                Log.i("DOCUMENT CHOOSER", "Document Uri: " + uri.toString());
                try {
                    String url = copyToLocal(uri);
                    pendingResult.success(url);
                }catch(IOException e){
                    pendingResult.success(null);
                }
            }
        }else{
            pendingResult.success(null);
        }
    }

    private String copyToLocal(Uri uri) throws IOException {
        String extension = getExtension(activity, uri);
        File output = createTemporaryWritableFile(extension);

        InputStream inputStream = activity.getContentResolver().openInputStream(uri);

        FileOutputStream outputStream = new FileOutputStream(output);
        byte[] buffer = new byte[4 * 1024]; // or other buffer size
        int read;
        while ((read = inputStream.read(buffer)) != -1) {
            outputStream.write(buffer, 0, read);
        }
        outputStream.flush();
        outputStream.close();
        inputStream.close();

        return output.getAbsolutePath();
    }

    public static String getExtension(Context context, Uri uri) {
        String extension;

        //Check uri format to avoid null
        if (uri.getScheme().equals(ContentResolver.SCHEME_CONTENT)) {
            //If scheme is a content
            final MimeTypeMap mime = MimeTypeMap.getSingleton();
            extension = mime.getExtensionFromMimeType(context.getContentResolver().getType(uri));
        } else {
            //If scheme is a File
            //This will replace white spaces with %20 and also other special characters. This will avoid returning null values on file name with spaces and special characters.
            extension = MimeTypeMap.getFileExtensionFromUrl(Uri.fromFile(new File(uri.getPath())).toString());

        }

        return extension;
    }

    private File createTemporaryWritableFile(String suffix) {
        String filename = UUID.randomUUID().toString();
        File image;

        try {
            image = File.createTempFile(filename, suffix, externalFilesDirectory);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }

        return image;
    }

    @Override
    public boolean onRequestPermissionsResult(int i, String[] strings, int[] ints) {

        return false;
    }

    public void chooseDocument(MethodCall call, MethodChannel.Result result) {
            pendingResult = result;
        Intent intent = new Intent(Intent.ACTION_OPEN_DOCUMENT);
        intent.addCategory(Intent.CATEGORY_OPENABLE);
        intent.setType("*/*");
        activity.startActivityForResult(intent, PICK_SINGLE);
    }

    public void chooseDocuments(MethodCall call, MethodChannel.Result result) {
        pendingResult = result;
        Intent intent = new Intent(Intent.ACTION_OPEN_DOCUMENT);
        intent.addCategory(Intent.CATEGORY_OPENABLE);
        intent.putExtra(Intent.EXTRA_ALLOW_MULTIPLE, true);
        intent.setType("*/*");
        activity.startActivityForResult(intent, PICK_SINGLE);
    }
}
