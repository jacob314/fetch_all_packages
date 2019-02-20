library chamber_generator;

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/generator.dart';

Builder chamberGeneratorFactory(BuilderOptions options) => PartBuilder(
      [ModelGenerator()],
      ".chamber.dart",
    );
