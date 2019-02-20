package com.bugsee.bugsee;

import android.graphics.Rect;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import com.bugsee.library.Bugsee;

/**
 * BugseePlugin
 */
public class BugseePlugin implements MethodCallHandler {
    private static class FlutterManagedException extends Throwable {
        public FlutterManagedException(String message) {
            super(message);
        }
    }
/**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "bugsee");
        channel.setMethodCallHandler(new BugseePlugin());
    }

    private void handleEvent(MethodCall call, final Result result) {
        @SuppressWarnings("unchecked")
        Map<String, Object> arguments = (Map<String, Object>) call.arguments;
        String name = (String)arguments.get("name");
        @SuppressWarnings("unchecked")
        HashMap<String, Object> parameters = (HashMap<String, Object>)arguments.get("parameters");
        Bugsee.event(name, parameters);
    }

    private void handleTrace(MethodCall call, final Result result) {
        @SuppressWarnings("unchecked")
        Map<String, Object> arguments = (Map<String, Object>) call.arguments;
        String name = (String)arguments.get("name");
        Object value = arguments.get("value");
        Bugsee.trace(name, value);
    }

    private void handleSetAttribute(MethodCall call, final Result result) {
        @SuppressWarnings("unchecked")
        Map<String, Object> arguments = (Map<String, Object>) call.arguments;
        String key = (String)arguments.get("key");
        Object value = arguments.get("value");
        Bugsee.setAttribute(key, value);
    }

    private void handleAddSecureRect(MethodCall call, final Result result) {
        @SuppressWarnings("unchecked")
        Map<String, Object> arguments = (Map<String, Object>) call.arguments;
        int x1 = ((Number)arguments.get("X")).intValue();
        int y1 = ((Number)arguments.get("Y")).intValue();
        int x2 = x1 + ((Number)arguments.get("Width")).intValue();
        int y2 = y1 + ((Number)arguments.get("Height")).intValue();
        Bugsee.addSecureRectangle(new Rect(x1 ,y1, x2, y2));
    }

    private void handleRemoveSecureRect(MethodCall call, final Result result) {
        @SuppressWarnings("unchecked")
        Map<String, Object> arguments = (Map<String, Object>) call.arguments;
        int x1 = ((Number)arguments.get("X")).intValue();
        int y1 = ((Number)arguments.get("Y")).intValue();
        int x2 = x1 + ((Number)arguments.get("Width")).intValue();
        int y2 = y1 + ((Number)arguments.get("Height")).intValue();
        Bugsee.removeSecureRectangle(new Rect(x1 ,y1, x2, y2));
    }

    private void handleRemoveAllSecureRects(MethodCall call, final Result result) {
        Bugsee.removeAllSecureRectangles();
    }

    private void handleLogException(MethodCall call, final Result result) {
        @SuppressWarnings("unchecked")
        Map<String, Object> arguments = (Map<String, Object>) call.arguments;
        String name = (String)arguments.get("name");
        String reason = (String)arguments.get("reason");
        Boolean isHandled = (Boolean)arguments.get("handled");

        FlutterManagedException ex = new FlutterManagedException(reason);

        if (isHandled) {
            Bugsee.logException(ex);
        } else {
            Bugsee.onUncaughtException(Thread.currentThread(), ex);
        }
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        switch (call.method) {
            case "event":
                handleEvent(call, result);
                break;

            case "trace":
                handleTrace(call, result);
                break;

            case "logException":
                handleLogException(call, result);
                break;

            case "setAttribute":
                handleSetAttribute(call, result);
                break;

            case "addSecureRect":
                handleAddSecureRect(call, result);
                break;

            case "removeSecureRect":
                handleRemoveSecureRect(call, result);
                break;

            case "removeAllSecureRects":
                handleRemoveAllSecureRects(call, result);
                break;

            default:
                result.notImplemented();
                break;
        }

    }
}
