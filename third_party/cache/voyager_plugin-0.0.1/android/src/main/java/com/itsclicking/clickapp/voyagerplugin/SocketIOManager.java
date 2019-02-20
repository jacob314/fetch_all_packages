package com.itsclicking.clickapp.voyagerplugin;

import android.util.Log;

import com.github.nkzawa.emitter.Emitter;
import com.github.nkzawa.socketio.client.IO;
import com.github.nkzawa.socketio.client.Socket;

import java.net.URISyntaxException;
import java.util.Map;

import io.flutter.plugin.common.MethodChannel;

public class SocketIOManager implements ISocketIOManager {

    private static final String TAG = "SocketIOManager";
    private static ISocketIOManager mInstance;
    private Socket mSocket;

    public synchronized static ISocketIOManager getInstance() {
        if (mInstance == null) {
            mInstance = new SocketIOManager();
        }
        return mInstance;
    }

    private SocketIOManager() {
    }

    @Override
    public void connectSocket(MethodChannel channel, final String socketChannel, final String callbackStatus) {
        try {
            mSocket = IO.socket(socketChannel);  //in nodejs you may say that is localhost:3000, 127.0.0.1:3000...etc
            mSocket.connect();
            if (!Utils.isNullOrEmpty(callbackStatus)) {
                channel.invokeMethod(callbackStatus, "success");
            }
            Log.d(TAG, "connect success");
        } catch (URISyntaxException e) {
            Log.d(TAG, "connect fail : " + e.toString());
            if (!Utils.isNullOrEmpty(callbackStatus)) {
                channel.invokeMethod(callbackStatus, "failed");
            }
        }
    }

    @Override
    public void sendMessage(String event, String message) {
        if (isSocketConnected() && !Utils.isNullOrEmpty(event)
                && !Utils.isNullOrEmpty(message)) {
            mSocket.emit(event, message);
        }
    }

    @Override
    public void subscribes(final MethodChannel channel, Map<String, String> subscribes) {
        if (isSocketConnected() && channel != null) {
            if (subscribes != null && subscribes.size() > 0) {
                for (Map.Entry<String, String> sub : subscribes.entrySet()) {
                    if (!Utils.isNullOrEmpty(sub.getKey())) {
                        final String subCallback = sub.getValue();
                        mSocket.on(sub.getKey(), new Emitter.Listener() {
                            @Override
                            public void call(Object... args) {
                                if (!Utils.isNullOrEmpty(subCallback)) {
                                    channel.invokeMethod(subCallback, args[0].toString());
                                }
                            }
                        });
                    }
                }
            }
        }
    }

    @Override
    public void unSubscribes(final MethodChannel channel, Map<String, String> subscribes) {
        if (isSocketConnected() && channel != null) {
            if (subscribes != null && subscribes.size() > 0) {
                for (Map.Entry<String, String> sub : subscribes.entrySet()) {
                    if (!Utils.isNullOrEmpty(sub.getKey())) {
                        final String subCallback = sub.getValue();
                        mSocket.off(sub.getKey(), new Emitter.Listener() {
                            @Override
                            public void call(Object... args) {
                                if (!Utils.isNullOrEmpty(subCallback)) {
                                    channel.invokeMethod(subCallback, args[0].toString());
                                }
                            }
                        });
                    }
                }
            }
        }
    }

    @Override
    public void disconnect() {
        if (mSocket != null) {
            mSocket.disconnect();
        }
    }

    @Override
    public boolean isSocketConnected() {
        return mSocket != null && mSocket.connected();
    }

    public static class MethodCallArgumentsName {
        public static final String SOCKET_CHANNEL = "socketChannel";
        public static final String SOCKET_STATUS_CALLBACK = "socketStatusCallback";
        public static final String SOCKET_EVENT = "socketEvent";
        public static final String SOCKET_MESSAGE = "socketMessage";
    }

    public static class MethodCallName {
        public static final String SOCKET_CONNECT = "socketConnect";
        public static final String SOCKET_DISCONNECT = "socketDisconnect";
        public static final String SOCKET_SUBSCRIBES = "socketSubcribes";
        public static final String SOCKET_UNSUBSCRIBES = "socketUnsubcribes";
        public static final String SOCKET_SEND_MESSAGE = "socketSendMessage";
    }
}
