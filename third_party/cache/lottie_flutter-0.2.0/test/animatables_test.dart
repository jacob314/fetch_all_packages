import 'dart:convert';
import 'package:lottie_flutter/src/animatables.dart';
import 'package:test/test.dart';

void main() {
  ///
  /// Integer
  ///

  test('animatable integer without keyframes test', () {
    final Map<String, dynamic> map = json.decode('{"a":0,"k":200}');
    final AnimatableIntegerValue animatableValue =
        new AnimatableIntegerValue.fromMap(map, 0.0);
    _expect(map, animatableValue, 200, 0);
  });

  test('animatable integer without keyframes and a array test', () {
    final Map<String, dynamic> map = json.decode('{"a":0,"k":[300,100,100]}');
    final AnimatableIntegerValue animatableValue =
        new AnimatableIntegerValue.fromMap(map, 0.0);
    _expect(map, animatableValue, 300, 0);
  });

  test('animatable integer without keyframes and an array of doubles test', () {
    final Map<String, dynamic> map =
        json.decode('{"a":0,"k":[0.153,0.624,0.937,1]}');
    final AnimatableIntegerValue animatableValue =
        new AnimatableIntegerValue.fromMap(map, 0.0);
    _expect(map, animatableValue, 0, 0);
  });

  test('animatable integer with keyframes test', () {
    final Map<String, dynamic> map = json.decode('{"a":0,"k":['
        '{"t":16, "s":[352,280,0],"e":[352,299,0]} ]}');
    final AnimatableIntegerValue animatableValue =
        new AnimatableIntegerValue.fromMap(map, 0.0);
    _expect(map, animatableValue, 352, 1);
  });

  ///
  /// Double
  ///
}

void _expect<T>(dynamic map, BaseAnimatableValue<T, T> animatableValue,
    T initialValue, int keyframesLength) {
  expect(animatableValue.initialValue, initialValue);
  expect(animatableValue.scene.keyframes.length, keyframesLength);
}
