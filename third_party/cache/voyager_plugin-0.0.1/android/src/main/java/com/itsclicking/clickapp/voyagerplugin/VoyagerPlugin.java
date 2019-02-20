package com.itsclicking.clickapp.voyagerplugin;

import android.util.Log;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * VoyagerPlugin
 */
public class VoyagerPlugin implements MethodCallHandler {
    /**
     * Plugin registration.
     */
    private static MethodChannel channel;
    public static void registerWith(Registrar registrar) {
        channel = new MethodChannel(registrar.messenger(), "voyager_plugin");
        channel.setMethodCallHandler(new VoyagerPlugin());
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        switch (call.method) {
            case SocketIOManager.MethodCallName.SOCKET_CONNECT:
                String socketChannel = call.argument(SocketIOManager.MethodCallArgumentsName.SOCKET_CHANNEL);
                String callbackStatus = call.argument(SocketIOManager.MethodCallArgumentsName.SOCKET_STATUS_CALLBACK);
                if (!Utils.isNullOrEmpty(socketChannel)) {
                    SocketIOManager.getInstance().connectSocket(channel, socketChannel, callbackStatus);
                }
                break;
            case SocketIOManager.MethodCallName.SOCKET_DISCONNECT:
                break;
            case SocketIOManager.MethodCallName.SOCKET_SUBSCRIBES:
                Map<String, String> map = new HashMap<>();
                map.put("chat_direct", "onReceiveChatMessage");
                SocketIOManager.getInstance().subscribes(channel, map);
                break;
            case SocketIOManager.MethodCallName.SOCKET_UNSUBSCRIBES:
                break;
            case SocketIOManager.MethodCallName.SOCKET_SEND_MESSAGE:
                String event = call.argument(SocketIOManager.MethodCallArgumentsName.SOCKET_EVENT);
                String message = call.argument(SocketIOManager.MethodCallArgumentsName.SOCKET_MESSAGE);
                Log.d("SocketIOManager", event + message);
                if(!Utils.isNullOrEmpty(event) && !Utils.isNullOrEmpty(message)) {
                    SocketIOManager.getInstance().sendMessage(event, message);
                }
                break;
            default:
                result.notImplemented();
                break;
        }
    }
}
