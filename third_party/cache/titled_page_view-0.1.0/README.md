# titled_page_view
A Flutter PageView with an additional title bar and optional controls.

[![Build Status](https://travis-ci.org/KKleinbeck/titled_page_view.svg?branch=master)](https://travis-ci.org/KKleinbeck/titled_page_view)

# Showcase


![](https://github.com/KKleinbeck/titled_page_view/raw/master/preview.gif)


# Usage

 ## Example

First, add the package to your pubspec.yaml:

```

    dependencies:
     ...
     titled_page_view: ^0.1.0

```

Now you can use `TitledPageView` like Flutters's `PageView`


 ```

 import 'package:titled_page_view/titled_page_view.dart';

 ...

 new Scaffold(
   body: new TitledPageView(
     children: [
       Column(
         children: [
           Container(height: 300, color: Colors.green),
         ]
       ),
       Column(
         children: [
           Container(height: 300, color: Colors.red),
         ]
       ),
     ],
     titleChildren: [
       Text('Green'),
       Text('Red'),
     ],
   ),
 ),
```

 ## Interface

 `TitledPageView` is build around Flutter's [`PageView`](https://docs.flutter.io/flutter/widgets/PageView-class.html). Therefore, many have the same name and work
 exactly the same. The only two additional options are `fadeEffect` and `controlButtons`, which
 add optional fading effects and controls to the title, respectively. Currently, both the fade
 animation and the buttons (`chevron_left`/`chevron_right`) are hard coded. Lastly, the code is
 written such that `scrollDirection` of `Axis.vertical` is currently not possible, hence this
 option does not exist. With these differences in mind the interface resembles Flutter's `PageView`
 Widget very closely, thus one can always consult the official Flutter [documentation](https://docs.flutter.io/flutter/widgets/PageView-class.html).
