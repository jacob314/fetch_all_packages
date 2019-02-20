import 'package:rxdart/rxdart.dart';

class GlueRX {
  Map<Type, List<Function>> _callbacks = new Map<Type, List<Function>>();
  final PublishSubject<dynamic> subject = PublishSubject<dynamic>();

  GlueRX() {
    subject.listen((event) {
      if (_callbacks.containsKey(event.runtimeType)) {
        _callbacks[event.runtimeType]
            .forEach((f) => Function.apply(f, [event]));
      }
    });
  }

  pushEvent(event) => subject.add(event);
  bool isEmpty() => _callbacks.isEmpty;

  on<T>(void onData(T event)) {
    if (!_callbacks.containsKey(T)) _callbacks[T] = List<Function>();
    if (!_callbacks[T].contains(onData)) _callbacks[T].add(onData);
  }

  off<T>(void onData(T event)) {
    if (!_callbacks.containsKey(T)) return;
    if (!_callbacks[T].contains(onData)) return;
    _callbacks[T].remove(onData);
    if (_callbacks[T].length == 0) {
      _callbacks.remove(T);
    }
  }

  dispose() => subject.close();
}
