# circular_custom_loader

`circular_custom_loader` is a library for displaying the progress of tasks in your application.
There are various cases, for instance say networking requests, or operations involving streams.
This package can be used to engage the user until data gets displayed.

The most commonly-used class is the package's `CircularLoader`. It takes in different parameters,
some mandatory, some optional and using these parameters you can display this widget
like any other widget.

You can even style the texts and the progress value itself, using the `coveredPercentStyle` and `circleHeaderStyle`.
Sorry to keep to waiting!!!!

Below is the sample description of how to get started with this package.

![Example](https://github.com/AseemWangoo/flutter_programs/blob/master/circular_progress_loader.png)

# How to use
 1. Add this to your package's pubspec.yaml file:

````dart
dependencies:
  circular_custom_loader: 1.0.6
  ````
  
 2. Add this import to your dart file:

````dart
import 'package:circular_custom_loader/circular_custom_loader.dart';
  ````

 3. Just add CircularLoader wherever you want!

 
 ````dart
 CircularLoader(
        coveredPercent: 55,
        width: 150.0,
        height: 150.0,
        circleWidth: 12.0,
        circleColor: Colors.grey[300],
        coveredCircleColor: Colors.green,
        circleHeader: 'Progress..',
        unit: '%'
)
  ````

4. You can customize the parameters too. For instance, change the style of coveredPercent using coveredPercentStyle

 ````dart
 CircularLoader(
        coveredPercent: 55,
        width: 150.0,
        height: 150.0,
        circleWidth: 12.0,
        circleColor: Colors.grey[300],
        coveredCircleColor: Colors.green,
        circleHeader: 'Progress..',
        unit: '%'
        coveredPercentStyle: Theme.of(context).textTheme.title.copyWith(
              fontSize: 44.0,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
              color: Colors.black87),
)
  ````

Customize the circleHeader using circleHeaderStyle

 ````dart
 CircularLoader(
        coveredPercent: 55,
        width: 150.0,
        height: 150.0,
        circleWidth: 12.0,
        circleColor: Colors.grey[300],
        coveredCircleColor: Colors.green,
        circleHeader: 'Progress..',
        unit: '%'
        circleHeaderStyle: Theme.of(context).textTheme.title.copyWith(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
)
  ````  

Feel free to reach out, in case of any difficulties.  
 
## Getting Started

For help getting started with Flutter, view our online [documentation](https://flutter.io/).

For help on editing package code, view the [documentation](https://flutter.io/developing-packages/).

## Preview

![Example](https://github.com/AseemWangoo/flutter_programs/blob/master/circular_progress_loader.png)

# How to use
 1. Add this to your package's pubspec.yaml file:

````dart
dependencies:
  circular_custom_loader: 1.0.6
  ````
  
 2. Add this import to your dart file:

````dart
import 'package:circular_custom_loader/circular_custom_loader.dart';
  ````

 3. Just add CircularLoader wherever you want!

 
 ````dart
 CircularLoader(
        coveredPercent: 55,
        width: 150.0,
        height: 150.0,
        circleWidth: 12.0,
        circleColor: Colors.grey[300],
        coveredCircleColor: Colors.green,
        circleHeader: 'Progress..',
        unit: '%'
)
  ````

4. You can customize the parameters too. For instance, change the style of coveredPercent using coveredPercentStyle

 ````dart
 CircularLoader(
        coveredPercent: 55,
        width: 150.0,
        height: 150.0,
        circleWidth: 12.0,
        circleColor: Colors.grey[300],
        coveredCircleColor: Colors.green,
        circleHeader: 'Progress..',
        unit: '%'
        coveredPercentStyle: Theme.of(context).textTheme.title.copyWith(
              fontSize: 44.0,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
              color: Colors.black87),
)
  ````

Customize the circleHeader using circleHeaderStyle

 ````dart
 CircularLoader(
        coveredPercent: 55,
        width: 150.0,
        height: 150.0,
        circleWidth: 12.0,
        circleColor: Colors.grey[300],
        coveredCircleColor: Colors.green,
        circleHeader: 'Progress..',
        unit: '%'
        circleHeaderStyle: Theme.of(context).textTheme.title.copyWith(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
)
  ````  

Feel free to reach out, in case of any difficulties.  
 
## Getting Started

For help getting started with Flutter, view our online [documentation](https://flutter.io/).

For help on editing package code, view the [documentation](https://flutter.io/developing-packages/).