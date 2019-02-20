# bmnav

A very flexible Flutter implementation of the Bottom Navigation Bar. 

[![Pub](https://img.shields.io/pub/v/bmnav.svg)](https://pub.dartlang.org/packages/bmnav)
[![PayPal](https://img.shields.io/badge/Donate-PayPal-blue.svg)](https://www.paypal.me/edwnjos)

![BottomNavigationBar with label](https://raw.githubusercontent.com/edwnjos/bmnav/master/screenshots/with-label.gif)

![BottomNavigationBar with label when selected](https://raw.githubusercontent.com/edwnjos/bmnav/master/screenshots/with-select-label.gif)

![BottomNavigationBar without label](https://raw.githubusercontent.com/edwnjos/bmnav/master/screenshots/without-label.gif)

## Get Started

Add `bmanv` to your `pubspec.yaml` file:

```yaml
dependencies:
  bmnav: ^0.3.4
```

Import `bmnav` in your main.dart file:

```dart
import 'package:bmnav/bmnav.dart' as bmnav;
```

Implement `bmnav.BottomNav` in the `bottomNavigationBar` parameter in the Scaffold widget:

```dart
@override
Widget build(BuildContext ctx) {
	return Scaffold(
		appBar: AppBar(title: Text('Bottom Nav Demo')),
		body: Container(child: Text('Hello World')),
		bottomNavigationBar: bmnav.BottomNav(
			items: [
				bmnav.BottomNavItem(Icons.home),
				bmnav.BottomNavItem(Icons.fitness_center),
				bmnav.BottomNavItem(Icons.person),
				bmnav.BottomNavItem(Icons.view_headline)
			],
		),
	);
}
```

You can find a fully fledged example with navigation and custom styles [here](https://github.com/edwnjos/bmnav/blob/master/example/lib/main.dart).

## Props

| Name              | Explanation                                                                       | Default                          |
|-------------------|----------------------------------------------------------------------------|----------------------------------|
| index             | starting index                                                             | 0                                |
| onTap             | callback when a bottom nav item is pressed                                 | null                             |
| items             | bottom nav items                                                           | null                             |
| elevation         | elevation of bottom nav                                                    | 8.0                              |
| color             | background color                                                           | Colors.white                     |
| iconStyle         | icon styles (`size`, `onSelectSize`, `color`, `onSelectColor`)             | null                             |
| labelStyle        | label styles (`visible`, `showOnSelect`, `textStyle`, `onSelectTextStyle`) | null                             |

## Contributions

Feel free to contribute to this project.

## Support

If you found this project to be useful then please consider donating to help me continue maintaining this project and create new projects. :)

[![Paypal Donate Button](https://www.paypalobjects.com/webstatic/mktg/Logo/pp-logo-150px.png)](https://www.paypal.me/edwnjos)
