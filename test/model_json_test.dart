import 'dart:io';
import 'dart:convert';
import 'package:carp_serializable/carp_serializable.dart';
import 'package:research_package/research_package.dart';
import 'package:test/test.dart';

void main() {
  RPConsentSignature signature = RPConsentSignature(identifier: "signatureID");

  RPConsentSection overviewSection = RPConsentSection(
      type: RPConsentSectionType.Overview,
      summary: "Welcome to this survey",
      content: "Overview content");

  RPConsentSection dataGatheringSection = RPConsentSection(
      type: RPConsentSectionType.DataGathering,
      summary: "This is a summary for Data Gathering.",
      content: "Data Gathering content");

  RPConsentDocument consentDocument = RPConsentDocument(
    title: 'WHO5 Consent',
    sections: [
      overviewSection,
      dataGatheringSection,
    ],
  );
  consentDocument.addSignature(signature);

  List<RPChoice> choices = [
    RPChoice(text: "All of the time", value: 5),
    RPChoice(text: "Most of the time", value: 4),
    RPChoice(text: "More than half of the time", value: 3),
    RPChoice(text: "Less than half of the time", value: 2),
    RPChoice(text: "Some of the time", value: 1),
    RPChoice(text: "At no time", value: 0),
  ];

  RPChoiceAnswerFormat choiceAnswerFormat = RPChoiceAnswerFormat(
    answerStyle: RPChoiceAnswerStyle.SingleChoice,
    choices: choices,
  );

  RPQuestionStep choiceQuestionStep1 = RPQuestionStep(
    identifier: "questionStep1ID",
    title: "I have felt cheerful and in good spirits",
    answerFormat: choiceAnswerFormat,
  );

  RPQuestionStep choiceQuestionStep2 = RPQuestionStep(
    identifier: "questionStep2ID",
    title: "I have felt calm and relaxed",
    answerFormat: choiceAnswerFormat,
  );

  RPActivityStep activityStep1 = RPActivityStep(
    identifier: 'act_1',
    includeInstructions: true,
    includeResults: false,
  );
  RPActivityStep activityStep2 = RPActivityStep(identifier: 'act_2');

  RPFormStep formStep = RPFormStep(
    identifier: 'form_step_1',
    questions: [choiceQuestionStep1, choiceQuestionStep2],
    title: 'A form w. questions',
  );

  RPStepResult stepResult1 = RPStepResult(
      identifier: choiceQuestionStep1.identifier,
      questionTitle: choiceQuestionStep1.title,
      answerFormat: choiceQuestionStep1.answerFormat);
  stepResult1.setResult(5);

  RPStepResult stepResult2 = RPStepResult(
      identifier: choiceQuestionStep2.identifier,
      questionTitle: choiceQuestionStep2.title,
      answerFormat: choiceQuestionStep2.answerFormat);
  stepResult2.setResult(1);

  RPTaskResult surveyTaskResult =
      RPTaskResult(identifier: "surveyTaskResultID");
  surveyTaskResult.setStepResultForIdentifier("questionID1", stepResult1);
  surveyTaskResult.setStepResultForIdentifier("questionID2", stepResult2);

  RPSignatureResult signatureResult = RPSignatureResult.withParams(
      "TestFirstName",
      "TestLastName",
      "pngbytes in form of a long long string");

  RPConsentSignatureResult consentSignatureResult = RPConsentSignatureResult(
      identifier: 'consentSignatureID',
      consentDocument: consentDocument,
      signature: signatureResult);

  // RPConsentReviewStep consentReviewStep =
  //     RPConsentReviewStep(identifier: 'consentReviewStepID', consentDocument: consentDocument);

  RPStepResult consentReviewStepResult = RPStepResult(
      identifier: '',
      questionTitle: choiceQuestionStep1.title,
      answerFormat: RPFormAnswerFormat());
  consentReviewStepResult.setResult(consentSignatureResult);

  RPTaskResult consentTaskResult =
      RPTaskResult(identifier: "consentTaskResultID");
  consentTaskResult.setStepResultForIdentifier(
      "signature", consentReviewStepResult);

  setUp(() {
    // initialize the package and json deserialization functions
    ResearchPackage.ensureInitialized();
  });

  group('Consent Document', () {
    test('RPConsentDocument -> JSON', () {
      print(toJsonString(consentDocument));

      expect(consentDocument.title, "WHO5 Consent");
    });

    test('JSON -> RPConsentDocument, assert document title', () {
      final consentDocumentJson = toJsonString(consentDocument);

      RPConsentDocument consentDocument_2 = RPConsentDocument.fromJson(
          json.decode(consentDocumentJson) as Map<String, dynamic>);
      expect(consentDocument_2.title, consentDocument.title);

      print(toJsonString(consentDocument_2));
    });

    // Consent Section

    test('RPConsentSection -> JSON', () {
      print(toJsonString(overviewSection));

      expect(overviewSection.content, "Overview content");
    });

    test('JSON -> RPConsentDocument, assert document title', () {
      final consentDocumentJson = toJsonString(consentDocument);

      RPConsentDocument consentDocument_2 = RPConsentDocument.fromJson(
          json.decode(consentDocumentJson) as Map<String, dynamic>);
      expect(consentDocument_2.title, consentDocument.title);

      print(toJsonString(consentDocument_2));
    });

    test('RPConsentSignature -> JSON', () {
      print(toJsonString(signature));

      expect(signature.identifier, "signatureID");
    });

    test('JSON -> RPConsentSignature', () {
      final consentSignatureJson = toJsonString(signature);

      RPConsentSignature signature_2 = RPConsentSignature.fromJson(
          json.decode(consentSignatureJson) as Map<String, dynamic>);
      expect(signature_2.identifier, 'signatureID');

      print(toJsonString(signature_2));
    });
  });

  // CARP delivers study configurations as JSON. If the permission fields do not
  // survive a round trip, a deployed study silently stops asking the participant
  // for permissions without any error - hence these tests.
  group('Permissions', () {
    test('RPConsentSection with permissions -> JSON -> RPConsentSection', () {
      RPConsentSection section = RPConsentSection(
          type: RPConsentSectionType.Location,
          summary: "Why we need your location",
          permissions: [
            RPPermissionType.location,
            RPPermissionType.activityRecognition
          ]);

      RPConsentSection section_2 = RPConsentSection.fromJson(
          json.decode(toJsonString(section)) as Map<String, dynamic>);

      expect(section_2.permissions, section.permissions);
      print(toJsonString(section_2));
    });

    test('RPConsentSection without permissions omits the field', () {
      // A consent flow which does not ask for permissions must serialize exactly
      // as it did before this feature existed.
      expect(toJsonString(overviewSection).contains('permissions'), isFalse);
    });

    test('RPVisualConsentStep -> JSON -> RPVisualConsentStep, askPermission',
        () {
      RPVisualConsentStep step = RPVisualConsentStep(
          identifier: 'visualStepID',
          consentDocument: consentDocument,
          askPermission: true);

      RPVisualConsentStep step_2 = RPVisualConsentStep.fromJson(
          json.decode(toJsonString(step)) as Map<String, dynamic>);

      expect(step_2.askPermission, isTrue);
      // The default has to stay opt-out, so an existing configuration which
      // knows nothing about permissions never starts asking for them.
      expect(
          RPVisualConsentStep(
                  identifier: 'visualStepID', consentDocument: consentDocument)
              .askPermission,
          isFalse);
      print(toJsonString(step_2));
    });

    test('RPPermissionResult -> JSON -> RPPermissionResult', () {
      RPPermissionResult result =
          RPPermissionResult(identifier: 'visualStepID')
            ..setStatus(RPPermissionType.location, RPPermissionStatus.granted)
            ..setStatus(RPPermissionType.health, RPPermissionStatus.denied);

      // Deserialized through the base class, like a stored task result is.
      final result_2 = RPResult.fromJson(
          json.decode(toJsonString(result)) as Map<String, dynamic>);

      expect(result_2, isA<RPPermissionResult>());
      expect((result_2 as RPPermissionResult).statuses, {
        RPPermissionType.location: RPPermissionStatus.granted,
        RPPermissionType.health: RPPermissionStatus.denied,
      });
      print(toJsonString(result_2));
    });
  });

  group('Choice Answer', () {
    test('RPAnswerFormat -> JSON', () {
      print(toJsonString(RPAnswerFormat()..questionType = RPQuestionType.Date));
    });

    test('RPChoiceAnswerFormat -> JSON', () {
      print(toJsonString(choiceAnswerFormat));

      expect(choiceAnswerFormat.choices, choices);
    });

    test('RPChoice -> JSON', () {
      print(toJsonString(choices.first));

      expect(choices.first.value, 5);
    });

    test('JSON -> RPChoiceAnswerFormat', () {
      final choiceJson = toJsonString(choiceAnswerFormat);

      RPAnswerFormat answers = RPAnswerFormat.fromJson(
          json.decode(choiceJson) as Map<String, dynamic>);
      expect(
          answers.runtimeType,
          RPChoiceAnswerFormat(
              answerStyle: RPChoiceAnswerStyle.SingleChoice,
              choices: []).runtimeType);
      expect(answers.questionType, RPQuestionType.SingleChoice);
      print(toJsonString(answers));
    });
  });

  group('Steps', () {
    test('RPQuestionStep -> JSON', () {
      print(toJsonString(choiceQuestionStep1));
    });

    test('RPInstructionStep -> JSON', () {
      print(toJsonString(RPInstructionStep(
          identifier: '123',
          title: 'Jakob is here...',
          detailText: '... more details.')));
    });

    test('RPFormStep -> JSON', () {
      print(toJsonString(formStep));
    });

    test('JSON -> RPQuestionStep', () {
      final stepJson = toJsonString(choiceQuestionStep1);

      RPQuestionStep step = RPQuestionStep.fromJson(
          json.decode(stepJson) as Map<String, dynamic>);
      expect(
          step.runtimeType,
          RPQuestionStep(
                  identifier: '123', title: '', answerFormat: RPAnswerFormat())
              .runtimeType);
      expect(step.identifier, choiceQuestionStep1.identifier);
      print(toJsonString(step));
    });

    test('RPActivityStep -> JSON', () {
      print(toJsonString(activityStep1));
      print(toJsonString(activityStep2));
    });
  });

  group('Results', () {
    test('RPStepResult -> JSON', () {
      print((stepResult1));
      print((stepResult1.toJson()));
      print(toJsonString(stepResult1));
      expect(stepResult1.results["answer"], 5);
    });

    test('RPTaskResult (Survey) -> JSON', () {
      print(toJsonString(surveyTaskResult));
      expect(surveyTaskResult.results["questionID1"], stepResult1);
    });

    test('RPTaskResult (Consent Document) -> JSON', () {
      print(toJsonString(consentTaskResult));
      expect(consentTaskResult.results["signature"], consentReviewStepResult);
    });

    test('JSON -> RPStepResult', () async {
      String plainJson = File('test/json/step_result.json').readAsStringSync();

      final step =
          RPStepResult.fromJson(json.decode(plainJson) as Map<String, dynamic>);

      expect(step.$type, step.runtimeType.toString());
      expect(step.results['answer'], 5);
      print(toJsonString(step));
    });

    test('JSON -> RPTaskResult', () async {
      String plainJson = File('test/json/task_result.json').readAsStringSync();

      final task =
          RPTaskResult.fromJson(json.decode(plainJson) as Map<String, dynamic>);

      expect(task.$type, task.runtimeType.toString());
      expect(task.results.values.first.$type, 'RPStepResult');
      print(toJsonString(task));
    });

    test('JSON -> Consent Document', () async {
      String plainJson =
          File('test/json/consent_result.json').readAsStringSync();

      final consent =
          RPTaskResult.fromJson(json.decode(plainJson) as Map<String, dynamic>);

      expect(consent.$type, consent.runtimeType.toString());
      expect(consent.results.keys.first, 'signature');
      print(toJsonString(consent));
    });
  });
}
