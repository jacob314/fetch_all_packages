package com.itsclicking.clickapp.voyagerplugin;

import java.util.Map;

import io.flutter.plugin.common.MethodChannel;

public interface ISocketIOManager {
    void connectSocket(MethodChannel channel, final String socketChannel, final String callbackStatus);
    void sendMessage(String event, String message);
    void subscribes(final MethodChannel channel, Map<String, String> subscribes);
    void unSubscribes(final MethodChannel channel, Map<String, String> subscribes);
    void disconnect();
    boolean isSocketConnected();
}
