# gms_path

GmsPath is an of Google Maps Services Path class that helps to manage coordinates points.
First, you have to create or initialize an instance, you don't need keeping object reference because it is being handled in native code.

`await GmsPath.createPathInstance();`

After you create an instance, you can add coordinates.

```
await GmsPath.addCoordinate(19.434359, -99.152447);
await GmsPath.addCoordinate(19.439629, -99.144220);
await GmsPath.addCoordinate(19.441200, -99.142353);
```

Finally, you can get an encoded path of your coordinates.

`String encodedPath = await GmsPath.encodedPath;`

## Getting Started

Flutter plugin for Google Maps Services Path class to help with coordinates points and get encoded path.
[plug-in package](https://flutter.io/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter, view our 
[online documentation](https://flutter.io/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
