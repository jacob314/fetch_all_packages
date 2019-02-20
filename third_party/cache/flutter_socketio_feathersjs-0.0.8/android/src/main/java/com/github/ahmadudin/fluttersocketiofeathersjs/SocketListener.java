package com.github.ahmadudin.fluttersocketiofeathersjs;

import com.github.nkzawa.emitter.Emitter;

import io.flutter.plugin.common.MethodChannel;

public class SocketListener implements Emitter.Listener {

    private MethodChannel _methodChannel;
    private String _socketId;
    private String _event;
    private String _callback;

    public SocketListener(MethodChannel methodChannel, String socketId, String event, String callback) {
        _methodChannel = methodChannel;
        _socketId = socketId;
        _event = event;
        _callback = callback;
    }

    public String getCallback() {
        return _callback;
    }

    @Override
    public void call(Object... args) {
        // Utils.log("FINAL DATAAA", String.format("%s", args.length));
        String result = null;
        String error = null;
        String data = null;
        if (args.length == 1) {
            result = args[0].toString();
        } else {
            if (args[0] != null) {
                error = args[0].toString();
            }
            if (args[1] != null) {
                data = args[1].toString();
            }
    
            result = String.format("{\"error\": %s, \"data\": %s}", error, data);
        }

        if (args != null && _methodChannel != null && !Utils.isNullOrEmpty(_event)
                && !Utils.isNullOrEmpty(_callback)) {
            // Utils.log("ARGUMENTSS", args[1].toString());
            _methodChannel.invokeMethod(_socketId + "|" +_event + "|" + _callback, result);
        }
    }
}
