import "dart:convert";
import 'parse.dart';
import 'parse_configuration.dart';
import 'package:web_socket_channel/io.dart';
import 'parse_http_client.dart';
import 'dart:io';

class LiveQuery {
  final ParseHTTPClient client;
  var channel;
  Map<String, dynamic> connectMessage;
  Map<String, dynamic> subscribeMessage;
  Map<String, Function> eventCallbacks = {};

  LiveQuery() : client = Parse.getInstance().client {
    connectMessage = {
      "op": "connect",
      "applicationId": ParseConfiguration().getApplicationId(),
    };

    subscribeMessage = {
      "op": "subscribe",
      "requestId": 1,
      "query": {
        "className": null,
        "where": {},
      }
    };
  }

  subscribe(String className) async {
    var webSocket = await WebSocket.connect(client.parseInstance.liveQueryUrl);
    channel = await new IOWebSocketChannel(webSocket);
    channel.sink.add(JsonEncoder().convert(connectMessage));
    subscribeMessage['query']['className'] = className;
    channel.sink.add(JsonEncoder().convert(subscribeMessage));
    channel.stream.listen((message) {
      Map<String, dynamic> actionData = JsonDecoder().convert(message);
      if (eventCallbacks.containsKey(actionData['op']))
        eventCallbacks[actionData['op']](actionData);
    });
  }

  void on(String op, Function callback) {
    eventCallbacks[op] = callback;
  }

  void close() {
    channel.close();
  }
}