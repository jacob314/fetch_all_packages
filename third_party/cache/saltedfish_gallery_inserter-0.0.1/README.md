# saltedfish_gallery_inserter

## A Flutter plugin can insert an image into gallery.


## How to use

### 1. Install
Add this to your package's pubspec.yaml file:
```flutter
dependencies:
  saltedfish_gallery_inserter: "^0.0.1"
```
### 2. Import
```flutter
import 'package:saltedfish_gallery_inserter/saltedfish_gallery_inserter.dart';
```

### 3. IOS
plist file
```flutter
<key>NSPhotoLibraryUsageDescription</key>
	<string></string>
```
### 4. Use

-  Insert Image

if success(or resultCode is 'failed') , return a map like this:

{resultCode: success, /Users/haoluo/Library/Developer/CoreSimulator/Devices/D3CEB1DD-DB59-47BE-B87E-11548778AD8C/data/Media/DCIM/100APPLE/IMG_0013.PNG: path}

```
SaltedfishGalleryInserter.insertImageToGallery(image).then((map){
      print('$map');
    });
```
-  Insert Image File

```
 SaltedfishGalleryInserter.insertFileToGallery(file).then((map){
      print('$map');
    });
```

## License
    Copyright 2018 LuoHao

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

