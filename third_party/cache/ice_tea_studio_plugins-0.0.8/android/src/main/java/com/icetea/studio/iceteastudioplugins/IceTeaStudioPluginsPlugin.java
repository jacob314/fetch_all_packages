package com.icetea.studio.iceteastudioplugins;

import android.content.Context;
import android.util.Log;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** IceTeaStudioPluginsPlugin */
public class IceTeaStudioPluginsPlugin implements MethodCallHandler {

    private final Registrar mRegistrar;
    private long mLastTimeShowToast = 0;
    private static final int DELAY_TIME = 1000;

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "ice_tea_studio_plugins");
        channel.setMethodCallHandler(new IceTeaStudioPluginsPlugin(registrar));
    }

    private IceTeaStudioPluginsPlugin(Registrar registrar) {
        mRegistrar = registrar;
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        switch (call.method) {
            case MethodChannelName.CHANNEL_APP_VERSION:
                result.success("Android " + android.os.Build.VERSION.RELEASE);
                break;

            case MethodChannelName.CHANNEL_SHOW_TOAST:
                long currentTime = System.currentTimeMillis();
                Log.e("Test", "Current: " + currentTime + " Last show: " + mLastTimeShowToast);
                if (currentTime - mLastTimeShowToast > DELAY_TIME) {
                    mLastTimeShowToast = currentTime;
                    showToast(call);
                }

                break;

            default:
                result.notImplemented();
                break;
        }
    }

    private void showToast(MethodCall call) {
        if (!call.hasArgument("msg")) {
            return;
        }
        String msg = call.argument("msg");
        String backgroundColor = "#84bd00";
        String textColor = "#ffffff";
        String toastType = "short";
        String isFullWith = "false";
        String gravity = "bottom";
        int textSize = 9;

        if (call.hasArgument("backgroundColor")) {
            backgroundColor = call.argument("backgroundColor");
        }
        if (call.hasArgument("textColor")) {
            textColor = call.argument("textColor");
        }
        if (call.hasArgument("length")) {
            toastType = call.argument("length");
        }
        if (call.hasArgument("isFullWidth")) {
            isFullWith = call.argument("isFullWidth");
        }
        if (call.hasArgument("gravity")) {
            gravity = call.argument("gravity");
        }
        if (call.hasArgument("textSize")) {
            textSize = call.argument("textSize");
        }

        Utils.showToast(getActiveContext(), msg, backgroundColor, textColor, textSize,
                Utils.getToastType(toastType),
                Utils.convertStringToBoolean(isFullWith),
                Utils.getGravity(gravity));
    }

    private Context getActiveContext() {
        return (mRegistrar.activity() != null) ? mRegistrar.activity() : mRegistrar.context();
    }

    class MethodChannelName {
        static final String CHANNEL_APP_VERSION = "getPlatformVersion";
        static final String CHANNEL_SHOW_TOAST = "showToast";
    }
}
