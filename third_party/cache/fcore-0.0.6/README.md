# fcore

Scliang Flutter Plugin(contain: SinPoints、LoopBanner)

## Getting Started

#### Usage

To use this plugin, add **fcore** as a dependency in your *pubspec.yaml* file.

```
dependencies:
  fcore: ^0.0.6
```

In your *.dart* file.

```
import 'package:fcore/fcore.dart';
import 'package:fcore/ui/sin_points.dart';
import 'package:fcore/ui/loop_banner.dart';
```

#### Example - SinPoints

```
MaterialButton(
  onPressed: (){
    setState((){
      _running ^= true;
    });
  },
  child: SizedBox(
    width: 160,
    height: 160,
    child: SinPoints(
      running: _running,
    ),
  ),
)
```

#### Example - LoopBanner

```
Center(
  child: LoopBanner(
    duration: Duration(seconds: 3),
    itemCount: 6,
    itemBuilder: (context, position){
      return Card(
        color: position % 3 == 0 ? Color(0xff33b5e5) : 
               position % 3 == 1 ? Color(0xffdd4400) : 
                                   Color(0xff44cc00),
        child: MaterialButton(
          onPressed: (){},
          child: Center(
            child: Text('${position + 1}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
              ),
            ),
          ),
        ),
      );
    },
  ),
)
```


## Other

```
This project is a starting point for a Flutter
[plug-in package](https://flutter.io/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter, view our 
[online documentation](https://flutter.io/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
```
