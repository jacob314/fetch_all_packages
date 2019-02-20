package com.zzq.lib.libwallpaper;

import android.app.WallpaperManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;

import java.io.File;
import java.io.IOException;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** LibWallpaperPlugin */
public class LibWallpaperPlugin implements MethodCallHandler {
  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "lib_wallpaper");
    channel.setMethodCallHandler(new LibWallpaperPlugin(registrar));
  }

  private Registrar registrar;

  private LibWallpaperPlugin(Registrar registrar) {
      this.registrar = registrar;
  }

    @Override
  public void onMethodCall(MethodCall call, Result result) {
      switch (call.method) {
          case "getPlatformVersion":
              result.success("Android " + android.os.Build.VERSION.RELEASE);
              break;
          case "setWallpaper":
              setWallpaper((String)call.argument("filePath"),result);
              break;
          default:
              result.notImplemented();
              break;
      }
  }
  boolean  resultValue = true;

  private void setWallpaper(final String filePath, final Result result) {    
      File file = new File(filePath);
      if(!file.exists()) {
        result.success(false);
      } else {
          new Thread(new Runnable(){
              public void run() {
                WallpaperManager manager = WallpaperManager.getInstance(registrar.context());
                boolean resultValue = true;
                Bitmap bitmap = BitmapFactory.decodeFile(filePath);
                try {
                    manager.setBitmap(bitmap);
                } catch (IOException e) {
                    e.printStackTrace();
                    resultValue = false;
                }
                result.success(resultValue);
              }
          }).start();
      }
  }
}
