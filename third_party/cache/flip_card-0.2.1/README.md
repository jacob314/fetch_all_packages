# flip_card

A component that provides flip card animation. It could be used for hide and show details of a product.

<p>
<img src="https://github.com/fedeoo/flip_card/blob/master/screenshots/flip-h.gif?raw=true&v1" width="320" />
<img src="https://github.com/fedeoo/flip_card/blob/master/screenshots/flip-v.gif?raw=true&v1" width="320" />
</p>

## How to use


````dart
import 'package:flip_card/flip_card.dart';
````

Create a flip card

```dart
FlipCard(
  direction: FlipDirection.HORIZONTAL, // default
  front: Container(
        child: Text('Front'),
    ),
    back: Container(
        child: Text('Back'),
    ),
);
```

