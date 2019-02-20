package com.plugin.flutterpluginyoutubeplayer;

import android.content.Context;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class YoutubePlayerFactory extends PlatformViewFactory {

    private final BinaryMessenger messenger;

    public YoutubePlayerFactory(BinaryMessenger messenger) {
        super(StandardMessageCodec.INSTANCE);
        this.messenger = messenger;
    }

    @Override
    public PlatformView create(Context context, int id, Object o) {
        return new FlutterYoutubePlayerView(context, messenger, id);
    }
}