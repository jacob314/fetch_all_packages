import 'package:example/duration_slider.dart';
import 'package:example/generated/i18n.dart';
import 'package:example/redux/containers/duration_connector.dart';
import 'package:example/redux/containers/is_started_connector.dart';
import 'package:example/redux/containers/now_container.dart';
import 'package:flutter/material.dart';

class ManualStreamConnector extends StatelessWidget {
  const ManualStreamConnector();

  @override
  Widget build(BuildContext context) {
    return new NowConnector(
      builder: (BuildContext context, NowViewModel nowModel) {
        return new Scaffold(
          appBar: new AppBar(
            title: new Text(S.of(context).manual_stream_connection),
          ),
          body: new IsStartedConnector(
            builder: (BuildContext context, bool isStarted) {
              return new DurationConnector(
                builder: (BuildContext context, DurationViewModel durationModel) {
                  return new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new DurationSlider(
                        isStarted: isStarted,
                        duration: durationModel.duration,
                        durationChanged: durationModel.durationChanged,
                      ),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          isStarted
                              ? new RaisedButton.icon(
                                  onPressed: () {
                                    nowModel.listenToStream(null);
                                  },
                                  icon: new Icon(
                                    Icons.stop,
                                  ),
                                  label: new Text(S.of(context).stop_stream),
                                )
                              : new RaisedButton.icon(
                                  onPressed: () {
                                    nowModel.listenToStream(durationModel.duration);
                                  },
                                  icon: new Icon(
                                    Icons.play_arrow,
                                  ),
                                  label: new Text(S.of(context).start_stream),
                                ),
                        ],
                      ),
                      new Container(
                        margin: const EdgeInsets.all(32.0),
                        child: new Text(
                          S.of(context).now_text(nowModel.now.toString()),
                          style: const TextStyle(
                            fontSize: 32.0,
                          ),
                        ),
                      ),
                      new Text(S.of(context).manually_explanation),
                    ],
                  );
                },
              );
            },
          ),
          floatingActionButton: new FloatingActionButton(
            child: new Icon(
              Icons.autorenew,
              color: Colors.white,
            ),
            onPressed: () async {
              nowModel.listenToStream(null);
              await Navigator.pushNamed(context, 'automatic');
              nowModel.listenToStream(null);
            },
          ),
        );
      },
    );
  }
}
