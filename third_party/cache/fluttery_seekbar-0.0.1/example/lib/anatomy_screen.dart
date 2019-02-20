import 'package:flutter/material.dart';
import 'package:fluttery_seekbar/fluttery_seekbar.dart';

const Color trackColor = Colors.black;
const Color seekColor = Colors.deepPurple;
const Color progressColor = Colors.redAccent;
const Color thumbColor = Colors.red;

/// Illustrates the independent pieces of a [RadialSeekBar] by stacking them vertically.
///
/// Users of this screen can click and drag on a special control that separates each
/// pieces of a [RadialSeekBar], displaying the pieces in a telescoping manner.
class AnatomyPage extends StatefulWidget {
  @override
  _AnatomyPageState createState() => _AnatomyPageState();
}

class _AnatomyPageState extends State<AnatomyPage> {
  double _baseOffsetX = 0.0;
  double _baseOffsetY = 0.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: <Widget>[
          _buildTelescopingControls(),
          Center(
            child: _buildPiecesStacked(),
          ),
        ],
      ),
    );
  }

  Widget _buildTelescopingControls() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Flexible(
            flex: 6,
            fit: FlexFit.tight,
            child: SizedBox(),
          ),
          GestureDetector(
            onPanUpdate: _onPanUpdate,
            onTap: () {
              setState(() {
                _baseOffsetX = 0.0;
                _baseOffsetY = 0.0;
              });
            },
            behavior: HitTestBehavior.translucent,
            child: Container(
              width: 40.0,
              height: 40.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFDDDDDD),
              ),
              child: Icon(
                Icons.open_with,
                color: const Color(0xFF444444),
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            'Click and Drag\n----\nTap to Reset',
            textAlign: TextAlign.center,
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: SizedBox(),
          ),
        ],
      ),
    );
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _baseOffsetX += details.delta.dx;
      _baseOffsetY += details.delta.dy;
    });
  }

  Widget _buildPiecesStacked() {
    return SizedBox(
      width: 150.0,
      height: 150.0,
      child: Stack(
        children: <Widget>[
          _buildCenterOnly(),
          Transform(
            transform: Matrix4.translationValues(_baseOffsetX * 0.5, _baseOffsetY * 0.5, 0.0),
            child: _buildTrackOnly(),
          ),
          Transform(
            transform: Matrix4.translationValues(_baseOffsetX * 1, _baseOffsetY * 1, 0.0),
            child: _buildSeekOnly(),
          ),
          Transform(
            transform: Matrix4.translationValues(_baseOffsetX * 1.5, _baseOffsetY * 1.5, 0.0),
            child: _buildProgressOnly(),
          ),
          Transform(
            transform: Matrix4.translationValues(_baseOffsetX * 2, _baseOffsetY * 2, 0.0),
            child: _buildThumbOnly(),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterOnly() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0x44000000),
          width: 1.0,
        ),
      ),
      child: RadialSeekBar(
        trackColor: trackColor,
        trackWidth: 0.0,
        progressWidth: 0.0,
        seekWidth: 0.0,
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
      ),
    );
  }

  Widget _buildTrackOnly() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0x44000000),
          width: 1.0,
        ),
      ),
      child: RadialSeekBar(
        trackColor: trackColor,
        trackWidth: 4.0,
        seekWidth: 0.0,
        progressWidth: 0.0,
      ),
    );
  }

  Widget _buildSeekOnly() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0x44000000),
          width: 1.0,
        ),
      ),
      child: RadialSeekBar(
        trackWidth: 0.0,
        seekColor: seekColor,
        seekWidth: 6.0,
        progressWidth: 0.0,
        seekPercent: 0.6,
      ),
    );
  }

  Widget _buildProgressOnly() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0x44000000),
          width: 1.0,
        ),
      ),
      child: RadialSeekBar(
        trackWidth: 0.0,
        seekWidth: 0.0,
        progressColor: progressColor,
        progressWidth: 8.0,
        progress: 0.4,
      ),
    );
  }

  Widget _buildThumbOnly() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0x44000000),
          width: 1.0,
        ),
      ),
      child: RadialSeekBar(
        trackWidth: 0.0,
        seekWidth: 0.0,
        progressWidth: 0.0,
        thumb: CircleThumb(
          color: thumbColor,
          diameter: 25.0,
        ),
        thumbPercent: 0.4,
      ),
    );
  }
}
