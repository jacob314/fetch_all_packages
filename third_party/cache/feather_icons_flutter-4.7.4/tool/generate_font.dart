import 'dart:convert';
import 'dart:io';

import 'package:recase/recase.dart';

void main(List<String> arguments) {
  var file = new File(arguments.first);

  if (!file.existsSync()) {
    print('Cannot find the file "${arguments.first}".');
  }

  var content = file.readAsStringSync();
  Map<String, dynamic> icons = json.decode(content);

  Map<String, String> iconDefinitions = {};

  for (String iconName in icons.keys) {
    var icon = icons[iconName];
    var unicode = icon['unicode'];
    
    iconDefinitions[iconName] = generateIconDefinition(
      iconName,
      unicode,
    );
  }

  List<String> generatedOutput = [
    'library feather_icons_flutter;',
    '',
    "import 'package:flutter/widgets.dart';",
    "import 'package:feather_icons_flutter/icon_data.dart';",
    '',
    '// THIS FILE IS AUTOMATICALLY GENERATED!',
    '',
    'class FeatherIcons {',
  ];

  generatedOutput.addAll(iconDefinitions.values);

  generatedOutput.add('}');

  File output = new File('lib/feather_icons_flutter.dart');
  output.writeAsStringSync(generatedOutput.join('\n'));
}

String generateIconDefinition(String iconName, String unicode) {
  String iconDataSource = 'IconData';

  iconName = new ReCase(iconName).camelCase;

  return 'static const IconData $iconName = const IconDataFeather(0x$unicode);';
}