import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:quantize_plugin/quant_config.dart';
import 'package:quantize_plugin/quant_result.dart';

class QuantizePlugin {
  static const MethodChannel _channel = const MethodChannel('quantize_plugin');


  static Future<QuantizeResult> quantize(QuantConfig qCfg) async {
    var result = await _channel.invokeMethod("quantize", {
      "numColors": qCfg.numColor,
      "quality": qCfg.quality,
      "width": qCfg.width,
      "height": qCfg.height,
      "dither": qCfg.dither,
      "ditherLvl": qCfg.ditherLvl,
      "srcW": qCfg.srcW,
      "srcH": qCfg.srcH,
    });

    if (result != null) {
      QuantizeResult quantized = QuantizeResult.fromChannel(
        config: qCfg, // needed for rendering
        ind: result[0] as Uint8List,
        pal: result[1] as Uint8List,
      );

      return quantized;
    } else {
      print("error while quantizing");
      return null;
    }


    // nothing
  }

  static Future<bool> load({
    @required Uint8List original,
    @required int width,
    @required int height,
  }) async {
    dynamic params = {
      "original": original,
      "width": width,
      "height": height,
    };
    final bool loaded = await _channel.invokeMethod("load_original", params);
    return loaded;
  }
}
