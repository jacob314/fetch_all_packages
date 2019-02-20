// GENERATED CODE - DO NOT MODIFY BY HAND

part of now_container;

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

class _$NowViewModel extends NowViewModel {
  @override
  final int now;
  @override
  final ListenToStream listenToStream;

  factory _$NowViewModel([void updates(NowViewModelBuilder b)]) =>
      (new NowViewModelBuilder()..update(updates)).build();

  _$NowViewModel._({this.now, this.listenToStream}) : super._() {
    if (now == null) throw new BuiltValueNullFieldError('NowViewModel', 'now');
    if (listenToStream == null)
      throw new BuiltValueNullFieldError('NowViewModel', 'listenToStream');
  }

  @override
  NowViewModel rebuild(void updates(NowViewModelBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  NowViewModelBuilder toBuilder() => new NowViewModelBuilder()..replace(this);

  @override
  bool operator ==(dynamic other) {
    if (identical(other, this)) return true;
    if (other is! NowViewModel) return false;
    return now == other.now && listenToStream == other.listenToStream;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, now.hashCode), listenToStream.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('NowViewModel')
          ..add('now', now)
          ..add('listenToStream', listenToStream))
        .toString();
  }
}

class NowViewModelBuilder
    implements Builder<NowViewModel, NowViewModelBuilder> {
  _$NowViewModel _$v;

  int _now;
  int get now => _$this._now;
  set now(int now) => _$this._now = now;

  ListenToStream _listenToStream;
  ListenToStream get listenToStream => _$this._listenToStream;
  set listenToStream(ListenToStream listenToStream) =>
      _$this._listenToStream = listenToStream;

  NowViewModelBuilder();

  NowViewModelBuilder get _$this {
    if (_$v != null) {
      _now = _$v.now;
      _listenToStream = _$v.listenToStream;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NowViewModel other) {
    if (other == null) throw new ArgumentError.notNull('other');
    _$v = other as _$NowViewModel;
  }

  @override
  void update(void updates(NowViewModelBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$NowViewModel build() {
    final _$result =
        _$v ?? new _$NowViewModel._(now: now, listenToStream: listenToStream);
    replace(_$result);
    return _$result;
  }
}
