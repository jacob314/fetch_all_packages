# GSCarousel

A simple widget wrapper to create image slideshow banner

## Demo

![Demo](https://raw.githubusercontent.com/balitax/gscarousel/master/gscarousel.png)

*See example for details*


## Usage

Add the package to your `pubspec.yml` file.

```yml
dependencies:
  gscarousel: ^0.0.1
```

Next, import the library into your widget.

```dart
import 'package:gscarousel/gscarousel.dart';
```

Now, all you have to do is simply wrap your widget as a child of `GSCarousel`

```dart
new Container(
    child: new SizedBox(
    height: 140.0,
    child: new GSCarousel(
        images: [
        new NetworkImage(
                ''),
            new NetworkImage(
                ''),
            new NetworkImage(
                ''),
            new NetworkImage(
                ''),
        ],
        indicatorSize: const Size.square(8.0),
        indicatorActiveSize: const Size(18.0, 8.0),
        indicatorColor: Colors.white,
        indicatorActiveColor: Colors.redAccent,
        animationCurve: Curves.easeIn,
        contentMode: BoxFit.cover,
        // indicatorBackgroundColor: Colors.greenAccent,
    ),
    ),
)
```


### Issues and feedback

Please file [issues](https://github.com/balitax/gscarousel/issues/new)
to send feedback or report a bug. Thank you!

