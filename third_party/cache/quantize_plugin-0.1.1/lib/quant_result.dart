import 'dart:typed_data';

import 'package:quantize_plugin/quant_config.dart';

class QuantizeResult {
  final QuantConfig config;
  final Uint8List palette;
  final Uint8List indices;

  const QuantizeResult({this.config, this.palette, this.indices});

  QuantizeResult.fromChannel({Uint8List ind, Uint8List pal, this.config})
      : indices =
  Uint8List.view(ind.buffer, ind.offsetInBytes, ind.lengthInBytes),
        palette =
        Uint8List.view(pal.buffer, pal.offsetInBytes, pal.lengthInBytes);
}
