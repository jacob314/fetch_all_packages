package com.invariance.camsnapplugin;

import io.flutter.plugin.common.PluginRegistry.Registrar;

/** CamsnapPlugin */
public class CamsnapPlugin {
  public static void registerWith(Registrar registrar) {
    registrar
      .platformViewRegistry()
      .registerViewFactory(
      "com.invariance.camsnapplugin/cameraview", new CameraViewFactory(registrar.messenger()));
  }
}
