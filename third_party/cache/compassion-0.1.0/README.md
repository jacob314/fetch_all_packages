# Compass

***WARNING: ONLY ON FLUTTER'S MASTER BRANCH (for now)***

A simple shim to make named routes with arguments easier.

## How to use

### If you don't want to access the `routes` at runtime
* You only need to add `Compass` as the onGenerateRoute argument 
```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: Compass({
        "/": (c, a) => MyHomePage(title: a),
      }),
    );
  }
}
```

### If you want to access the `routes` at runtime
* If you only use named routes, use `Compass.of(context).routes`
* If you use a mix of named and anonymous routes
    * Create your `Compass` in an accessible scope, for example, as a member of your master widget
    * Add a `CompassProvider` as a parent of your `MaterialApp`
    * Provide your `Compass` to the `CompassProvider`
    * Put your `MaterialApp` inside of the `CompassProvider`
    * Set the `onGenerateRoute` parameter to your `Compass`
    ```dart
    class MyApp extends StatelessWidget {
        final compass = Compass({
            "/": (c, a) => MyHomePage(title: a),
        });

        @override
        Widget build(BuildContext context) {
            return CompassProvider(
                compass: compass,
                child: MaterialApp(
                    onGenerateRoute: compass,
                    home: MyHomePage(),
                ),
            );
        }
    }
    ```

## Features

* Accessible anywhere for modification
* Simple interface