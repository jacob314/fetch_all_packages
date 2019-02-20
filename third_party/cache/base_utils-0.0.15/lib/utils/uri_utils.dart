import 'package:base_utils/utils/logging_utils.dart';
import 'package:base_utils/utils/string_utils.dart';

String obtainPathAfterTarget(String url, {String target}) {
  final uri = Uri.parse(url);
  for (int i = 0; i < uri.pathSegments.length; i++) {
    if (i >= 1 && uri.pathSegments[i - 1] == target) {
      return uri.pathSegments[i];
    }
  }
  return null;
}

bool containsTarget(String url, String target) {
  if (isNotEmpty(url)) {
    Uri uri = Uri.parse(url);
    for (int i = 0; i < uri.pathSegments.length; i++) {
      if (uri.pathSegments[i] == target) {
        return true;
      }
    }
  }
  return false;
}

String getHost(Uri uri) {
  var tmp = uri?.replace(path: '')?.toString();
  log('getHost: $tmp');
  return tmp;
}
