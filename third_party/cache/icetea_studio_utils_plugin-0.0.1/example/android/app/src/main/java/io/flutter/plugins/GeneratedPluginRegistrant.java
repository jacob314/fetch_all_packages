package io.flutter.plugins;

import io.flutter.plugin.common.PluginRegistry;
import clickapp.itsclicking.com.iceteastudioutilsplugin.IceteaStudioUtilsPlugin;

/**
 * Generated file. Do not edit.
 */
public final class GeneratedPluginRegistrant {
  public static void registerWith(PluginRegistry registry) {
    if (alreadyRegisteredWith(registry)) {
      return;
    }
    IceteaStudioUtilsPlugin.registerWith(registry.registrarFor("clickapp.itsclicking.com.iceteastudioutilsplugin.IceteaStudioUtilsPlugin"));
  }

  private static boolean alreadyRegisteredWith(PluginRegistry registry) {
    final String key = GeneratedPluginRegistrant.class.getCanonicalName();
    if (registry.hasPlugin(key)) {
      return true;
    }
    registry.registrarFor(key);
    return false;
  }
}
