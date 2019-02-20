package com.shareclarity.stripecard;

import android.app.Activity;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** StripeCardPlugin */
public class StripeCardPlugin {
  public static Result mResult;
  public static Activity mActivity;
  public static MethodChannel channel;

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    mActivity = registrar.activity();
    registrar.platformViewRegistry().registerViewFactory("stripe_card",new StripeCardFactory(registrar.messenger(), registrar));
  }
}
