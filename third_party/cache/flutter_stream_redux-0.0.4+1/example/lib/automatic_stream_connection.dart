import 'package:example/duration_slider.dart';
import 'package:example/generated/i18n.dart';
import 'package:example/redux/containers/duration_connector.dart';
import 'package:example/redux/containers/now_stream_connector.dart';
import 'package:flutter/material.dart';

class AutomaticStreamConnection extends StatelessWidget {
  const AutomaticStreamConnection();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        leading: const BackButton(),
        title: new Text(S.of(context).automatic_stream_connection),
      ),
      body: new DurationConnector(
        builder: (BuildContext context, DurationViewModel durationModel) {
          return new NowStreamConnector(
            duration: durationModel.duration,
            builder: (BuildContext context, int now) {
              return new Column(
                children: <Widget>[
                  new DurationSlider(
                    isStarted: false,
                    duration: durationModel.duration,
                    durationChanged: durationModel.durationChanged,
                  ),
                  new Container(
                    margin: const EdgeInsets.all(32.0),
                    child: new Text(
                      S.of(context).now_text(now.toString()),
                      style: const TextStyle(
                        fontSize: 32.0,
                      ),
                    ),
                  ),
                  new Text(
                    S.of(context).automatic_explanation,
                    textAlign: TextAlign.center,
                  )
                ],
              );
            },
          );
        },
      ),
    );
  }
}
