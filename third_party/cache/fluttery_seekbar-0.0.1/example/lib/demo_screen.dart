import 'package:flutter/material.dart';
import 'package:fluttery_seekbar/fluttery_seekbar.dart';

const Color trackColor = Colors.black;
const Color progressColor = Colors.redAccent;
const Color thumbColor = Colors.red;

/// Demonstrates a simplistic [RadialSeekBar].
///
/// This demo displays text at the center of the [RadialSeekBar] which
/// displays the current seek bar position.
///
/// In this demo, the progress percent is always tied to the thumb's
/// position.
class DemoPage extends StatefulWidget {
  @override
  _DemoPageState createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
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
      trackColor: trackColor,
      trackWidth: 4.0,
      progressColor: progressColor,
      progressWidth: 8.0,
      progress: _thumbPercent,
      thumb: CircleThumb(
        color: thumbColor,
        diameter: 25.0,
      ),
      thumbPercent: _thumbPercent,
      centerContent: _buildRadialSeekBarContent(),
      onDragUpdate: (double percent) {
        setState(() {
          _thumbPercent = percent;
        });
      },
    );
  }

  Widget _buildRadialSeekBarContent() {
    return Center(
      child: Text(
        '${_presentThumbPercent()}',
        style: TextStyle(
          color: thumbColor,
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _presentThumbPercent() {
    return (_thumbPercent * 100).toStringAsFixed(2) + '%';
  }
}
