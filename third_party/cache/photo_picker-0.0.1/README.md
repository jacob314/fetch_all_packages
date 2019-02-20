# ImagePickerController

### Feature

| Item | iOS | Android |
| :-: | :-: | :-: |
| photo picker | ✔️ |  |
| camera |  ✔️  |  |
| multi-select | ✔️ |  |
| multi-select limit | ✔️ |  |
| thumbnail(300*300) | ✔️ |  |
| compression | ✔️ |  |


### Usage

##### 1. Import packages

```
import 'package:path_provider/path_provider.dart';
import 'package:photo_picker/photo_picker.dart';
```

##### 2. Get cache path

```
// in state
Directory _tempDirectory;
```

```
// in async init function
_tempDirectory = await getTemporaryDirectory();
```
##### 3. Call
```
// on pressed
PhotoPicker.camera({"edit": false}).then((onValue) {
    setState(() {
        _photos.addAll(onValue);
    });
});

PhotoPicker.pickPhoto({"limit": 8, 
                       "cameraRollFirst": true, 
                       "mode": "fit"}).then((onValue) {
                setState(() {
                  _photos.addAll(onValue);
                });
});

```


