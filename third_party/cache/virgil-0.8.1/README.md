# Virgil
## A simple navigator assistant that allows for passing data to named routes

### Setup
#### Import the package
* Within
    ```yaml
    dependencies:
      flutter:
    ```
    add
    ```yaml
        virgil: 0.8.0
    ```

* Run `flutter packages get`

#### Add it to your app
* Inferno is a class containing your routes. It lives in the `home:` property of your *App widget.
* To create Inferno, you need to give it routes
    * It's routes are very similar to the regular navigator's routes, with one exception
        ```dart
        {
            '/': (context, arguments) => PageOne(),
            '/hello': (context, arguments) => PageTwo(arguments),
        }
        ```
        It takes arguments with the context.
        You can pass the arguments to the widget.
* To create it and start your app, you need to call `.home(context, [initialRoute])` on it.
    ```dart
    MaterialApp(
        home: Inferno(
          {
            '/': (context, arguments) => PageOne(),
            '/hello': (context, arguments) => PageTwo(arguments),
          },
        ).home(context), // you can give an optional argument to provide an initial route
    );
    ```
### Use it
* Virgil does *not* replace the Navigator object, it only provides an extension to it.
* To push a named page with arguments, use either
    ```
    Virgil.of(context).pushNamed('/hello', 'Arguments!');
    ```
    or
    ```
    Virgil.pushNamed(context, '/hello', 'Arguments!');
    ```
* Virgil supports these methods
    * pushNamed
    * pushNamedAndRemoveUntil
    * pushReplacementNamed
    * popAndPushNamed
        * The interface *should* be the same for all of these, with the exception of an optional `argument:` named parameter
        * The argument is `dynamic` by default, you can use type arguments to specifiy a type yourself.
* To pop, use
    ```dart
    Navigator.of(context).pop("value");
    ```
* For compatibility, Virgil will call the navigator if it can't find the route within Inferno.
    * The arguments **will be lost!**

### Custom Page Route Builder
* You can provide Inferno with a custom PageRouteBuilder to customize the page transitions