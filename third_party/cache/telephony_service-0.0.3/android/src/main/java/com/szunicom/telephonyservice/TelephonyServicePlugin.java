package com.szunicom.telephonyservice;

import android.annotation.SuppressLint;
import android.content.Context;
import android.telephony.TelephonyManager;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** TelephonyServicePlugin */
public class TelephonyServicePlugin implements MethodCallHandler {
  private Context appContext;
  private TelephonyManager telephonyManager;

  public TelephonyServicePlugin(Context context) {
    appContext = context;
    telephonyManager = (TelephonyManager) appContext.getSystemService(Context.TELEPHONY_SERVICE);
  }

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "telephony_service");
    channel.setMethodCallHandler(new TelephonyServicePlugin(registrar.context()));
  }

  @SuppressLint("MissingPermission")
  @Override
  public void onMethodCall(MethodCall call, Result result) {
    switch (call.method) {
      case "getSimSerialNumber":
        String simSn = telephonyManager.getSimSerialNumber();
        result.success(simSn);
        break;
      case "getImei":
        String imei;
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
          imei = telephonyManager.getImei();
          result.success(imei);
        } else {
          imei = telephonyManager.getDeviceId();
          result.success(imei);
        }
        break;
      default:
        result.notImplemented();
        break;
    }
  }
}
