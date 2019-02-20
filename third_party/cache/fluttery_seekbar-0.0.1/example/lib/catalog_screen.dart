import 'package:flutter/material.dart' show Colors;
import 'package:flutter/widgets.dart';
import 'package:fluttery_seekbar/fluttery_seekbar.dart';

class CatalogPage extends StatefulWidget {
  @override
  _CatalogPageState createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildExample("RadialSeekBar", DraggableRadialSeekBar()),
            _buildExample("TODO: Drag with seek", SizedBox()),
            _buildExample("RadialProgressBar", _buildRadialProgressBar()),
          ],
        ),
      ),
    );
  }

  Widget _buildExample(String title, Widget example) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 24.0,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: 175.0,
          padding: const EdgeInsets.only(bottom: 30.0),
          child: example,
        ),
      ],
    );
  }

  Widget _buildRadialProgressBar() {
    const Color trackColor = Colors.black;
    const Color seekColor = Colors.deepPurple;
    const Color progressColor = Colors.redAccent;

    return RadialProgressBar(
      trackColor: trackColor,
      seekColor: seekColor,
      seekWidth: 6.0,
      seekPercent: 0.6,
      progressColor: progressColor,
      progressPercent: 0.4,
      progressWidth: 8.0,
      centerContent: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(20.0),
        color: const Color(0xFFF0F0F0),
        child: Image.asset(
          'assets/fluttery_logo.png',
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}

class DraggableRadialSeekBar extends StatefulWidget {
  @override
  _DraggableRadialSeekBarState createState() => _DraggableRadialSeekBarState();
}

class _DraggableRadialSeekBarState extends State<DraggableRadialSeekBar> {
  static const Color trackColor = Colors.black;
  static const Color progressColor = Colors.redAccent;
  static const Color thumbColor = Colors.red;

  double _thumbPercent = 0.4;

  @override
  Widget build(BuildContext context) {
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
      centerContent: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(20.0),
        color: const Color(0xFFF0F0F0),
        child: Image.asset(
          'assets/fluttery_logo.png',
          fit: BoxFit.fill,
        ),
      ),
      onDragUpdate: (double percent) {
        setState(() {
          _thumbPercent = percent;
        });
      },
    );
  }
}
