import 'package:example/generated/i18n.dart';
import 'package:example/redux/containers/duration_connector.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class DurationSlider extends StatelessWidget {
  const DurationSlider({@required this.isStarted, @required this.duration, @required this.durationChanged})
      : assert(isStarted != null),
        assert(duration != null),
        assert(durationChanged != null);

  final bool isStarted;
  final Duration duration;
  final DurationChanged durationChanged;

  @override
  Widget build(BuildContext context) {
    final int durationInMilliseconds = duration.inMilliseconds;

    return new Container(
      margin: const EdgeInsets.all(16.0),
      child: new Column(
        children: <Widget>[
          new Text(S.of(context).interval_milliseconds(durationInMilliseconds.toString())),
          new Slider(
            divisions: 19,
            label: durationInMilliseconds.toString(),
            value: durationInMilliseconds.toDouble(),
            onChanged: (double value) {
              if (!isStarted) durationChanged(new Duration(milliseconds: value.toInt()));
            },
            max: 2000.0,
            min: 100.0,
          ),
        ],
      ),
    );
  }
}
