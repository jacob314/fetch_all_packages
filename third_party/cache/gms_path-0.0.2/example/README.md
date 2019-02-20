# gms_path_example

GmsPath is an of Google Maps Services Path class that helps to manage coordinates points.
First, you have to create or initialize an instance, you don't need keeping object reference because it is being handled in native code.

```
import 'package:gms_path/gms_path.dart';

await GmsPath.createPathInstance();

await GmsPath.addCoordinate(19.434359, -99.152447);
await GmsPath.addCoordinate(19.439629, -99.144220);
await GmsPath.addCoordinate(19.441200, -99.142353);

String encodedPath = await GmsPath.encodedPath;
```

## Getting Started

Flutter plugin for Google Maps Services Path class to help with coordinates points and get encoded path.

