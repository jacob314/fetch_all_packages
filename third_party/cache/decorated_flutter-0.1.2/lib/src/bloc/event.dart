import 'dart:async';

import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:rxdart/rxdart.dart';

import '../utils/log.dart';

typedef void Listener<T>(T data);
typedef bool Equal<T>(T data1, T data2);

/// 既可以输入又可以输出的事件
@Deprecated('使用bloc_io中的IO代替')
class Event<T> {
  Event({
    /// 判断新值与旧值是否相同
    Equal test,

    /// 是否只有不同的值(由[_test]定义不同, 如果[_test]为空, 那么直接用[==]判断)才发射新数据
    bool isDistinct = false,

    /// 初始值, 传递给内部的[_subject]
    T seedValue,

    /// 是否接受null
    bool acceptNull = false,

    /// Event代表的语义
    String semantics,

    /// 是否同步发射数据, 传递给内部的[_subject]
    bool sync = true,

    /// 是否使用BehaviorSubject, 如果使用, 那么Event内部的[_subject]会保存最近一次的值
    /// 默认为false
    bool isBehavior = false,
  })  : _test = test,
        _isDistinct = isDistinct,
        _seedValue = seedValue,
        _acceptNull = acceptNull,
        _semantics = semantics {
    _subject = isBehavior
        ? BehaviorSubject<T>(seedValue: seedValue, sync: sync)
        : PublishSubject<T>(sync: sync);

    stream = _subject.stream;

    _subject.listen((data) {
      latest = data;
      L.p('当前${semantics ??= data.runtimeType.toString()} latest: $latest'
          '\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
    });

    latest = seedValue;
  }

  /// 最新的值
  T latest;

  /// 输出Stream
  Observable<T> stream;

  /// 输出Future
  Future<T> get first => stream.first;

  final Equal _test;
  final bool _isDistinct;
  final T _seedValue;
  bool _acceptNull;
  String _semantics;
  Subject<T> _subject;

  void add(T data) {
    L.p('++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n'
        'Event接收到**${_semantics ??= data.runtimeType.toString()}**数据: $data');

    if (isEmpty(data) && !_acceptNull) {
      return;
    }

    // 如果需要distinct的话, 就判断是否相同; 如果不需要distinct, 直接发射数据
    if (_isDistinct) {
      // 如果是不一样的数据, 才发射新的通知,防止TabBar的addListener那种
      // 不停地发送通知(但是值又是一样)的情况
      if (_test != null) {
        if (!_test(latest, data)) {
          L.p('Event转发出**${_semantics ??= data.runtimeType.toString()}**数据: $data');
          _subject.add(data);
        }
      } else {
        if (data != latest) {
          L.p('Event转发出**${_semantics ??= data.runtimeType.toString()}**数据: $data');
          _subject.add(data);
        }
      }
    } else {
      L.p('Event转发出**${_semantics ??= data.runtimeType.toString()}**数据: $data');
      _subject.add(data);
    }
  }

  void addIfAbsent(T data) {
    // 如果最新值是_seedValue或者是空, 那么才add新数据, 换句话说, 就是如果event已经被add过
    // 了的话那就不add了, 用于第一次add
    if (_seedValue == latest || isEmpty(latest)) {
      add(data);
    }
  }

  void addError(Object error, [StackTrace stackTrace]) {
    _subject.addError(error, stackTrace);
  }

  Observable<T> addStream(Stream<T> source, {bool cancelOnError: true}) {
    return Observable<T>(
      _subject..addStream(source, cancelOnError: cancelOnError),
    );
  }

  AsObservableFuture<T> addFuture(Future<T> source,
      {bool cancelOnError: true}) {
    return Observable.fromFuture((_subject
              ..addStream(source.asStream(), cancelOnError: cancelOnError))
            .first)
        .first;
  }

  void listen(
    Listener<T> listener, {
    Function onError,
    void onDone(),
    bool cancelOnError,
  }) {
    stream.listen(
      (data) {
        if (data == null && _acceptNull) {
          listener(data);
        } else if (data != null) {
          listener(data);
        }
      },
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  Observable<S> map<S>(S convert(T event)) {
    return _subject.map(convert);
  }

  Observable<T> where(bool test(T event)) {
    return _subject.where(test);
  }

  void clear() {
    L.p('----------------------------------------------------------------\n'
        '${_semantics ??= runtimeType.toString()}事件 cleared '
        '\n----------------------------------------------------------------');
    latest = _seedValue;
    _subject.add(_seedValue);
  }

  void close() {
    L.p('==============================================================\n'
        '${_semantics ??= runtimeType.toString()}事件 closed '
        '\n==============================================================');
    _subject.close();
  }

  String runtimeSummary() {
    return '''
    $_semantics:
        seedValue: $_seedValue,
        latest: $latest
    ''';
  }

  @override
  String toString() {
    return 'Event{latest: $latest, stream: $stream, test: $_test, isDistinct: $_isDistinct, seedValue: $_seedValue, acceptNull: $_acceptNull, semantics: $_semantics, _subject: $_subject}';
  }
}
