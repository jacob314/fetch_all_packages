
import 'package:flutter/material.dart';
import 'package:torch/torch.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
	bool isOn = false;
	bool hasTorch = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
		Torch.hasTorch.then((_hasTorch) {
			setState(() {
				hasTorch = _hasTorch;			
			});
		});

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Torch Plugin example app'),
        ),
        body: Center(
          child: Column(
						mainAxisAlignment: MainAxisAlignment.center,
						crossAxisAlignment: CrossAxisAlignment.center,
						children: <Widget>[
							Text('Does it have torch: $hasTorch'),
							RaisedButton(
								child: Text('TOGGLE TORCH !!'),
								onPressed: hasTorch ? () {
									if(isOn) {
										Torch.turnOff();
									} else {
										Torch.turnOn();
									}
									isOn = !isOn;
								} : null,
							),
							RaisedButton(
								child: Text('FLASH'),
								onPressed: hasTorch ?  () {
									Future.delayed(Duration(milliseconds: 500), () => Torch.flash(Duration(milliseconds: 200)));
									Torch.flash(Duration(milliseconds: 300));
								} : null,
							),
						],
					),
        )
      ),
    );
  }
}
