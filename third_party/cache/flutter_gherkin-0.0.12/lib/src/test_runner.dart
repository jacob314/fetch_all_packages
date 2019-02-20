import 'dart:io';
import 'package:flutter_gherkin/src/configuration.dart';
import 'package:flutter_gherkin/src/feature_file_runner.dart';
import 'package:flutter_gherkin/src/gherkin/expressions/gherkin_expression.dart';
import 'package:flutter_gherkin/src/gherkin/expressions/tag_expression.dart';
import 'package:flutter_gherkin/src/gherkin/parameters/custom_parameter.dart';
import 'package:flutter_gherkin/src/gherkin/parameters/plural_parameter.dart';
import 'package:flutter_gherkin/src/gherkin/parameters/word_parameter.dart';
import 'package:flutter_gherkin/src/gherkin/parameters/string_parameter.dart';
import 'package:flutter_gherkin/src/gherkin/parameters/int_parameter.dart';
import 'package:flutter_gherkin/src/gherkin/parameters/float_parameter.dart';
import 'package:flutter_gherkin/src/gherkin/parser.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/feature_file.dart';
import 'package:flutter_gherkin/src/gherkin/steps/exectuable_step.dart';
import 'package:flutter_gherkin/src/gherkin/steps/step_definition.dart';
import 'package:flutter_gherkin/src/hooks/aggregated_hook.dart';
import 'package:flutter_gherkin/src/hooks/hook.dart';
import 'package:flutter_gherkin/src/reporters/aggregated_reporter.dart';
import 'package:flutter_gherkin/src/reporters/message_level.dart';
import 'package:flutter_gherkin/src/reporters/reporter.dart';

class GherkinRunner {
  final _reporter = AggregatedReporter();
  final _hook = AggregatedHook();
  final _parser = GherkinParser();
  final _tagExpressionEvaluator = TagExpressionEvaluator();
  final List<ExectuableStep> _executableSteps = <ExectuableStep>[];
  final List<CustomParameter> _customParameters = <CustomParameter>[];

  Future<void> execute(TestConfiguration config) async {
    config.prepare();
    _registerReporters(config.reporters);
    _registerHooks(config.hooks);
    _registerCustomParameters(config.customStepParameterDefinitions);
    _registerStepDefinitions(config.stepDefinitions);

    List<FeatureFile> featureFiles = <FeatureFile>[];
    for (var glob in config.features) {
      for (var entity in glob.listSync()) {
        await _reporter.message(
            "Found feature file '${entity.path}'", MessageLevel.verbose);
        final contents = File(entity.path).readAsStringSync();
        final featureFile =
            await _parser.parseFeatureFile(contents, entity.path, _reporter);
        featureFiles.add(featureFile);
      }
    }

    bool allFeaturesPassed = true;

    if (featureFiles.isEmpty) {
      await _reporter.message(
          "No feature files found to run, exitting without running any scenarios",
          MessageLevel.warning);
    } else {
      await _reporter.message(
          "Found ${featureFiles.length} feature file(s) to run",
          MessageLevel.info);

      if (config.order == ExecutionOrder.random) {
        await _reporter.message(
            "Executing features in random order", MessageLevel.info);
        featureFiles = featureFiles.toList()..shuffle();
      }

      await _hook.onBeforeRun(config);

      try {
        await _reporter.onTestRunStarted();
        for (var featureFile in featureFiles) {
          final runner = FeatureFileRunner(config, _tagExpressionEvaluator,
              _executableSteps, _reporter, _hook);
          allFeaturesPassed &= await runner.run(featureFile);
        }
      } finally {
        await _reporter.onTestRunFinished();
      }

      await _hook.onAfterRun(config);
    }

    await _reporter.dispose();
    exitCode = allFeaturesPassed ? 0 : 1;

    if (config.exitAfterTestRun) exit(allFeaturesPassed ? 0 : 1);
  }

  void _registerStepDefinitions(
      Iterable<StepDefinitionGeneric> stepDefinitions) {
    stepDefinitions.forEach((s) {
      _executableSteps.add(
          ExectuableStep(GherkinExpression(s.pattern, _customParameters), s));
    });
  }

  void _registerCustomParameters(Iterable<CustomParameter> customParameters) {
    _customParameters.add(FloatParameterLower());
    _customParameters.add(FloatParameterCamel());
    _customParameters.add(NumParameterLower());
    _customParameters.add(NumParameterCamel());
    _customParameters.add(IntParameterLower());
    _customParameters.add(IntParameterCamel());
    _customParameters.add(StringParameterLower());
    _customParameters.add(StringParameterCamel());
    _customParameters.add(WordParameterLower());
    _customParameters.add(WordParameterCamel());
    _customParameters.add(PluralParameter());
    if (customParameters != null) _customParameters.addAll(customParameters);
  }

  void _registerReporters(Iterable<Reporter> reporters) {
    if (reporters != null) {
      reporters.forEach((r) => _reporter.addReporter(r));
    }
  }

  void _registerHooks(Iterable<Hook> hooks) {
    if (hooks != null) {
      _hook.addHooks(hooks);
    }
  }
}
