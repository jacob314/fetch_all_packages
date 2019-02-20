package io.flutter.plugins;

import io.flutter.plugin.common.PluginRegistry;
import com.teamgrit.firstplugin.firstplugin.FirstPlugin;

/**
 * Generated file. Do not edit.
 */
public final class GeneratedPluginRegistrant {
  public static void registerWith(PluginRegistry registry) {
    if (alreadyRegisteredWith(registry)) {
      return;
    }
    FirstPlugin.registerWith(registry.registrarFor("com.teamgrit.firstplugin.firstplugin.FirstPlugin"));
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
