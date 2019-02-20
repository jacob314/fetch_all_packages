abstract class Either<L, R> {
  factory Either.right(R right) => Right._internal(right);
  factory Either.left(L left) => Left._internal(left);

  bool isRight();
  bool isLeft();

  L getLeft();
  R get();

  R getOrElseGet<T extends R>(T other) {
    if (isRight()) {
      return get();
    } else {
      return other;
    }
  }

  Either<L, T> mapRight<T>(T function(R rightValue)) =>
      isRight() ? Either.right(function(get())) : null;
}

class Right<L, R> with Either<L, R> {
  R _value;

  Right._internal(R value) {
    _value = value;
  }

  @override
  L getLeft() => null;

  @override
  R get() => _value;

  @override
  bool isLeft() => false;

  @override
  bool isRight() => true;
}

class Left<L, R> with Either<L, R> {
  L _value;

  Left._internal(L value) {
    _value = value;
  }

  @override
  L getLeft() => _value;

  @override
  R get() => null;

  @override
  bool isLeft() => true;

  @override
  bool isRight() => false;
}
