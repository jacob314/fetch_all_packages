import 'package:glue/src/glue_rx.dart';

class Glue {
  static final Glue _internalHub = Glue();

  static void on<Channel, Event>(void onData(Event event)) {
    _internalHub._on<Channel, Event>(onData);
  }

  static void emit<Channel>(event) {
    _internalHub._emit<Channel>(event);
  }

  static void off<Channel, Event>(void onData(Event event)) {
    _internalHub._off<Channel, Event>(onData);
  }

  final Map<Type, GlueRX> _channels = Map<Type, GlueRX>();

  void _on<Channel, Event>(void onData(Event event)) {
    if (!_channels.containsKey(Channel)) _channels[Channel] = GlueRX();
    _channels[Channel].on<Event>(onData);
  }

  void _emit<Channel>(event) {
    if (!_channels.containsKey(Channel)) return;
    _channels[Channel].pushEvent(event);
  }

  void _off<Channel, Event>(void onData(Event event)) {
    if (!_channels.containsKey(Channel)) return;
    _channels[Channel].off<Event>(onData);
    if (_channels[Channel].isEmpty()) {
      _channels[Channel].dispose();
      _channels.remove(Channel);
    }
  }
}
