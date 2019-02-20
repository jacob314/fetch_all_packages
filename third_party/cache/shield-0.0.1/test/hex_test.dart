
import 'package:shield/hex.dart';
import 'package:test/test.dart';

Map<String, List<int>> vectors = {
  "": const [],
  "0001020304050607": const [0, 1, 2, 3, 4, 5, 6, 7],
  "08090a0b0c0d0e0f": const [8, 9, 10, 11, 12, 13, 14, 15],
  "f0f1f2f3f4f5f6f7": const [0xf0, 0xf1, 0xf2, 0xf3, 0xf4, 0xf5, 0xf6, 0xf7],
  "f8f9fafbfcfdfeff": const [0xf8, 0xf9, 0xfa, 0xfb, 0xfc, 0xfd, 0xfe, 0xff],
  "e3a1": const [0xe3, 0xa1],
};

void main() {
  test('encoding', () {
    vectors.forEach((hexStr, bytes) {
      expect(hex.encode(bytes), equals(hexStr));
    });
  });

  test('decoding', () {
    vectors.forEach((hexStr, bytes) {
      expect(hex.decode(hexStr), orderedEquals(bytes));
    });
  });

  test('encoding uppercase', (){
    vectors.forEach((hexStr, bytes) {
      expect(const HexEncoder(upperCase: true).convert(bytes), equals(hexStr.toUpperCase()));
    });
  });

  test('invalid characters', () {
    expect(() => hex.decode('xx'), throwsFormatException);
    expect(() => hex.encode(const [256]), throwsFormatException);
  });
}
