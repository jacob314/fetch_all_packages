import 'dart:convert';

class RouteInfo {
  final String path;
  final Map<String, Object> arguments;

  RouteInfo(this.path, this.arguments);
}

@Deprecated('使用parseKeyValueRoute代替')
RouteInfo parseRoute(String routeName) {
  //  分解出路径和参数
  List<String> pathAndArguments = routeName.split('?');
  // 获取路径
  String path = pathAndArguments[0];
  Map<String, Object> arguments = {};
  try {
    // 参数按&分解成键值对
    final argumentsList = pathAndArguments[1].split('&');
    // 每个键值对分解到Map中去
    argumentsList.forEach((argumentEntry) {
      final keyValue = argumentEntry.split('=');
      arguments[keyValue[0]] = keyValue[1];
    });
  } catch (e) {
    arguments = {};
  }
  return RouteInfo(path, arguments);
}

RouteInfo parseKeyValueRoute(String routeName) => parseRoute(routeName);

RouteInfo parseJsonRoute(String routeName) {
  //  分解出路径和参数
  List<String> pathAndArguments = routeName.split('?');
  // 获取路径
  String path = pathAndArguments[0];
  Map<String, Object> arguments = {};
  try {
    arguments = jsonDecode(pathAndArguments[1]);
  } catch (e) {
    arguments = {};
  }
  return RouteInfo(path, arguments);
}
