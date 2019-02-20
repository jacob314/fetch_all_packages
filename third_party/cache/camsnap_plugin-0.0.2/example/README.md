# camsnap_plugin example

```
void main() => runApp(MaterialApp(home: CameraViewExample()));

class CameraViewExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Column(children: [
          Center(
              child: Container(
                  width: screenWidth,
                  height: screenHeight,
                  child: CameraView(
                    onCameraViewCreated: _onCameraViewCreated,
                  ))),
        ]));
  }

  void _onCameraViewCreated(CameraViewController controller) async {
    Directory appDocDir = await getExternalStorageDirectory();
    appDocDir.exists().then((isExists) async {
      if (!isExists) {
        appDocDir = await getApplicationDocumentsDirectory();
      }
    });
    String dir = appDocDir.path + '/Nailsnap/images';
    new Directory(dir).exists().then((isExists) {
      if (!isExists) {
        new Directory(dir).create(recursive: true);
      }
    });
    print(await controller.captureImage(dir, 'IMG_' + new DateTime.now().millisecondsSinceEpoch.toString() + '.jpg'));
  }
```