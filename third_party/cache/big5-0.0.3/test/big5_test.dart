import 'package:test/test.dart';

import 'package:big5/big5.dart';

void main() {
  test('decode some bytes of with big5 encoded', () {
    expect(big5.decode([173, 68, 166, 184]), "胖次");
    expect(
        big5.decode([
          27,
          91,
          49,
          59,
          51,
          49,
          109,
          166,
          226,
          189,
          88,
          180,
          250,
          184,
          213,
          27,
          91,
          48,
          109
        ]),
        "\x1b[1;31m色碼測試\x1b[0m");
    expect(big5.encode("胖次"), [173, 68, 166, 184]);
    expect(
        "\x1b[1;31m色碼測試\x1b[0m",
        big5.decode([
          27,
          91,
          49,
          59,
          51,
          49,
          109,
          166,
          226,
          189,
          88,
          180,
          250,
          184,
          213,
          27,
          91,
          48,
          109
        ]));
  });
}
