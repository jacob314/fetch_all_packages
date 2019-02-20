import 'package:meta/meta.dart';

class QuantConfig {
  final int quality;
  final int numColor;

  final int width;
  final int height;
  final int srcW;
  final int srcH;

  final bool dither;

  final int ditherLvl;

  const QuantConfig({
    @required this.width,
    @required this.height,
    @required this.srcW,
    @required this.srcH,
    @required this.numColor,
    @required this.quality,
    this.dither: false,
    this.ditherLvl: 42,
  });

  /// copy-create
  QuantConfig copyWith({
    int quality,
    int numColor,
    int width,
    int height,
    int srcW,
    int srcH,
    bool dither,
    int ditherLvl,
  }) {
    return new QuantConfig(
      width: width ?? this.width,
      height: height ?? this.height,
      quality: quality ?? this.quality,
      srcW: srcW ?? this.srcW,
      srcH: srcH ?? this.srcH,
      numColor: numColor ?? this.numColor,
      dither: dither ?? this.dither,
      ditherLvl: ditherLvl ?? this.ditherLvl,
    );
  }

  @override
  String toString() {
    return '''QuantConfig 
     size: $width x $height 
     colors: ${numColor}
     quality: ${quality}
     dither ${dither}  ${dither ? ditherLvl : ''}
     ''';
  }

  bool operator ==(o) =>
      o is QuantConfig &&
      (width == o.width && height == o.height) &&
      quality == o.quality &&
      numColor == o.numColor &&
      dither == o.dither &&
      ditherLvl == o.ditherLvl;
}
