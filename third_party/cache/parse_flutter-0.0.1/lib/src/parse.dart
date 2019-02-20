import 'parse_configuration.dart';
import 'parse_instance.dart';

import 'parse_http_client.dart';
import 'parse_livequery.dart';
import 'parse_object.dart';
import 'parse_user.dart';

class Parse {
  ParseInstance parseInstance = ParseInstance();
  ParseHTTPClient client;

  static ParseObject object(objectName) {
    return ParseObject(objectName);
  }

  static User user() {
    return User();
  }

  static LiveQuery liveQuery() {
    return LiveQuery();
  }

  static Parse initialize(ParseConfiguration config) {
    config.save();
    return _buildParseObject();
  }

  static Parse getInstance() {
    return _buildParseObject();
  }
  
  static Parse _buildParseObject(){
    Parse parse = Parse();
    parse.parseInstance = _getParseInstance(ParseConfiguration());
    parse.client = ParseHTTPClient(parse.parseInstance);
    return parse;
  }

  static ParseInstance _getParseInstance(ParseConfiguration value) {
    ParseInstance instance = ParseInstance();

    value.getApplicationId().then((val) {
      instance.applicationId = val;
    });

    value.getMasterKey().then((val) {
      instance.masterKey = val;
    });

    value.getLiveQueryUrl().then((val) {
      instance.liveQueryUrl = val;
    });

    value.getServerUrl().then((val) {
      instance.serverUrl = val;
    });

    value.getSessionId().then((val) {
      instance.sessionId = val;
    });

    return instance;
  }
}
