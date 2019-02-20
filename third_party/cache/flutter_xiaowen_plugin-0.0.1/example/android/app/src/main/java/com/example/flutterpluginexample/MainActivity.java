package com.example.flutterpluginexample;

import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import com.example.flutterplugin.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
  }
}
