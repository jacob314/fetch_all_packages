// GENERATED CODE - DO NOT MODIFY BY HAND

part of app_state;

// **************************************************************************
// Generator: BuiltValueGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line
// ignore_for_file: annotate_overrides
// ignore_for_file: avoid_annotating_with_dynamic
// ignore_for_file: avoid_returning_this
// ignore_for_file: omit_local_variable_types
// ignore_for_file: prefer_expression_function_bodies
// ignore_for_file: sort_constructors_first

Serializer<AppState> _$appStateSerializer = new _$AppStateSerializer();

class _$AppStateSerializer implements StructuredSerializer<AppState> {
  @override
  final Iterable<Type> types = const [AppState, _$AppState];
  @override
  final String wireName = 'AppState';

  @override
  Iterable serialize(Serializers serializers, AppState object,
      {FullType specifiedType: FullType.unspecified}) {
    final result = <Object>[
      'now',
      serializers.serialize(object.now, specifiedType: const FullType(int)),
      'isStarted',
      serializers.serialize(object.isStarted,
          specifiedType: const FullType(bool)),
      'duration',
      serializers.serialize(object.duration,
          specifiedType: const FullType(Duration)),
    ];

    return result;
  }

  @override
  AppState deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType: FullType.unspecified}) {
    final result = new AppStateBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'now':
          result.now = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'isStarted':
          result.isStarted = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'duration':
          result.duration = serializers.deserialize(value,
              specifiedType: const FullType(Duration)) as Duration;
          break;
      }
    }

    return result.build();
  }
}

class _$AppState extends AppState {
  @override
  final int now;
  @override
  final bool isStarted;
  @override
  final Duration duration;

  factory _$AppState([void updates(AppStateBuilder b)]) =>
      (new AppStateBuilder()..update(updates)).build();

  _$AppState._({this.now, this.isStarted, this.duration}) : super._() {
    if (now == null) throw new BuiltValueNullFieldError('AppState', 'now');
    if (isStarted == null)
      throw new BuiltValueNullFieldError('AppState', 'isStarted');
    if (duration == null)
      throw new BuiltValueNullFieldError('AppState', 'duration');
  }

  @override
  AppState rebuild(void updates(AppStateBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  AppStateBuilder toBuilder() => new AppStateBuilder()..replace(this);

  @override
  bool operator ==(dynamic other) {
    if (identical(other, this)) return true;
    if (other is! AppState) return false;
    return now == other.now &&
        isStarted == other.isStarted &&
        duration == other.duration;
  }

  @override
  int get hashCode {
    return $jf(
        $jc($jc($jc(0, now.hashCode), isStarted.hashCode), duration.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('AppState')
          ..add('now', now)
          ..add('isStarted', isStarted)
          ..add('duration', duration))
        .toString();
  }
}

class AppStateBuilder implements Builder<AppState, AppStateBuilder> {
  _$AppState _$v;

  int _now;
  int get now => _$this._now;
  set now(int now) => _$this._now = now;

  bool _isStarted;
  bool get isStarted => _$this._isStarted;
  set isStarted(bool isStarted) => _$this._isStarted = isStarted;

  Duration _duration;
  Duration get duration => _$this._duration;
  set duration(Duration duration) => _$this._duration = duration;

  AppStateBuilder();

  AppStateBuilder get _$this {
    if (_$v != null) {
      _now = _$v.now;
      _isStarted = _$v.isStarted;
      _duration = _$v.duration;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AppState other) {
    if (other == null) throw new ArgumentError.notNull('other');
    _$v = other as _$AppState;
  }

  @override
  void update(void updates(AppStateBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$AppState build() {
    final _$result = _$v ??
        new _$AppState._(now: now, isStarted: isStarted, duration: duration);
    replace(_$result);
    return _$result;
  }
}
