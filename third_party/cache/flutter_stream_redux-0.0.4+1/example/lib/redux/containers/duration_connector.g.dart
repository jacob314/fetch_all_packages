// GENERATED CODE - DO NOT MODIFY BY HAND

part of duration_connector;

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

class _$DurationViewModel extends DurationViewModel {
  @override
  final Duration duration;
  @override
  final DurationChanged durationChanged;

  factory _$DurationViewModel([void updates(DurationViewModelBuilder b)]) =>
      (new DurationViewModelBuilder()..update(updates)).build();

  _$DurationViewModel._({this.duration, this.durationChanged}) : super._() {
    if (duration == null)
      throw new BuiltValueNullFieldError('DurationViewModel', 'duration');
    if (durationChanged == null)
      throw new BuiltValueNullFieldError(
          'DurationViewModel', 'durationChanged');
  }

  @override
  DurationViewModel rebuild(void updates(DurationViewModelBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  DurationViewModelBuilder toBuilder() =>
      new DurationViewModelBuilder()..replace(this);

  @override
  bool operator ==(dynamic other) {
    if (identical(other, this)) return true;
    if (other is! DurationViewModel) return false;
    return duration == other.duration &&
        durationChanged == other.durationChanged;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, duration.hashCode), durationChanged.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('DurationViewModel')
          ..add('duration', duration)
          ..add('durationChanged', durationChanged))
        .toString();
  }
}

class DurationViewModelBuilder
    implements Builder<DurationViewModel, DurationViewModelBuilder> {
  _$DurationViewModel _$v;

  Duration _duration;
  Duration get duration => _$this._duration;
  set duration(Duration duration) => _$this._duration = duration;

  DurationChanged _durationChanged;
  DurationChanged get durationChanged => _$this._durationChanged;
  set durationChanged(DurationChanged durationChanged) =>
      _$this._durationChanged = durationChanged;

  DurationViewModelBuilder();

  DurationViewModelBuilder get _$this {
    if (_$v != null) {
      _duration = _$v.duration;
      _durationChanged = _$v.durationChanged;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DurationViewModel other) {
    if (other == null) throw new ArgumentError.notNull('other');
    _$v = other as _$DurationViewModel;
  }

  @override
  void update(void updates(DurationViewModelBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$DurationViewModel build() {
    final _$result = _$v ??
        new _$DurationViewModel._(
            duration: duration, durationChanged: durationChanged);
    replace(_$result);
    return _$result;
  }
}
