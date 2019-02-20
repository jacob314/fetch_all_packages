# floating_bubble

Generate a floating widget that sticks to the sides of the screen
Usually paired with a Floating action button.

You must use a PreferredSizeWidget, if you know how to get the size of a child without showing it on screen, please raise an issue or send a PR.

## Example

```dart
Stack(
  children: <Widget>[
    MyPage(),
    FloatingBubble(
      child: PreferredSize(
        child: FloatingActionButton(
          child: Icon(Icons.exit_to_app),
            heroTag: "FloatingButton",
            onPressed: () => Navigator.of(context).pop(),
          ),
        preferredSize: Size(64.0, 64.0),
      ),
    )
  ],
)
```
