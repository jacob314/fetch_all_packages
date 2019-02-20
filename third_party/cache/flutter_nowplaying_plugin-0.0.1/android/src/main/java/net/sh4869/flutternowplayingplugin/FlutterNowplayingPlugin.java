package net.sh4869.flutternowplayingplugin;

import android.util.Log;

import net.sh4869.flutternowplayingplugin.types.Track;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * FlutterNowplayingPlugin
 */
public class FlutterNowplayingPlugin implements MethodCallHandler {
    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel =
                new MethodChannel(registrar.messenger(), "flutter_nowplaying_plugin");
        channel.setMethodCallHandler(new FlutterNowplayingPlugin());
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        if (call.method.equals("getCurrentTrack")) {
            Track track = TrackStatus.getTrack();
            if(track != null){
                result.success(track.toMap());
            } else {
                result.error("no song played","",null);
            }
        } else {
            result.notImplemented();
        }
    }
}
