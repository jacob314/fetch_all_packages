# ubuntu_font_flutter

Placing the Ubuntu Font Family downloaded form the [Ubuntu font](https://design.ubuntu.com/font/) website into the lib folder.

## How to use

To use this package, place the following in your `pubspec.yaml` file.

```yaml
flutter:
  fonts:
    - family: Ubuntu
      fonts:
        - asset: packages/ubuntu_font_flutter/Ubuntu-R.ttf
        - asset: packages/ubuntu_font_flutter/Ubuntu-RI.ttf
          style: italic
        - asset: packages/ubuntu_font_flutter/Ubuntu-B.ttf
          weight: 700
        - asset: packages/ubuntu_font_flutter/Ubuntu-BI.ttf
          weight: 700
          style: italic
        - asset: packages/ubuntu_font_flutter/Ubuntu-L.ttf
          weight: 300
        - asset: packages/ubuntu_font_flutter/Ubuntu-LI.ttf
          weight: 300
          style: italic
        - asset: packages/ubuntu_font_flutter/Ubuntu-M.ttf
          weight: 500
        - asset: packages/ubuntu_font_flutter/Ubuntu-MI.ttf
          weight: 500
          style: italic
    - family: Ubuntu Mono
      fonts:
        - asset: packages/ubuntu_font_flutter/UbuntuMono-R.ttf
        - asset: packages/ubuntu_font_flutter/UbuntuMono-RI.ttf
          style: italic
        - asset: packages/ubuntu_font_flutter/UbuntuMono-B.ttf
          weight: 700
        - asset: packages/ubuntu_font_flutter/UbuntuMono-BI.ttf
          weight: 700
          style: italic
    - family: Ubuntu Condensed
      fonts:
        - asset: packages/ubuntu_font_flutter/Ubuntu-C.ttf
```
