package com.shareclarity.stripecard;

import android.content.Context;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class StripeCardFactory extends PlatformViewFactory {
    private final BinaryMessenger messenger;
    private PluginRegistry.Registrar registrar;
    public StripeCardFactory(BinaryMessenger messenger, PluginRegistry.Registrar _registrar) {
        super(StandardMessageCodec.INSTANCE);
        this.messenger = messenger;
        this.registrar = _registrar;
    }

    @Override
    public PlatformView create(Context context, int id, Object o) {
        return new StripeCardView(context, messenger, id, o, registrar);
    }
}
