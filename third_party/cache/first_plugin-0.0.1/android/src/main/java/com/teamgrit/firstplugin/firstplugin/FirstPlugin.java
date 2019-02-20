package com.teamgrit.firstplugin.firstplugin;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import android.util.Log;

/** FirstPlugin */
public class FirstPlugin implements MethodCallHandler {
  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "first_plugin");
    channel.setMethodCallHandler(new FirstPlugin());
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    }else if (call.method.equals("printLog")) {
      String msg  = call.argument("msg");
      String tag = call.argument("tag");
      String logType = call.argument("logType");

      if(logType.equals("warning")){
        Log.w(tag, msg);
      }
      else if(logType.equals("error")){
        Log.e(tag, msg);
      }else{
        Log.d(tag, msg);
      }

      result.success("Logged Successfully!");
    } else {
      result.notImplemented();
    }
  }
}

