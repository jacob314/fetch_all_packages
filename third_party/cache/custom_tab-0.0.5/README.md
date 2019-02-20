# custom_tab

A beautiful 3-D Tab View widget with lots of customizations

## Usage

To use this plugin, add custom_tab as a dependency in your pubspec.yaml file

## Example

```dart
CustomTab(
    3,
    (i) => new ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: new Stack(fit: StackFit.expand, children: [
            Image.network(
              Pictures[Beverages[i]][0],
              fit: BoxFit.fill,
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: new Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    Beverages[i],
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        background: Paint()
                          ..color = Colors.black.withAlpha(900000),
                        fontWeight: FontWeight.bold),
                  ),
                ))
          ]),
        ),
    (context, i) => new GridView.builder(
        padding: EdgeInsets.all(5.0),
        itemCount: Pictures["Tea"].length,
        shrinkWrap: false,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        itemBuilder: (context, j) => new ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: new Image.network(
                Pictures[Beverages[i]][j],
                fit: BoxFit.fill,
                height: 10.0,
              ),
            )),
    indicatorColor: Colors.yellow,
  ))
```

<img src="https://github.com/sebyjt/custom_tab_package/blob/master/gif.gif?raw=true" width="300" height="500" />

## Design Courtesy
[Philson K Philip](https://github.com/philson-philip)