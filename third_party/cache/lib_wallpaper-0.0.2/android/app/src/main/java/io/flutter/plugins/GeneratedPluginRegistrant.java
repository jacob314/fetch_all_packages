package io.flutter.plugins;

import io.flutter.plugin.common.PluginRegistry;
import com.zzq.lib.libwallpaper.LibWallpaperPlugin;

/**
 * Generated file. Do not edit.
 */
public final class GeneratedPluginRegistrant {
  public static void registerWith(PluginRegistry registry) {
    if (alreadyRegisteredWith(registry)) {
      return;
    }
    LibWallpaperPlugin.registerWith(registry.registrarFor("com.zzq.lib.libwallpaper.LibWallpaperPlugin"));
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
