import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

typedef bool _Equal<T>(T data1, T data2);
typedef Future<T> _Trigger<T>(Object arg);

/// BLoC内的静态值, 也就是供初始化时的值, 之前都是直接写成字段, 这里提供一个类, 保持与IO的一致性
class Static<T> {
  T _content;

  void set(T value) {
    assert(_content == null);
    if (_content != null) {
      throw '';
    }
    _content = value;
  }

  T get() => _content;
}

/// 业务单元基类
abstract class BaseIO<T> {
  BaseIO({
    /// 初始值, 传递给内部的[subject]
    this.seedValue,

    /// Event代表的语义
    this.semantics,

    /// 是否同步发射数据, 传递给内部的[subject]
    bool sync = true,

    /// 是否使用BehaviorSubject, 如果使用, 那么Event内部的[subject]会保存最近一次的值
    /// 默认为false
    bool isBehavior = false,
  }) {
    subject = isBehavior
        ? BehaviorSubject<T>(seedValue: seedValue, sync: sync)
        : PublishSubject<T>(sync: sync);

    subject.listen((data) {
      latest = data;
      L.p('当前${semantics ??= data.runtimeType.toString()} latest: $latest'
          '\n+++++++++++++++++++++++++++END+++++++++++++++++++++++++++++');
    });

    latest = seedValue;
  }

  /// 最新的值
  T latest;

  /// 初始值
  @protected
  T seedValue;

  /// 语义
  @protected
  String semantics;

  /// 内部中转对象
  @protected
  Subject<T> subject;

  void addError(Object error, [StackTrace stackTrace]) {
    subject.addError(error, stackTrace);
  }

  Observable<S> map<S>(S convert(T event)) {
    return subject.map(convert);
  }

  Observable<T> where(bool test(T event)) {
    return subject.where(test);
  }

  /// 清理保存的值, 恢复成初始状态
  void clear() {
    L.p('-----------------------------BEGIN---------------------------------\n'
        '${semantics ??= runtimeType.toString()}事件 cleared '
        '\n------------------------------END----------------------------------');
    subject.add(seedValue);
  }

  /// 关闭流
  void dispose() {
    L.p('=============================BEGIN===============================\n'
        '${semantics ??= runtimeType.toString()}事件 disposed '
        '\n==============================END================================');
    subject.close();
  }

  /// 运行时概要
  String runtimeSummary() {
    return '$semantics:\n\t\tseedValue: $seedValue,\n\t\tlatest: $latest';
  }

  @override
  String toString() {
    return 'Output{latest: $latest, seedValue: $seedValue, semantics: $semantics, subject: $subject}';
  }
}

/// 只输入数据的业务单元
class Input<T> extends BaseIO<T> with InputMixin {
  Input({
    T seedValue,
    String semantics,
    bool sync = true,
    bool isBehavior = false,
    bool acceptEmpty = true,
    bool isDistinct = false,
    _Equal test,
  }) : super(
          seedValue: seedValue,
          semantics: semantics,
          sync: sync,
          isBehavior: isBehavior,
        ) {
    _acceptEmpty = acceptEmpty;
    _isDistinct = isDistinct;
    _test = test;
  }
}

/// 内部数据类型是[List]的输入业务单元
class ListInput<T> extends Input<List<T>> with ListMixin {
  ListInput({
    List<T> seedValue,
    String semantics,
    bool sync = true,
    bool isBehavior = false,
    bool acceptEmpty = true,
    bool isDistinct = false,
    _Equal test,
  }) : super(
          seedValue: seedValue,
          semantics: semantics,
          sync: sync,
          isBehavior: isBehavior,
          acceptEmpty: acceptEmpty,
          isDistinct: isDistinct,
          test: test,
        );
}

/// 只输出数据的业务单元
class Output<T> extends BaseIO<T> with OutputMixin {
  Output({
    T seedValue,
    String semantics,
    bool sync = true,
    bool isBehavior = false,
    @required _Trigger<T> trigger,
  }) : super(
          seedValue: seedValue,
          semantics: semantics,
          sync: sync,
          isBehavior: isBehavior,
        ) {
    stream = subject.stream;
    _trigger = trigger;
  }
}

/// 内部数据类型是[List]的输出业务单元
class ListOutput<T> extends Output<List<T>> with ListMixin {
  ListOutput({
    List<T> seedValue,
    String semantics,
    bool sync = true,
    bool isBehavior = false,
    @required _Trigger<List<T>> trigger,
  }) : super(
          seedValue: seedValue,
          semantics: semantics,
          sync: sync,
          isBehavior: isBehavior,
          trigger: trigger,
        );
}

