package io.flutter.plugins;

import io.flutter.plugin.common.PluginRegistry;
import xyz.luan.audioplayers.AudioplayersPlugin;
import io.flutter.plugins.ConnectivityswiftPlugin;
import com.sendo.coreplugin.CorePlugin;
import io.flutter.plugins.deviceinfo.DeviceInfoPlugin;
import flutteraddcalendar.fluttervn.io.flutteraddcalendar.FlutterAddCalendarPlugin;
import io.fluttervn.flutteryoutubeextractor.FlutterYoutubeExtractorPlugin;
import io.flutter.plugins.pathprovider.PathProviderPlugin;
import com.ly.settings.SettingsPlugin;
import io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin;
import io.flutter.plugins.videoplayer.VideoPlayerPlugin;

/**
 * Generated file. Do not edit.
 */
public final class GeneratedPluginRegistrant {
  public static void registerWith(PluginRegistry registry) {
    if (alreadyRegisteredWith(registry)) {
      return;
    }
    AudioplayersPlugin.registerWith(registry.registrarFor("xyz.luan.audioplayers.AudioplayersPlugin"));
    ConnectivityswiftPlugin.registerWith(registry.registrarFor("io.flutter.plugins.ConnectivityswiftPlugin"));
    CorePlugin.registerWith(registry.registrarFor("com.sendo.coreplugin.CorePlugin"));
    DeviceInfoPlugin.registerWith(registry.registrarFor("io.flutter.plugins.deviceinfo.DeviceInfoPlugin"));
    FlutterAddCalendarPlugin.registerWith(registry.registrarFor("flutteraddcalendar.fluttervn.io.flutteraddcalendar.FlutterAddCalendarPlugin"));
    FlutterYoutubeExtractorPlugin.registerWith(registry.registrarFor("io.fluttervn.flutteryoutubeextractor.FlutterYoutubeExtractorPlugin"));
    PathProviderPlugin.registerWith(registry.registrarFor("io.flutter.plugins.pathprovider.PathProviderPlugin"));
    SettingsPlugin.registerWith(registry.registrarFor("com.ly.settings.SettingsPlugin"));
    SharedPreferencesPlugin.registerWith(registry.registrarFor("io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin"));
    VideoPlayerPlugin.registerWith(registry.registrarFor("io.flutter.plugins.videoplayer.VideoPlayerPlugin"));
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
