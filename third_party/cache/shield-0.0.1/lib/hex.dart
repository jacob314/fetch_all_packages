import 'dart:convert';
import 'dart:typed_data';

// https://github.com/stevenroose/dart-hex/blob/master/lib/hex.dart

const String _BASE = '0123456789abcdef';

/// An instance of the default implementation of the [HexCodec].
const hex = const HexCodec();

/**
 * A codec for encoding and decoding byte arrays to and from
 * hexadecimal strings.
 */
class HexCodec extends Codec<List<int>, String> {
  const HexCodec();

  @override
  Converter<List<int>, String> get encoder => const HexEncoder();

  @override
  Converter<String, List<int>> get decoder => const HexDecoder();
}

/**
 * A converter to encode byte arrays into hexadecimal strings.
 */
class HexEncoder extends Converter<List<int>, String> {
  final bool upperCase;

  const HexEncoder({this.upperCase: false});

  @override
  String convert(List<int> input) {
    StringBuffer buffer = StringBuffer();
    for (int byte in input) {
      if (byte & 0xff != byte) {
        throw new FormatException('Non-byte integer detected');
      }
      buffer.write('${byte < 16 ? '0' : ''}${byte.toRadixString(16)}');
    }

    if (upperCase) {
      return buffer.toString().toUpperCase();
    } else {
      return buffer.toString();
    }
  }
}

/**
 * A converter to decode hexadecimal strings into byte arrays.
 */
class HexDecoder extends Converter<String, List<int>> {
  const HexDecoder();

  @override
  List<int> convert(String input) {
    String str = input.replaceAll(' ', '');
    str = str.toLowerCase();
    if (str.length % 2 != 0) {
      str = '0' + str;
    }

    Uint8List result = Uint8List(str.length ~/ 2);
    int firstDigit, secondDigit;
    for (int i = 0; i < result.length; i++) {
      firstDigit = _BASE.indexOf(str[i * 2]);
      secondDigit = _BASE.indexOf(str[i * 2 + 1]);
      if (firstDigit == -1 || secondDigit == -1) {
        throw FormatException('Non-hex character detected in $input');
      }
      result[i] = (firstDigit << 4) + secondDigit;
    }

    return result;
  }
}
