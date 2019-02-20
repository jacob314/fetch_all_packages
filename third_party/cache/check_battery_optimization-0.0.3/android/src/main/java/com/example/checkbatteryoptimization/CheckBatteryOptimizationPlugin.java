package com.example.checkbatteryoptimization;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import android.os.PowerManager;
import android.content.Intent;
import static android.content.Context.POWER_SERVICE;
import android.content.pm.PackageManager;
import android.provider.Settings;
import android.net.Uri;

/** CheckBatteryOptimizationPlugin */
public class CheckBatteryOptimizationPlugin implements MethodCallHandler {

  private PowerManager mPowerManager;
  private Registrar mRegistrar;

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "check_battery_optimization");
    channel.setMethodCallHandler(new CheckBatteryOptimizationPlugin(registrar));
  }

  CheckBatteryOptimizationPlugin(Registrar registrar) {
    mRegistrar = registrar;
  }

  String checkBatteryOptimization() {
    Intent intent = new Intent();
    String packageName = mRegistrar.activeContext().getPackageName();
    mPowerManager = (PowerManager) (mRegistrar.activeContext().getSystemService(POWER_SERVICE));

    // ---- If ignore go to settings, else request ----

    // if(mPowerManager.isIgnoringBatteryOptimizations(packageName)) {
    //   intent.setAction(Settings.ACTION_IGNORE_BATTERY_OPTIMIZATION_SETTINGS);
    // } else {
    //   intent.setAction(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS);
    //   intent.setData(Uri.parse("package:" + packageName));
    // }
    // mRegistrar.activeContext().startActivity(intent);

    //  ---- only request if not ignore --- 
    if(!mPowerManager.isIgnoringBatteryOptimizations(packageName)) {
      intent.setAction(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS);
      intent.setData(Uri.parse("package:" + packageName));
      mRegistrar.activeContext().startActivity(intent);
    } 
    return "Success";
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
      return;
    } if (call.method.equals("checkBatteryOptimization")) {
      String reading = checkBatteryOptimization();
      result.success(reading);
      return;
    }
    result.notImplemented();
  }
}
