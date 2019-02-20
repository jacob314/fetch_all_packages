package com.cmcm.plugin.cmcmplugin;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** CmcmPlugin */
public class CmcmPlugin implements MethodCallHandler {
  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "cmcm_plugin");
    channel.setMethodCallHandler(new CmcmPlugin());
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    Log.e("onMethodCall => " + call.method)
    switch (call.method) {
      case "getPlatformVersion":
        result.success("Android " + android.os.Build.VERSION.RELEASE);
        break;
      case "init":
        try {
          final String pageId = call.argument("pageId");
          final String gameId = call.argument("gameId");
          final String gameName = call.argument("gameName");
          Log.e("onMethodCall['init'] pageId:"+pageId+" gameId:"+gameId+" gameName:"+gameName);
        } catch (Exception e) {
          result.error("initError", e.getMessage(), null);
        }
        break;
      default:
        result.notImplemented();
        break;
    }
  }
}
