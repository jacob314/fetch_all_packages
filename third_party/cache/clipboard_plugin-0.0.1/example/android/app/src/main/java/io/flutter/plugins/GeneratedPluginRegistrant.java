package io.flutter.plugins;

import io.flutter.plugin.common.PluginRegistry;
import com.rongzhixin.clipboardplugin.ClipboardPlugin;

/**
 * Generated file. Do not edit.
 */
public final class GeneratedPluginRegistrant {
  public static void registerWith(PluginRegistry registry) {
    if (alreadyRegisteredWith(registry)) {
      return;
    }
    ClipboardPlugin.registerWith(registry.registrarFor("com.rongzhixin.clipboardplugin.ClipboardPlugin"));
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
