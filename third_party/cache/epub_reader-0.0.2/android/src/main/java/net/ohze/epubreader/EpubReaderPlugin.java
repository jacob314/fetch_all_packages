package net.ohze.epubreader;

import android.content.res.AssetManager;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * EpubReaderPlugin
 */
public class EpubReaderPlugin implements MethodCallHandler {
    private Registrar registrar;

    private EpubReaderPlugin(Registrar registrar) {
        this.registrar = registrar;
    }

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_plugin");
        channel.setMethodCallHandler(new EpubReaderPlugin(registrar));
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        System.out.println("onSearchAsset" + call.method);
        switch (call.method) {
            case "getPlatformVersion":
                result.success("Android " + android.os.Build.VERSION.RELEASE);
                break;
            case "onSearchAsset":
                String file = call.argument("key");
                AssetManager assetManager = registrar.context().getAssets();
                String key = registrar.lookupKeyForAsset(file);
                result.success(key);
                break;
            default:
                result.notImplemented();
        }
    }
}
