package com.shareclarity.voicerecognition;

import android.content.Context;
import android.graphics.Color;
import android.view.View;
import android.view.ViewParent;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class VoiceRecognitionFactory extends PlatformViewFactory {

    private final BinaryMessenger messenger;
    PluginRegistry.Registrar mRegistrar;
    public VoiceRecognitionFactory(BinaryMessenger messenger, PluginRegistry.Registrar registrar) {
        super(StandardMessageCodec.INSTANCE);
        mRegistrar = registrar;
        this.messenger = messenger;
    }

    @Override
    public PlatformView create(Context context, int id, Object o) {
        VoiceRecognitionView view = new VoiceRecognitionView(context, messenger, id, o, mRegistrar);
        return view;
    }

}
