package com.example.fluttercommonplugin;

import android.app.Activity;
import android.content.Context;
import android.widget.Toast;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FlutterCommonPlugin */
public class FlutterCommonPlugin implements MethodCallHandler {

  private final PluginRegistry.Registrar mRegistrar;

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_common_plugin");
    channel.setMethodCallHandler(new FlutterCommonPlugin(registrar));
  }

  private FlutterCommonPlugin(PluginRegistry.Registrar registrar) {
    this.mRegistrar = registrar;
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {

    Context context = mRegistrar.context();

    Toast.makeText(context, "HAHAHAHAH", Toast.LENGTH_SHORT).show();

    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if (call.method.equals("closeToNative")) {
      if (context instanceof Activity) {
        ((Activity) context).finish();
      }
      Toast.makeText(context, "HAHAHAHAH", Toast.LENGTH_SHORT).show();
      Map<String, String> map = new HashMap<String, String>();

      result.success(map);
    } else  {
      result.notImplemented();
    }
  }
}
