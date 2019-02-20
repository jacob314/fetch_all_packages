package com.plugin.flutterpluginyoutubeplayer;

import io.flutter.plugin.common.PluginRegistry;

public class YoutubePlayerPlugin {
    public static void registerWith(PluginRegistry.Registrar registrar) {
        registrar.platformViewRegistry().registerViewFactory("plugins.plugin.com/flutterpluginyoutubeplayer", new YoutubePlayerFactory(registrar.messenger()));
    }
}