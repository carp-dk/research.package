import 'dart:io';
import 'dart:convert';
import 'package:carp_serializable/carp_serializable.dart';
import 'package:test/test.dart';
import 'package:research_package/research_package.dart';

// ignore: avoid_relative_lib_imports
import '../example/lib/main.dart';

/// These tests takes the examples from the example app and tests de/serialization.
void main() {
  setUp(() {
    // initialize the package and json deserialization functions
    ResearchPackage.ensureInitialized();
  });

  group('Consent Document', () {
    test('Consent Document -> JSON', () {
      print(toJsonString(consentTask));

      expect(consentTask.steps.length, 4);
    });

    test('Consent Document -> JSON -> Consent Document :: deep assert',
        () async {
      final consentJson = toJsonString(consentTask);

      RPOrderedTask consent = RPOrderedTask.fromJson(
          json.decode(consentJson) as Map<String, dynamic>);
      expect(toJsonString(consent), equals(consentJson));
    });

    test('JSON file -> Consent Document', () async {
      String plainJson = File('test/json/consent_task.json').readAsStringSync();

      RPOrderedTask consent = RPOrderedTask.fromJson(
          json.decode(plainJson) as Map<String, dynamic>);

      expect(consent.steps.length, 4);
      expect(
          consent.steps.first.identifier, consentTask.steps.first.identifier);
      print(toJsonString(consent));
    });
  });

  group('Linear Survey', () {
    test('Linear Survey -> JSON', () {
      print(toJsonString(linearSurveyTask));
    });

    test('Linear Survey -> JSON -> Linear Survey :: deep assert', () async {
      final surveyJson = toJsonString(linearSurveyTask);

      RPOrderedTask survey = RPOrderedTask.fromJson(
          json.decode(surveyJson) as Map<String, dynamic>);
      expect(toJsonString(survey), equals(surveyJson));
    });

    test('JSON file -> Linear Survey', () async {
      String surveyJson =
          File('test/json/linear_survey.json').readAsStringSync();

      RPOrderedTask survey = RPOrderedTask.fromJson(
          json.decode(surveyJson) as Map<String, dynamic>);

      // Asserted against the file, not [linearSurveyTask]: the example app
      // comments steps in and out of its demo survey. The file is also the
      // richer artifact, still covering timer, form and question steps.
      expect(survey.identifier, 'surveyTaskID');
      expect(survey.steps.length, 9);
      expect(survey.steps.first.identifier, 'instructionID');
      expect(
          survey.steps.map((step) => step.runtimeType.toString()).toSet(),
          containsAll(
              ['RPInstructionStep', 'RPTimerStep', 'RPFormStep', 'RPQuestionStep']));
      print(toJsonString(survey));
    });
  });

  group('Navigable Survey', () {
    test('Emotional Distress -> JSON', () {
      print(toJsonString(emotionalDistress));
    });

    test('Emotional Distress -> JSON -> Navigable Survey :: deep assert',
        () async {
      final surveyJson = toJsonString(emotionalDistress);

      RPNavigableOrderedTask emotional = RPNavigableOrderedTask.fromJson(
          json.decode(surveyJson) as Map<String, dynamic>);
      expect(toJsonString(emotional), equals(surveyJson));
      // print(toJsonString(surveyJson));–
    });

    test('JSON file -> Emotional Distress', () async {
      String surveyJson =
          File('test/json/navigable_survey.json').readAsStringSync();

      RPNavigableOrderedTask emotional = RPNavigableOrderedTask.fromJson(
          json.decode(surveyJson) as Map<String, dynamic>);

      expect(emotional.steps.length, emotionalDistress.steps.length);
      expect(emotional.steps.first.identifier,
          emotionalDistress.steps.first.identifier);
      print(toJsonString(emotional));
    });

    test('Smoking Survey -> JSON', () {
      print(toJsonString(stepJumpNavigationExample1));
    });

    test('Smoking Survey -> JSON -> Navigable Survey :: deep assert', () async {
      final surveyJson = toJsonString(stepJumpNavigationExample1);

      RPNavigableOrderedTask smoking = RPNavigableOrderedTask.fromJson(
          json.decode(surveyJson) as Map<String, dynamic>);
      expect(toJsonString(smoking), equals(surveyJson));
      // print(toJsonString(surveyJson));–
    });

    test('JSON file -> Smoking Survey', () async {
      String surveyJson =
          File('test/json/smoking_survey.json').readAsStringSync();

      RPNavigableOrderedTask smoking = RPNavigableOrderedTask.fromJson(
          json.decode(surveyJson) as Map<String, dynamic>);

      expect(smoking.steps.length, stepJumpNavigationExample1.steps.length);
      expect(smoking.steps.first.identifier,
          stepJumpNavigationExample1.steps.first.identifier);
      print(toJsonString(smoking));
    });
  });
}
