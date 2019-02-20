import 'package:base_utils/utils/string_utils.dart';

class LoggerEx {
  static const MAX_LENGTH = 300;
  static const LEVEL_DEBUG = 1;
  static const LEVEL_NONE = 2;
  static final LoggerEx instance = new LoggerEx._internal();

  String name = "SendoFlutter";
  int level = LEVEL_DEBUG;

  LoggerEx._internal();

  String getLevel() {
    switch (level) {
      case LEVEL_DEBUG:
        return 'DEBUG';
      case LEVEL_NONE:
      default:
        return 'NONE';
    }
  }

  void log(dynamic o) {
    if (level < LEVEL_NONE) {
      String tmp = o?.toString();
      if (isNotEmpty(tmp)) {
        List<String> list = List<String>();
        if (tmp.length > MAX_LENGTH) {
          while (tmp.length > MAX_LENGTH) {
            list.add(tmp.substring(0, MAX_LENGTH));
            if (tmp.length > MAX_LENGTH)
              tmp = tmp.substring(MAX_LENGTH);
            else
              tmp = '';
          }
          list.add(tmp);
          for (int i = 0; i < list.length; i++) {
            if (i == 0)
              print(
                  '[${DateTime.now().toString()}][$name][${getLevel()}]: ${list[i]}');
            else if (isNotEmpty(list[i])) print(list[i]);
          }
        } else {
          print('[${DateTime.now().toString()}][$name][${getLevel()}]: $tmp');
        }
      }
    }
  }
}

void log(dynamic o) {
  LoggerEx.instance.log(o);
}

void setupLogger({String name, int level = LoggerEx.LEVEL_DEBUG}) {
  LoggerEx.instance.name = name;
  LoggerEx.instance.level = level;
}
