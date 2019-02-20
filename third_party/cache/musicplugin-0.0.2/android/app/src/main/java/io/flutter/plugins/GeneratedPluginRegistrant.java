package io.flutter.plugins;

import io.flutter.plugin.common.PluginRegistry;
import com.sahdeepsingh.musicplugin.MusicpluginPlugin;

/**
 * Generated file. Do not edit.
 */
public final class GeneratedPluginRegistrant {
  public static void registerWith(PluginRegistry registry) {
    if (alreadyRegisteredWith(registry)) {
      return;
    }
    MusicpluginPlugin.registerWith(registry.registrarFor("com.sahdeepsingh.musicplugin.MusicpluginPlugin"));
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
