package com.aeologic.fluttertestplugin;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.location.LocationManager;
import android.os.Build;
import android.provider.MediaStore;
import android.provider.Settings;
import android.widget.Toast;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FlutterTestPlugin */
public class FlutterTestPlugin implements MethodCallHandler,PluginRegistry.ActivityResultListener {
  private static Activity activity;
  public static final int GPS_RESPONSE =1;
  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    activity=registrar.activity();
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_test_plugin");
    final FlutterTestPlugin instance= new FlutterTestPlugin();
    registrar.addActivityResultListener(instance);
    channel.setMethodCallHandler(instance);
  }


  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("getPlatformVersion")) {
      checkGps();
      //checkPermission();
      //result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else {
      result.notImplemented();
    }
  }

  private void checkGps() {
    LocationManager locationManager= (LocationManager) activity.getSystemService(Context.LOCATION_SERVICE);
    if(locationManager != null)
      if (!locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER)){
        Intent gpsIntent= new Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS);
        activity.startActivityForResult(gpsIntent, GPS_RESPONSE);
      }
      else {
        Toast.makeText(activity,"Already On",Toast.LENGTH_LONG).show();
      }
  }

  private void openCamera() {
    Intent openCamera= new Intent(Intent.ACTION_VIEW);
    activity.startActivityForResult(openCamera, GPS_RESPONSE);
  }

  private void checkPermission(){
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
      int cameraPermission=activity.checkSelfPermission(Manifest.permission.ACCESS_FINE_LOCATION);
      if (cameraPermission==PackageManager.PERMISSION_GRANTED){
        Toast.makeText(activity,"GPS already Open",Toast.LENGTH_LONG).show();
      }
      else
      {requestPermission();}
    }
  }

  private void requestPermission() {
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
      activity.requestPermissions(new String[]{Manifest.permission.ACCESS_FINE_LOCATION}, GPS_RESPONSE);
    }
  }

  @Override
  public boolean onActivityResult(int i, int i1, Intent intent) {
    if (i== GPS_RESPONSE){
      Toast.makeText(activity,"Gps turned on",Toast.LENGTH_LONG).show();
      return true;
    }
    else {
      Toast.makeText(activity,"Not Captured",Toast.LENGTH_LONG).show();
    }
    return false;
  }
}
