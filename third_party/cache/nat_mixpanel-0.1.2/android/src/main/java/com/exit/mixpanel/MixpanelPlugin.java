package com.exit.mixpanel;

import android.app.Application;
import android.content.Context;
import android.util.Log;

import com.mixpanel.android.mpmetrics.MixpanelAPI;


import org.json.JSONException;
import org.json.JSONObject;

import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;


public class MixpanelPlugin implements MethodCallHandler  {
    private MixpanelAPI mixpanel;
    private static Context context;

    public static void registerWith(Registrar registrar) {
        context = registrar.context();
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "mixpanel");
        channel.setMethodCallHandler(new MixpanelPlugin());
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        if (call.method.equals("init")) {
            String token = call.argument("token");
            mixpanel = MixpanelAPI.getInstance(context, token);
        } else if (call.method.equals("track")) {
            Map props = (Map) call.arguments;
            String eventName = (String) props.get("event");
            String properties = "";
            if (props.containsKey("properties"))
                properties = (props.get("properties")).toString();
            try {
                JSONObject pros = new JSONObject(properties);
                mixpanel.track(eventName, pros);
            } catch (JSONException ex) {
                mixpanel.track(eventName);
            }
        } else {
            result.notImplemented();
        }
    }
}
