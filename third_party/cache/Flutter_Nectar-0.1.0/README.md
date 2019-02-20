# Nectar

Flutter widget to fade the display of an network image.
You can configure the 'waiting' child and the fading duration.

## Usage

```
new NectarImage.loadingScreen(
        'https://camo.githubusercontent.com/cc78649bf43a7295cbab36eb7b5c7fe05b0f2bdb/68747470733a2f2f666c75747465722e696f2f696d616765732f666c75747465722d6d61726b2d7371756172652d3130302e706e67',
        duration: 4000, // optional
        backgroundColor: Colors.white, // optional, define default waiting background
        foregroundColor: Colors.blue, // optional, define default waiting foreground
        // optional, replace waiting with your Widget like your animation or image.
        /*waiting: new Icon(
            Icons.person,
            size: 18.0,
            color: Colors.red
        )*/
      ),
 ```

## Getting Started

Find more Flutter Resources =>[Awesome Flutter](https://github.com/Solido/awesome-flutter)
