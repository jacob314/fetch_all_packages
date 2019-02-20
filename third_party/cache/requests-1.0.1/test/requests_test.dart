import 'package:requests/requests.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('plain http get', () async {
      String body = await Requests.get("https://google.com");
      expect(body, isNotNull);
    });

    test('json http get list of objects', () async {
      dynamic body = await Requests.get("https://jsonplaceholder.typicode.com/posts", json: true);
      expect(body, isNotNull);
      expect(body, isList);
    });

    test('json http post', () async {
      await Requests.post("https://jsonplaceholder.typicode.com/posts", body: {
        "userId": 10,
        "id": 91,
        "title": "aut amet sed",
        "body": "libero voluptate eveniet aperiam sed\nsunt placeat suscipit molestias\nsimilique fugit nam natus\nexpedita consequatur consequatur dolores quia eos et placeat",
      });
    });

    test('json http get object', () async {
      dynamic body = await Requests.get("https://jsonplaceholder.typicode.com/posts/1", json: true);
      expect(body, isNotNull);
      expect(body, isMap);
    });
  });
}
