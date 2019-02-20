import 'parse_instance.dart';
import 'parse_http_client.dart';

abstract class ParseBaseObject {
  final String className;
  ParseHTTPClient parseClient;
  String path;
  Map<String, dynamic> objectData;

  String get objectId => objectData['objectId'];

  // ignore: unused_element
  void _handleResponse(Map<String, dynamic> response) {}

  ParseBaseObject(this.className, [ParseInstance parseInstance]) {
    this.parseClient = ParseHTTPClient(parseInstance);
  }
}
