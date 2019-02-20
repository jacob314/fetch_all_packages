library flrouter;

import 'package:flutter/material.dart';
import 'package:uri/uri.dart';

typedef Widget FlrouterBuilder(BuildContext context, UriMatch match);

class Flrouter {

  const Flrouter(final Map<String, FlrouterBuilder> definitions) : assert(definitions != null), this.definitions = definitions;

  Route<dynamic> get(final RouteSettings settings) {
    final route = this.definitions.keys.where((route) => UriParser(UriTemplate(route)).matches(Uri.parse(settings.name))).first;
    
    return MaterialPageRoute(builder: (context)=> this.definitions[route](context, UriParser(UriTemplate(route)).match(Uri.parse(settings.name))), settings: settings);
  }

  final Map<String, FlrouterBuilder> definitions;
}