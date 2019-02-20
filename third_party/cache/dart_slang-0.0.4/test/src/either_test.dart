import 'package:dart_slang/src/either.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Either<int, String> eitherRight = Either.right('test');
  Either<int, String> eitherLeft = Either.left(5);

  group('right tests', () {
    test('getLeft should return null', () {
      expect(eitherRight.getLeft(), null);
    });
    test('isRight should be true', () {
      expect(eitherRight.isRight(), true);
    });
    test('isLeft should be false', () {
      expect(eitherRight.isLeft(), false);
    });
    test('get should return string', () {
      expect(eitherRight.get(), 'test');
    });
    test('getOrElseGet should return value passed in', () {
      expect(eitherLeft.getOrElseGet('success'), 'success');
    });
    test('map', () {
      expect(eitherRight.mapRight((s) => 5).get(), 5);
    });
  });

  group('left tests', () {
    test('getLeft should return int', () {
      expect(eitherLeft.getLeft(), 5);
    });
    test('isRight should be false', () {
      expect(eitherLeft.isRight(), false);
    });
    test('isLeft should be true', () {
      expect(eitherLeft.isLeft(), true);
    });
    test('get should return null', () {
      expect(eitherLeft.get(), null);
    });
  });
}
