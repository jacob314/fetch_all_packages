import 'package:test/test.dart';

import 'package:swipable/swipable.dart';

void main() {
  test('Basic SwipeInfo tests', () {
    final swipe = new SwipableInfo();

    swipe.contextWidth = 10.0;
    expect(swipe.contextWidth, 10.0);

    swipe.startPosition = 2.0;
    expect(swipe.position, 1.0);
    expect(swipe.lastPosition, 2.0);
    expect(swipe.startPosition, 2.0);

    swipe.position = 7.0;
    expect(swipe.position, 7.0);
    expect(swipe.lastPosition, 7.0);
    expect(swipe.startPosition, 2.0);

    swipe.position = 1.0;
    expect(swipe.position, 1.0);
    expect(swipe.lastPosition, 7.0);
    expect(swipe.startPosition, 2.0);

    expect(swipe.fractionalPosition, 0.1);
    expect(swipe.delta, -1.0);
    expect(swipe.fractionalDelta, -0.1);
    expect(swipe.velocity, -6.0);
    expect(swipe.fractionalVelocity, -0.6);

    swipe.reset();
    expect(swipe.position, 0.0);
    expect(swipe.lastPosition, 0.0);
    expect(swipe.startPosition, 0.0);
    expect(swipe.delta, 0.0);
    expect(swipe.fractionalDelta, 0.0);
    expect(swipe.velocity, 0.0);
    expect(swipe.fractionalVelocity, 0.0);
    expect(swipe.contextWidth, 10.0);
  });
}
