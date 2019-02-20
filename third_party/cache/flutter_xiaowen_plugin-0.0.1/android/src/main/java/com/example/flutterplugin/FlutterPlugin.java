package com.example.flutterplugin;

import android.app.Application;

import java.lang.reflect.Method;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * FlutterPlugin
 */
public class FlutterPlugin implements MethodCallHandler {

    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_plugin");
        channel.setMethodCallHandler(new FlutterPlugin());
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        if (call.method.equals("getPlatformVersion")) {
            result.success("Android " + android.os.Build.VERSION.RELEASE);
        } else if (call.method.equals("getPackageName")) {
            result.success("com.example.flutter_plugin");
        } else if (call.method.equals("getCurrentApplication")) {
            String applicationName;
            try {
                Class<?> clazz = Class.forName("android.app.ActivityThread");
                Method method = clazz.getDeclaredMethod("currentActivityThread");
                method.setAccessible(true);
                Object currentActivityThread = method.invoke(null);
                Method getApplication = clazz.getDeclaredMethod("getApplication");
                getApplication.setAccessible(true);
                Application application = (Application) getApplication.invoke(currentActivityThread);
                applicationName = application.getClass().getSimpleName();
            } catch (Exception e) {
                e.printStackTrace();
                applicationName = "DefaultApplicationName";
            }
            result.success(applicationName);
        } else {
            result.notImplemented();
        }
    }
}
