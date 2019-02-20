# flutter_image_pick_crop

A new Flutter plugin for cropping images picked from camera or gallery.

## Screenshots

<img src="ss1.png" height="300em" /> <img src="ss2.png" height="300em" />
<img src="ss3.png" height="300em" /> <img src="ss4.png" height="300em" />
<img src="ss5.png" height="300em" /> <img src="ss6.png" height="300em" />

### Show some :heart: and star the repo to support the project

## Usage

[Example](https://github.com/mtellect/FlutterImagePickCrop/blob/master/example/lib/main.dart)

```yaml
  dependencies:
    flutter:
      sdk: flutter
    flutter_image_pick_crop:
```

```dart
class _MyAppState extends State<MyApp> {
  String _platformMessage = 'Unknown';
  String _camera = 'fromCameraCropImage';
  String _gallery = 'fromGalleryCropImage';
  File imageFile;

  @override
  initState() {
    super.initState();
  }


  initGalleryPickUp() async {
    /*setState(() {
      imageFile = null;
      _platformVersion = 'Unknown';
    });*/
    File file;
    String result;

    try {
      result = await FlutterImagePickCrop.pickAndCropImage(_gallery);
    } on PlatformException catch (e) {
      result = e.message;
      print(e.message);
    }

    if (!mounted) return;

    setState(() {
      imageFile = new File(result);
      _platformMessage = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Plugin Image Crop'),
        ),
        body: new Container(
          padding: const EdgeInsets.all(8.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              imageFile != null
                  ? new Image.file(
                      imageFile,
                      height: 400.0,
                    )
                  : new Icon(
                      Icons.image,
                      size: 200.0,
                      color: Theme.of(context).primaryColor,
                    ),
              new Center(
                child: new Text('Running on: $_platformMessage\n'),
              ),
              new RaisedButton.icon(
                  onPressed: initGalleryPickUp,
                  icon: new Icon(Icons.image),
                  label: new Text("Open Camera/Gallery")),
              new Padding(padding: new EdgeInsets.only(left: 5.0, right: 5.0))
            ],
          ),
        ),
      ),
    );
  }
}
```


# Pull Requests

I welcome and encourage all pull requests. It usually will take me within 24-48 hours to respond to any issue or request. Here are some basic rules to follow to ensure timely addition of your request:

1.  Match coding style (braces, spacing, etc.) This is best achieved using `Reformat Code` feature of Android Studio `CMD`+`Option`+`L` on Mac and `CTRL` + `ALT` + `L` on Linux + Windows .
2.  If its a feature, bugfix, or anything please only change code to what you specify.
3.  Please keep PR titles easy to read and descriptive of changes, this will make them easier to merge :)
4.  Pull requests _must_ be made against `develop` branch. Any other branch (unless specified by the maintainers) will get rejected.
5.  Check for existing [issues](https://github.com/mtellect/FlutterImagePickCrop/issues) first, before filing an issue.
6.  Make sure you follow the set standard as all other projects in this repo do
7.  Have fun!

### Created & Maintained By

[Maugost_Mtellect](https://github.com/mtellect/)

> If you found this project helpful or you learned something from the source code and want to thank me, consider buying me a cup of :coffee:
>
> *Bitcoin: 1K2wivc2xy7tTjsmHhNzq7wwEHoyHfS64n


# License

    Copyright 2018 Maugost Mtellect

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.


## Getting Started

For help getting started with Flutter, view our online [documentation](https://flutter.io/).

For help on editing package code, view the [documentation](https://flutter.io/developing-packages/).