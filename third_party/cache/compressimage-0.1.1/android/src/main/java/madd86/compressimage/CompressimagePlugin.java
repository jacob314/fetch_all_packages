package madd86.compressimage;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import android.util.Log;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * CompressimagePlugin
 */
public class CompressimagePlugin implements MethodCallHandler {
  /**
   * Plugin registration.
   */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "compressimage");
    channel.setMethodCallHandler(new CompressimagePlugin());
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
//    if (call.method.equals("getPlatformVersion")) {
//      result.success("Android " + android.os.Build.VERSION.RELEASE);
//    }
// else {
//      result.notImplemented();
//    }

    if (call.method.equals("compressImage")) {
      try {
        String filePath = call.argument("filePath");
        Integer desiredQuality = call.argument("desiredQuality");
        Bitmap bitmap = BitmapFactory.decodeFile(filePath);
        OutputStream imageFile = new FileOutputStream(filePath);
        bitmap.compress(Bitmap.CompressFormat.JPEG, desiredQuality, imageFile);
        result.success("Image compressed successfully");
      } catch (FileNotFoundException e) {
        e.printStackTrace();
      }
    } else {
      result.notImplemented();
    }
  }
}
