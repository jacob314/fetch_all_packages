package com.scliang.futils;

import android.app.Activity;
import android.content.Intent;
//import android.util.Log;

import java.lang.ref.SoftReference;

import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.plugin.common.StringCodec;

/** FutilsPlugin */
public class FutilsPlugin implements MethodCallHandler,
    BasicMessageChannel.MessageHandler<String>,
    PluginRegistry.ActivityResultListener {
  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    // message channel
    final BasicMessageChannel<String> messageChannel =
        new BasicMessageChannel<>(registrar.messenger(), "futils_message",
            StringCodec.INSTANCE);

    // plugin
    final FutilsPlugin plugin = new FutilsPlugin(registrar.activity(), messageChannel);

    // method channel
    final MethodChannel methodChannel =
        new MethodChannel(registrar.messenger(), "futils_method");
    registrar.addActivityResultListener(plugin);
    methodChannel.setMethodCallHandler(plugin);

    // message channel
    messageChannel.setMessageHandler(plugin);
  }

  private SoftReference<Activity> mActivity;
  private SoftReference<BasicMessageChannel<String>> mMessageChannel;
  private FutilsWebManager mWebManager;

  private FutilsPlugin(Activity activity, BasicMessageChannel<String> messageChannel) {
    mActivity = new SoftReference<>(activity);
    mMessageChannel = new SoftReference<>(messageChannel);
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    final String method = call.method;
//    Log.d("FutilsPlugin", "onMethodCall: " + method);

    // get platform version
    if ("getPlatformVersion".equals(method)) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    }

    // launch web view load url
    else if ("launchWebView".equals(method)) {
      launchUrl(call, result);
    }
    // close web view
    else if ("closeWebView".equals(method)) {
      close(call, result);
    }

    // default
    else {
      result.notImplemented();
    }
  }

  @Override
  public void onMessage(String s, BasicMessageChannel.Reply<String> reply) {

  }

  @Override
  public boolean onActivityResult(int requestCode, int resultCode, Intent intent) {
    return false;
  }

  private void launchUrl(MethodCall call, MethodChannel.Result result) {
    final Activity activity = mActivity == null ? null : mActivity.get();
    if (activity == null) {
      result.success("Activity is null");
      return;
    }

    if (mWebManager == null || mWebManager.closed) {
      mWebManager = new FutilsWebManager(activity,
          mMessageChannel == null ? null : mMessageChannel.get());
    }

    mWebManager.launchUrl(call, result);
  }

  private void close(MethodCall call, MethodChannel.Result result) {
    final Activity activity = mActivity == null ? null : mActivity.get();
    if (activity == null) {
      result.success("Activity is null");
      return;
    }

    if (mWebManager != null) {
      mWebManager.close(call, result);
    } else {
      result.success("WebManager is null");
    }
  }
}