/// 既可以输入又可以输出的事件
class IO<T> extends BaseIO<T> with InputMixin, OutputMixin {
  IO({
    T seedValue,
    String semantics,
    bool sync = true,
    bool isBehavior = false,
    bool acceptEmpty = true,
    bool isDistinct = false,
    _Equal test,
    _Trigger<T> trigger,
  }) : super(
          seedValue: seedValue,
          semantics: semantics,
          sync: sync,
          isBehavior: isBehavior,
        ) {
    stream = subject.stream;

    _acceptEmpty = acceptEmpty;
    _isDistinct = isDistinct;
    _test = test;
    _trigger = trigger;
  }
}

/// 内部数据类型是[List]的输入输出业务单元
class ListIO<T> extends IO<List<T>> with ListMixin {
  ListIO({
    List<T> seedValue,
    String semantics,
    bool sync = true,
    bool isBehavior = false,
    bool acceptEmpty = true,
    bool isDistinct = false,
    _Equal test,
    _Trigger<List<T>> trigger,
  }) : super(
          seedValue: seedValue,
          semantics: semantics,
          sync: sync,
          isBehavior: isBehavior,
          acceptEmpty: acceptEmpty,
          isDistinct: isDistinct,
          test: test,
          trigger: trigger,
        );
}

/// 输入单元特有的成员
mixin InputMixin<T> on BaseIO<T> {
  bool _acceptEmpty;
  bool _isDistinct;
  _Equal _test;

  void add(T data) {
    L.p('+++++++++++++++++++++++++++BEGIN+++++++++++++++++++++++++++++\n'
        'IO接收到**${semantics ??= data.runtimeType.toString()}**数据: $data');

    if (isEmpty(data) && !_acceptEmpty) {
      L.p('转发被拒绝! 原因: 需要非Empty值, 但是接收到Empty值'
          '\n+++++++++++++++++++++++++++END+++++++++++++++++++++++++++++++');
      return;
    }

    // 如果需要distinct的话, 就判断是否相同; 如果不需要distinct, 直接发射数据
    if (_isDistinct) {
      // 如果是不一样的数据, 才发射新的通知,防止TabBar的addListener那种
      // 不停地发送通知(但是值又是一样)的情况
      if (_test != null) {
        if (!_test(latest, data)) {
          L.p('IO转发出**${semantics ??= data.runtimeType.toString()}**数据: $data');
          subject.add(data);
        } else {
          L.p('转发被拒绝! 原因: 需要唯一, 但是没有通过唯一性测试'
              '\n+++++++++++++++++++++++++++END+++++++++++++++++++++++++++++');
        }
      } else {
        if (data != latest) {
          L.p('IO转发出**${semantics ??= data.runtimeType.toString()}**数据: $data');
          subject.add(data);
        } else {
          L.p('转发被拒绝! 原因: 需要唯一, 但是新数据与最新值相同'
              '\n+++++++++++++++++++++++++++END+++++++++++++++++++++++++++++');
        }
      }
    } else {
      L.p('IO转发出**${semantics ??= data.runtimeType.toString()}**数据: $data');
      subject.add(data);
    }
  }

  void addIfAbsent(T data) {
    // 如果最新值是_seedValue或者是空, 那么才add新数据, 换句话说, 就是如果event已经被add过
    // 了的话那就不add了, 用于第一次add
    if (seedValue == latest || isEmpty(latest)) {
      add(data);
    }
  }
}

/// 输出单元特有的成员
mixin OutputMixin<T> on BaseIO<T> {
  /// 输出Future
  Future<T> get future => stream.first;

  /// 输出Stream
  Observable<T> stream;

  void listen(
    ValueChanged<T> listener, {
    Function onError,
    VoidCallback onDone,
    bool cancelOnError,
  }) {
    stream.listen(
      listener,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  /// 输出Stream
  _Trigger<T> _trigger;

  /// 使用内部的trigger获取数据
  Future<T> update([Object arg]) {
    return _trigger(arg)
      ..then(subject.add)
      ..catchError(subject.addError);
  }
}

/// 内部数据是[List]特有的成员
mixin ListMixin<T> on BaseIO<List<T>> {
  /// 按条件过滤, 并发射过滤后的数据
  ///
  /// 这里有两种情况:
  ///   1. [subject]是[PublishSubject], 那么直接发射即可, 不改变[latest]的值
  ///   2. [subject]是[BehaviorSubject], 为了和[BehaviorSubject]内部的最新值同步, [latest]需要设置成过滤后的值
  /// 这里的行为还没有最终定稿, 等用例多一些之后再做最终的行为定义.
  void filterItem(bool test(T element)) {
    if (subject is PublishSubject) {
      subject.add(latest.where(test).toList());
    } else if (subject is BehaviorSubject) {
      final filtered = latest.where(test).toList();
      subject.add(filtered);
      latest = filtered;
    }

    L.d('ListMixin: $latest');
  }
}
