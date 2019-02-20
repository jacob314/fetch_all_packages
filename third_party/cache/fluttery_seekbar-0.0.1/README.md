# fluttery_seekbar

Catalog of Flutter seek bars and progress bars.

## Getting Started

### RadialSeekBar

A `RadialSeekBar` is a draggable round progress bar.

The following sets up a `StatefulWidget` that implements dragging of a thumb.

```dart
class SimpleDraggingExample extends StatefulWidget {
  @override
  _SimpleDraggingExampleState createState() => _SimpleDraggingExampleState();
}

class _SimpleDraggingExampleState extends State<SimpleDraggingExample> {
  double _thumbPercent = 0.4;

  @override
  Widget build(BuildContext context) {
    // A RadialSeekBar is built in a 150x150 square, centered on screen.
    return Center(
      child: SizedBox(
        width: 150.0,
        height: 150.0,
        child: _buildRadialSeekBar(),
      ),
    );
  }

  Widget _buildRadialSeekBar() {
    return RadialSeekBar(
      trackColor: Colors.black,
      trackWidth: 4.0,
      progressColor: Colors.red,
      progressWidth: 8.0,
      progress: _thumbPercent,
      thumb: CircleThumb(
        color: Colors.red,
        diameter: 25.0,
      ),
      thumbPercent: _thumbPercent,
      onDragUpdate: (double percent) {
        setState(() {
          _thumbPercent = percent;
        });
      },
    );
  }
}
```

### RadialProgressBar

A `RadialProgressBar` is a progress bar that is shaped like a circle. `RadialSeekBar` is built atop a `RadialProgressBar`.

The following is a simple example of a `RadialProgressBar`:

```dart
RadialSeekBar(
  trackColor: Colors.black,
  trackWidth: 4.0,
  progressColor: Colors.red,
  progressWidth: 8.0,
  progress: 0.6,
);
```

## Visual Example

To see some examples of seek bars and progress bars, consider trying out the example app that comes with this library.