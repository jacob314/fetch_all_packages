package com.ly.fluttermobexample;

import android.os.Bundle;

import com.mob.MobSDK;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    MobSDK.init(this);
    GeneratedPluginRegistrant.registerWith(this);
  }
}
