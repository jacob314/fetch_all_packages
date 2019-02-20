import 'dart:async';

import 'package:build_runner/build_runner.dart';
import 'package:built_redux/generator.dart';
import 'package:built_value_generator/built_value_generator.dart';
import 'package:source_gen/source_gen.dart';
import 'package:source_gen/src/builder.dart';
import 'package:source_gen/src/generator.dart';

Future<Null> main(List<String> args) async {
  await watch(<BuildAction>[
    new BuildAction(
      new PartBuilder(<Generator>[
        const BuiltValueGenerator(),
        new BuiltReduxGenerator(),
      ]),
      'example',
      inputs: const <String>[
        'lib/**.dart',
      ],
    )
  ], deleteFilesByDefault: true);
}
