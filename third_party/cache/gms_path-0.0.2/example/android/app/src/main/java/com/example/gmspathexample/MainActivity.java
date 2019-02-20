package com.example.gmspathexample;

import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;
import com.google.maps.android.PolyUtil;
import com.google.android.gms.maps.model.LatLng;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "gms_path";
  private List<LatLng> coordinates;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
            new MethodCallHandler() {
              @Override
              public void onMethodCall(MethodCall call, Result result) {
                if (call.method.equals("createPathInstance")) {
                  createInstance();
                  result.success(true);
                } else if (call.method.equals("addCoordinate")) {
                  HashMap<String, Object> map = (HashMap<String, Object>)call.arguments;
                  double latitude = (double)map.get("latitude");
                  double longitude = (double)map.get("longitude");
                  addCoordinate(latitude, longitude);
                  result.success(true);
                } else if (call.method.equals("getEncodedString")) {
                  result.success(getEncodedPath());
                } else {
                  result.notImplemented();
                }

              }
            });
  }

  private String getEncodedPath() {
    if(coordinates == null) {
      createInstance();
    }
    return PolyUtil.encode(coordinates);
  }

  private void createInstance() {
    coordinates = new ArrayList<>();
  }

  private void addCoordinate(double latitude, double longitude){
    LatLng coordinate = new LatLng(latitude, longitude);
    if(coordinates == null) {
      createInstance();
    }
    coordinates.add(coordinate);
  }

}
