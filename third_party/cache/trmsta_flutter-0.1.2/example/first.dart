import "package:trmsta/trmsta.dart";
import "dart:async";

Future main() async {
  print("hej");
  Downloaded nasz = await download();
  print(nasz.ParseSta() );
  print(nasz.ParseData());
  print(nasz.ParseAll() );
}

