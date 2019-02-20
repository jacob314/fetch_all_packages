package fleamarket.taobao.com.xservicekit.service;

import java.util.Map;

import fleamarket.taobao.com.xservicekit.handler.MessageHandler;
import io.flutter.plugin.common.MethodChannel;

public interface Service {

    String serviceName();

    String methodChannelName();

    String eventChannelName();

    void didRecieveEventSink(EventSink eventSink , Object args);

    void didCancelEvenStream(Object args);

    void emitEvent(Map obj);

    void invoke(String name, Object args, String chanelName, MethodChannel.Result result);

    void registerHandler(MessageHandler handler);

    void start();

    void end();
}
