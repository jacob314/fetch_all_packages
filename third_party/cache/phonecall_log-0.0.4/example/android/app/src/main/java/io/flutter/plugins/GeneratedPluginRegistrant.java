package io.flutter.plugins;

import io.flutter.plugin.common.PluginRegistry;
import com.dibi.phonecalllog.PhonecallLogPlugin;

/**
 * Generated file. Do not edit.
 */
public final class GeneratedPluginRegistrant {
  public static void registerWith(PluginRegistry registry) {
    if (alreadyRegisteredWith(registry)) {
      return;
    }
    PhonecallLogPlugin.registerWith(registry.registrarFor("com.dibi.phonecalllog.PhonecallLogPlugin"));
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
