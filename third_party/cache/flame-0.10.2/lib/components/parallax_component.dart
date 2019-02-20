import 'dart:async';
import 'dart:ui';

import 'package:flutter/src/painting/decoration_image.dart';

import '../flame.dart';
import 'component.dart';

class ParallaxRenderer {
  String filename;
  Future<Image> future;

  Image image;
  double scroll = 0.0;

  ParallaxRenderer(this.filename) {
    this.future = _load();
  }

  Future<Image> _load() {
    return Flame.images.load(filename).then((image) {
      this.image = image;
    });
  }

  bool loaded() => image != null;

  void render(Canvas canvas, Rect rect) {
    if (image == null) {
      return;
    }

    var imageHeight = image.height / window.devicePixelRatio;
    var imageWidth =
        (rect.height / imageHeight) * (image.width / window.devicePixelRatio);
    var count = rect.width / imageWidth;

    Rect fullRect = new Rect.fromLTWH(
        -scroll * imageWidth, rect.top, (count + 1) * imageWidth, rect.height);

    paintImage(
      canvas: canvas,
      image: image,
      rect: fullRect,
      repeat: ImageRepeat.repeatX,
    );
  }
}

abstract class ParallaxComponent extends PositionComponent {
  final BASE_SPEED = 30;
  final LAYER_DELTA = 40;

  List<ParallaxRenderer> _layers = new List();
  Size _size;
  bool _loaded = false;

  @override
  void resize(Size size) {
    this._size = size;
  }

  /// Loads the images defined by this list of filenames. All images are positioned at its scroll center.
  ///
  /// @param filenames Image filenames
  void load(List<String> filenames) {
    final futures = filenames.fold(<Future<Image>>[],
        (List<Future<Image>> result, String filename) {
      final layer = new ParallaxRenderer(filename);
      _layers.add(layer);
      result.add(layer.future);
      return result;
    });
    Future.wait(futures).then((r) => _loaded = true);
  }

  void updateScroll(int layerIndex, scroll) {
    _layers[layerIndex].scroll = scroll;
  }

  @override
  bool loaded() {
    return _loaded;
  }

  @override
  void render(Canvas canvas) {
    if (!loaded()) {
      return;
    }

    canvas.save();
    prepareCanvas(canvas);
    _drawLayers(canvas);
    canvas.restore();
  }

  void _drawLayers(Canvas canvas) {
    Rect rect = new Rect.fromPoints(
        const Offset(0.0, 0.0), new Offset(_size.width, _size.height));
    _layers.forEach((layer) => layer.render(canvas, rect));
  }

  @override
  void update(double delta) {
    if (!this.loaded()) {
      return;
    }
    for (int i = 0; i < _layers.length; i++) {
      double scroll = _layers[i].scroll;
      scroll += (BASE_SPEED + i * LAYER_DELTA) * delta / _size.width;
      if (scroll > 1) {
        scroll = scroll % 1;
      }
      _layers[i].scroll = scroll;
    }
  }
}
