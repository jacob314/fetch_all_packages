package com.shareclarity.sharewidget;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.support.v4.content.FileProvider;

import java.io.File;
import java.util.HashMap;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** ShareWidgetPlugin */
public class ShareWidgetPlugin implements MethodCallHandler {
  /** Plugin registration. */
  private Registrar _registrar;

  private ShareWidgetPlugin(Registrar registrar) {
    this._registrar = registrar;
  }

  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "channel:share_widget");
    channel.setMethodCallHandler(new ShareWidgetPlugin(registrar));
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("shareImage")) {
      shareImage(call.arguments);
    } else if (call.method.equals("shareText")) {
      shareText(call.arguments);
    } else {
      result.notImplemented();
    }
  }

  private void shareImage(Object arguments) {

    HashMap<String, String> argsMap = (HashMap<String, String>) arguments;
    String fileName = (String) argsMap.get("fileName");
    String title = (String) argsMap.get("title");

    Context activeContext = _registrar.activeContext();

    File imageFile = new File(activeContext.getCacheDir(), fileName);
    String fileProviderAuthority = activeContext.getPackageName() + ".fileprovider.share_widget";
    Uri contentUri = FileProvider.getUriForFile(activeContext, fileProviderAuthority, imageFile);
    Intent shareIntent = new Intent(Intent.ACTION_SEND);
    shareIntent.setType("image/*");
    shareIntent.putExtra(Intent.EXTRA_STREAM, contentUri);
    activeContext.startActivity(Intent.createChooser(shareIntent, title));
  }

  private void shareText(Object arguments) {

    HashMap<String, String> argsMap = (HashMap<String, String>) arguments;
    String textToSend = (String) argsMap.get("text");
    String title = (String) argsMap.get("title");

    Context activeContext = _registrar.activeContext();

    Intent shareIntent = new Intent(Intent.ACTION_SEND);
    shareIntent.setType("text/plain");
    shareIntent.putExtra(Intent.EXTRA_TEXT, textToSend);
    activeContext.startActivity(Intent.createChooser(shareIntent, title));
  }
}
