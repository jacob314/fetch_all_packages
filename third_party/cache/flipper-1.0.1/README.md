# flipper

![preview](../gifs/flipper.gif?raw=true)

## How to use

```dart
GlobalKey<FlipperState> _key = GlobalKey<FlipperState>();
var flipper = _key.currentState;
if (flipper.state == Turn.obverse) {
    flipper.flipCard(Direction.right);
}

//...

Flipper(
    key: _key,
    initState: Turn.obverse,
    onFlipCallback: (turn) => {/*...*/},
    obverseChild: Container(),
    reverseChild: Container(),
    flipThreshold: 0.60,
    duration: const Duration(milliseconds: 300),
    ignoreSwipe: false,
)
```