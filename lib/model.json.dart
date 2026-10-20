// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

bool _fromJsonFunctionsRegistered = false;

/// Register all the fromJson functions for the deployment domain classes.
void registerFromJsonFunctions() {
  if (_fromJsonFunctionsRegistered) return;
  _fromJsonFunctionsRegistered = true;

  // AnswerFormat classes
  FromJsonFactory().registerAll([
    RPAnswerFormat(),
    RPChoiceAnswerFormat(
        answerStyle: RPChoiceAnswerStyle.SingleChoice, choices: []),
    RPChoice(text: '', value: 1),
    RPDateTimeAnswerFormat(dateTimeAnswerStyle: RPDateTimeAnswerStyle.Date),
    RPFormAnswerFormat(),
    RPImageChoiceAnswerFormat(choices: []),
    RPImageChoice(description: '', imageUrl: ''),
    RPStarChoiceAnswerFormat(choices: []),
    RPStarChoice(starActiveUrl: '', starNotActiveUrl: '', description: ''),
    RPIntegerAnswerFormat(maxValue: 1, minValue: 1),
    RPDoubleAnswerFormat(maxValue: 1, minValue: 1),
    RPSliderAnswerFormat(divisions: 1, maxValue: 1, minValue: 1),
    RPTextAnswerFormat(),
  ]);

  // Steps classes
  FromJsonFactory().registerAll([
    RPStep(identifier: '', title: ''),
    RPActivityStep(identifier: ''),
    RPQuestionStep(identifier: '', title: '', answerFormat: RPAnswerFormat()),
    RPInstructionStep(identifier: '', title: ''),
    RPTimerStep(identifier: '', timeout: const Duration(), title: ''),
    RPFormStep(identifier: '', title: '', questions: []),
    RPCompletionStep(identifier: '', title: ''),
  ]);

  // Consent Document classes
  FromJsonFactory().registerAll([
    RPConsentReviewStep(
        identifier: '',
        title: '',
        consentDocument: RPConsentDocument(sections: [], title: '')),
    RPVisualConsentStep(
        identifier: '',
        consentDocument: RPConsentDocument(sections: [], title: '')),
    RPConsentDocument(title: '', sections: []),
    RPConsentSection(type: RPConsentSectionType.AboutUs, summary: ''),
    RPConsentSignature(identifier: ''),
  ]);

  // Tasks classes
  FromJsonFactory().registerAll([
    RPOrderedTask(identifier: '', steps: []),
    RPNavigableOrderedTask(identifier: '', steps: []),
    RPDataTypeSection(
      dataName: '',
      dataInformation: '',
    ),
  ]);

  // Navigation rule classes
  FromJsonFactory().registerAll([
    RPDirectStepNavigationRule(destinationStepIdentifier: ''),
    RPStepJumpRule(answerMap: {}),
    RPStepReorganizerRule(reorderingMap: {}),
  ]);

  // Result classes
  FromJsonFactory().registerAll([
    RPResult(identifier: ''),
    RPStepResult(
        identifier: '', questionTitle: '', answerFormat: RPAnswerFormat()),
    RPSignatureResult(),
    RPConsentSignatureResult(
        identifier: '',
        consentDocument: RPConsentDocument(title: '', sections: [])),
    RPActivityResult(identifier: ''),
    RPNoResult(identifier: ''),
    RPPermissionResult(identifier: ''),
    RPTaskResult(identifier: ''),
  ]);
}
