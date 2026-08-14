// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RPAnswerFormat _$RPAnswerFormatFromJson(Map<String, dynamic> json) =>
    RPAnswerFormat()
      ..$type = json['__type'] as String?
      ..questionType = $enumDecode(
        _$RPQuestionTypeEnumMap,
        json['questionType'],
      );

Map<String, dynamic> _$RPAnswerFormatToJson(RPAnswerFormat instance) =>
    <String, dynamic>{
      '__type': ?instance.$type,
      'questionType': _$RPQuestionTypeEnumMap[instance.questionType]!,
    };

const _$RPQuestionTypeEnumMap = {
  RPQuestionType.None: 'None',
  RPQuestionType.Scale: 'Scale',
  RPQuestionType.SingleChoice: 'SingleChoice',
  RPQuestionType.MultipleChoice: 'MultipleChoice',
  RPQuestionType.Decimal: 'Decimal',
  RPQuestionType.Integer: 'Integer',
  RPQuestionType.Boolean: 'Boolean',
  RPQuestionType.Text: 'Text',
  RPQuestionType.TimeOfDay: 'TimeOfDay',
  RPQuestionType.DateAndTime: 'DateAndTime',
  RPQuestionType.Date: 'Date',
  RPQuestionType.Duration: 'Duration',
  RPQuestionType.ImageChoice: 'ImageChoice',
  RPQuestionType.Double: 'Double',
  RPQuestionType.Form: 'Form',
};

RPIntegerAnswerFormat _$RPIntegerAnswerFormatFromJson(
  Map<String, dynamic> json,
) =>
    RPIntegerAnswerFormat(
        minValue: (json['minValue'] as num).toInt(),
        maxValue: (json['maxValue'] as num).toInt(),
        suffix: json['suffix'] as String?,
      )
      ..$type = json['__type'] as String?
      ..questionType = $enumDecode(
        _$RPQuestionTypeEnumMap,
        json['questionType'],
      );

Map<String, dynamic> _$RPIntegerAnswerFormatToJson(
  RPIntegerAnswerFormat instance,
) => <String, dynamic>{
  '__type': ?instance.$type,
  'minValue': instance.minValue,
  'maxValue': instance.maxValue,
  'suffix': ?instance.suffix,
  'questionType': _$RPQuestionTypeEnumMap[instance.questionType]!,
};

RPDoubleAnswerFormat _$RPDoubleAnswerFormatFromJson(
  Map<String, dynamic> json,
) =>
    RPDoubleAnswerFormat(
        minValue: (json['minValue'] as num).toDouble(),
        maxValue: (json['maxValue'] as num).toDouble(),
        suffix: json['suffix'] as String?,
      )
      ..$type = json['__type'] as String?
      ..questionType = $enumDecode(
        _$RPQuestionTypeEnumMap,
        json['questionType'],
      );

Map<String, dynamic> _$RPDoubleAnswerFormatToJson(
  RPDoubleAnswerFormat instance,
) => <String, dynamic>{
  '__type': ?instance.$type,
  'minValue': instance.minValue,
  'maxValue': instance.maxValue,
  'suffix': ?instance.suffix,
  'questionType': _$RPQuestionTypeEnumMap[instance.questionType]!,
};

RPChoiceAnswerFormat _$RPChoiceAnswerFormatFromJson(
  Map<String, dynamic> json,
) =>
    RPChoiceAnswerFormat(
        answerStyle: $enumDecode(
          _$RPChoiceAnswerStyleEnumMap,
          json['answerStyle'],
        ),
        choices: (json['choices'] as List<dynamic>)
            .map((e) => RPChoice.fromJson(e as Map<String, dynamic>))
            .toList(),
      )
      ..$type = json['__type'] as String?
      ..questionType = $enumDecode(
        _$RPQuestionTypeEnumMap,
        json['questionType'],
      );

Map<String, dynamic> _$RPChoiceAnswerFormatToJson(
  RPChoiceAnswerFormat instance,
) => <String, dynamic>{
  '__type': ?instance.$type,
  'questionType': _$RPQuestionTypeEnumMap[instance.questionType]!,
  'choices': instance.choices.map((e) => e.toJson()).toList(),
  'answerStyle': _$RPChoiceAnswerStyleEnumMap[instance.answerStyle]!,
};

const _$RPChoiceAnswerStyleEnumMap = {
  RPChoiceAnswerStyle.SingleChoice: 'SingleChoice',
  RPChoiceAnswerStyle.MultipleChoice: 'MultipleChoice',
};

RPChoice _$RPChoiceFromJson(Map<String, dynamic> json) => RPChoice(
  text: json['text'] as String,
  value: (json['value'] as num).toInt(),
  isFreeText: json['isFreeText'] as bool? ?? false,
  detailText: json['detailText'] as String?,
)..$type = json['__type'] as String?;

Map<String, dynamic> _$RPChoiceToJson(RPChoice instance) => <String, dynamic>{
  '__type': ?instance.$type,
  'text': instance.text,
  'value': instance.value,
  'detailText': ?instance.detailText,
  'isFreeText': instance.isFreeText,
};

RPFormAnswerFormat _$RPFormAnswerFormatFromJson(Map<String, dynamic> json) =>
    RPFormAnswerFormat()
      ..$type = json['__type'] as String?
      ..questionType = $enumDecode(
        _$RPQuestionTypeEnumMap,
        json['questionType'],
      );

Map<String, dynamic> _$RPFormAnswerFormatToJson(RPFormAnswerFormat instance) =>
    <String, dynamic>{
      '__type': ?instance.$type,
      'questionType': _$RPQuestionTypeEnumMap[instance.questionType]!,
    };

RPSliderAnswerFormat _$RPSliderAnswerFormatFromJson(
  Map<String, dynamic> json,
) =>
    RPSliderAnswerFormat(
        minValue: (json['minValue'] as num).toDouble(),
        maxValue: (json['maxValue'] as num).toDouble(),
        divisions: (json['divisions'] as num).toInt(),
        prefix: json['prefix'] as String? ?? '',
        suffix: json['suffix'] as String? ?? '',
      )
      ..$type = json['__type'] as String?
      ..questionType = $enumDecode(
        _$RPQuestionTypeEnumMap,
        json['questionType'],
      );

Map<String, dynamic> _$RPSliderAnswerFormatToJson(
  RPSliderAnswerFormat instance,
) => <String, dynamic>{
  '__type': ?instance.$type,
  'minValue': instance.minValue,
  'maxValue': instance.maxValue,
  'divisions': instance.divisions,
  'prefix': ?instance.prefix,
  'suffix': ?instance.suffix,
  'questionType': _$RPQuestionTypeEnumMap[instance.questionType]!,
};

RPImageChoiceAnswerFormat _$RPImageChoiceAnswerFormatFromJson(
  Map<String, dynamic> json,
) =>
    RPImageChoiceAnswerFormat(
        choices: (json['choices'] as List<dynamic>)
            .map((e) => RPImageChoice.fromJson(e as Map<String, dynamic>))
            .toList(),
      )
      ..$type = json['__type'] as String?
      ..questionType = $enumDecode(
        _$RPQuestionTypeEnumMap,
        json['questionType'],
      );

Map<String, dynamic> _$RPImageChoiceAnswerFormatToJson(
  RPImageChoiceAnswerFormat instance,
) => <String, dynamic>{
  '__type': ?instance.$type,
  'choices': instance.choices.map((e) => e.toJson()).toList(),
  'questionType': _$RPQuestionTypeEnumMap[instance.questionType]!,
};

RPImageChoice _$RPImageChoiceFromJson(Map<String, dynamic> json) =>
    RPImageChoice(
      imageUrl: json['imageUrl'] as String,
      key: json['key'] as String?,
      value: json['value'],
      description: json['description'] as String,
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$RPImageChoiceToJson(RPImageChoice instance) =>
    <String, dynamic>{
      '__type': ?instance.$type,
      'imageUrl': instance.imageUrl,
      'key': ?instance.key,
      'value': ?instance.value,
      'description': instance.description,
    };

RPDateTimeAnswerFormat _$RPDateTimeAnswerFormatFromJson(
  Map<String, dynamic> json,
) =>
    RPDateTimeAnswerFormat(
        dateTimeAnswerStyle: $enumDecode(
          _$RPDateTimeAnswerStyleEnumMap,
          json['dateTimeAnswerStyle'],
        ),
      )
      ..$type = json['__type'] as String?
      ..questionType = $enumDecode(
        _$RPQuestionTypeEnumMap,
        json['questionType'],
      );

Map<String, dynamic> _$RPDateTimeAnswerFormatToJson(
  RPDateTimeAnswerFormat instance,
) => <String, dynamic>{
  '__type': ?instance.$type,
  'questionType': _$RPQuestionTypeEnumMap[instance.questionType]!,
  'dateTimeAnswerStyle':
      _$RPDateTimeAnswerStyleEnumMap[instance.dateTimeAnswerStyle]!,
};

const _$RPDateTimeAnswerStyleEnumMap = {
  RPDateTimeAnswerStyle.DateAndTime: 'DateAndTime',
  RPDateTimeAnswerStyle.Date: 'Date',
  RPDateTimeAnswerStyle.TimeOfDay: 'TimeOfDay',
};

RPTextAnswerFormat _$RPTextAnswerFormatFromJson(Map<String, dynamic> json) =>
    RPTextAnswerFormat(
        hintText: json['hintText'] as String?,
        autoFocus: json['autoFocus'] as bool? ?? false,
        disableHelpers: json['disableHelpers'] as bool? ?? false,
      )
      ..$type = json['__type'] as String?
      ..questionType = $enumDecode(
        _$RPQuestionTypeEnumMap,
        json['questionType'],
      );

Map<String, dynamic> _$RPTextAnswerFormatToJson(RPTextAnswerFormat instance) =>
    <String, dynamic>{
      '__type': ?instance.$type,
      'hintText': ?instance.hintText,
      'autoFocus': instance.autoFocus,
      'disableHelpers': instance.disableHelpers,
      'questionType': _$RPQuestionTypeEnumMap[instance.questionType]!,
    };

RPConsentDocument _$RPConsentDocumentFromJson(Map<String, dynamic> json) =>
    RPConsentDocument(
        title: json['title'] as String,
        sections: (json['sections'] as List<dynamic>)
            .map((e) => RPConsentSection.fromJson(e as Map<String, dynamic>))
            .toList(),
      )
      ..$type = json['__type'] as String?
      ..signatures = (json['signatures'] as List<dynamic>)
          .map((e) => RPConsentSignature.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$RPConsentDocumentToJson(RPConsentDocument instance) =>
    <String, dynamic>{
      '__type': ?instance.$type,
      'signatures': instance.signatures.map((e) => e.toJson()).toList(),
      'title': instance.title,
      'sections': instance.sections.map((e) => e.toJson()).toList(),
    };

RPConsentSection _$RPConsentSectionFromJson(Map<String, dynamic> json) =>
    RPConsentSection(
      type: $enumDecode(_$RPConsentSectionTypeEnumMap, json['type']),
      title: json['title'] as String?,
      summary: json['summary'] as String,
      content: json['content'] as String?,
      dataTypes: (json['dataTypes'] as List<dynamic>?)
          ?.map((e) => RPDataTypeSection.fromJson(e as Map<String, dynamic>))
          .toList(),
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$RPConsentSectionToJson(RPConsentSection instance) =>
    <String, dynamic>{
      '__type': ?instance.$type,
      'type': _$RPConsentSectionTypeEnumMap[instance.type]!,
      'title': instance.title,
      'summary': instance.summary,
      'content': ?instance.content,
      'dataTypes': ?instance.dataTypes?.map((e) => e.toJson()).toList(),
    };

const _$RPConsentSectionTypeEnumMap = {
  RPConsentSectionType.Overview: 'Overview',
  RPConsentSectionType.DataGathering: 'DataGathering',
  RPConsentSectionType.Privacy: 'Privacy',
  RPConsentSectionType.DataUse: 'DataUse',
  RPConsentSectionType.TimeCommitment: 'TimeCommitment',
  RPConsentSectionType.Duration: 'Duration',
  RPConsentSectionType.StudyTasks: 'StudyTasks',
  RPConsentSectionType.StudySurvey: 'StudySurvey',
  RPConsentSectionType.Withdrawing: 'Withdrawing',
  RPConsentSectionType.YourRights: 'YourRights',
  RPConsentSectionType.Welcome: 'Welcome',
  RPConsentSectionType.AboutUs: 'AboutUs',
  RPConsentSectionType.Goals: 'Goals',
  RPConsentSectionType.Benefits: 'Benefits',
  RPConsentSectionType.DataHandling: 'DataHandling',
  RPConsentSectionType.Location: 'Location',
  RPConsentSectionType.Health: 'Health',
  RPConsentSectionType.HealthDataCollection: 'HealthDataCollection',
  RPConsentSectionType.UserDataCollection: 'UserDataCollection',
  RPConsentSectionType.PassiveDataCollection: 'PassiveDataCollection',
  RPConsentSectionType.Custom: 'Custom',
};

RPConsentSignature _$RPConsentSignatureFromJson(Map<String, dynamic> json) =>
    RPConsentSignature(
      identifier: json['identifier'] as String,
      title: json['title'] as String?,
      requiresName: json['requiresName'] as bool? ?? true,
      requiresSignatureImage: json['requiresSignatureImage'] as bool? ?? true,
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$RPConsentSignatureToJson(RPConsentSignature instance) =>
    <String, dynamic>{
      '__type': ?instance.$type,
      'identifier': instance.identifier,
      'title': ?instance.title,
      'requiresName': instance.requiresName,
      'requiresSignatureImage': instance.requiresSignatureImage,
    };

RPVisualConsentStep _$RPVisualConsentStepFromJson(Map<String, dynamic> json) =>
    RPVisualConsentStep(
        identifier: json['identifier'] as String,
        consentDocument: RPConsentDocument.fromJson(
          json['consentDocument'] as Map<String, dynamic>,
        ),
      )
      ..$type = json['__type'] as String?
      ..title = json['title'] as String
      ..text = json['text'] as String?
      ..optional = json['optional'] as bool
      ..footnote = json['footnote'] as String?
      ..nextButtonText = json['nextButtonText'] as String?;

Map<String, dynamic> _$RPVisualConsentStepToJson(
  RPVisualConsentStep instance,
) => <String, dynamic>{
  '__type': ?instance.$type,
  'identifier': instance.identifier,
  'title': instance.title,
  'text': ?instance.text,
  'optional': instance.optional,
  'footnote': ?instance.footnote,
  'nextButtonText': ?instance.nextButtonText,
  'consentDocument': instance.consentDocument.toJson(),
};

RPConsentReviewStep _$RPConsentReviewStepFromJson(Map<String, dynamic> json) =>
    RPConsentReviewStep(
        identifier: json['identifier'] as String,
        title: json['title'] as String,
        text: json['text'] as String?,
        consentDocument: RPConsentDocument.fromJson(
          json['consentDocument'] as Map<String, dynamic>,
        ),
        reasonForConsent: json['reasonForConsent'] as String?,
      )
      ..$type = json['__type'] as String?
      ..optional = json['optional'] as bool
      ..footnote = json['footnote'] as String?
      ..nextButtonText = json['nextButtonText'] as String?;

Map<String, dynamic> _$RPConsentReviewStepToJson(
  RPConsentReviewStep instance,
) => <String, dynamic>{
  '__type': ?instance.$type,
  'identifier': instance.identifier,
  'title': instance.title,
  'text': ?instance.text,
  'optional': instance.optional,
  'footnote': ?instance.footnote,
  'nextButtonText': ?instance.nextButtonText,
  'consentDocument': instance.consentDocument.toJson(),
  'reasonForConsent': ?instance.reasonForConsent,
};

RPDataTypeSection _$RPDataTypeSectionFromJson(Map<String, dynamic> json) =>
    RPDataTypeSection(
      dataName: json['dataName'] as String,
      dataInformation: json['dataInformation'] as String,
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$RPDataTypeSectionToJson(RPDataTypeSection instance) =>
    <String, dynamic>{
      '__type': ?instance.$type,
      'dataName': instance.dataName,
      'dataInformation': instance.dataInformation,
    };

RPStep _$RPStepFromJson(Map<String, dynamic> json) => RPStep(
  identifier: json['identifier'] as String,
  title: json['title'] as String,
  text: json['text'] as String?,
  optional: json['optional'] as bool? ?? false,
  footnote: json['footnote'] as String?,
  nextButtonText: json['nextButtonText'] as String?,
)..$type = json['__type'] as String?;

Map<String, dynamic> _$RPStepToJson(RPStep instance) => <String, dynamic>{
  '__type': ?instance.$type,
  'identifier': instance.identifier,
  'title': instance.title,
  'text': ?instance.text,
  'optional': instance.optional,
  'footnote': ?instance.footnote,
  'nextButtonText': ?instance.nextButtonText,
};

RPFormStep _$RPFormStepFromJson(Map<String, dynamic> json) =>
    RPFormStep(
        identifier: json['identifier'] as String,
        title: json['title'] as String,
        optional: json['optional'] as bool? ?? false,
        autoSkip: json['autoSkip'] as bool? ?? false,
        timeout: json['timeout'] == null
            ? const Duration(seconds: 0)
            : Duration(microseconds: (json['timeout'] as num).toInt()),
        questions: (json['questions'] as List<dynamic>)
            .map((e) => RPQuestionStep.fromJson(e as Map<String, dynamic>))
            .toList(),
        saveResultsOnAutoSkip: json['saveResultsOnAutoSkip'] as bool? ?? false,
        forceWait: json['forceWait'] as bool? ?? false,
        footnote: json['footnote'] as String?,
      )
      ..$type = json['__type'] as String?
      ..text = json['text'] as String?
      ..nextButtonText = json['nextButtonText'] as String?
      ..answerFormat = RPAnswerFormat.fromJson(
        json['answerFormat'] as Map<String, dynamic>,
      )
      ..placeholder = json['placeholder'] as String?
      ..autoFocus = json['autoFocus'] as bool;

Map<String, dynamic> _$RPFormStepToJson(RPFormStep instance) =>
    <String, dynamic>{
      '__type': ?instance.$type,
      'identifier': instance.identifier,
      'title': instance.title,
      'text': ?instance.text,
      'optional': instance.optional,
      'footnote': ?instance.footnote,
      'nextButtonText': ?instance.nextButtonText,
      'answerFormat': instance.answerFormat.toJson(),
      'placeholder': ?instance.placeholder,
      'autoSkip': instance.autoSkip,
      'timeout': instance.timeout.inMicroseconds,
      'autoFocus': instance.autoFocus,
      'questions': instance.questions.map((e) => e.toJson()).toList(),
      'saveResultsOnAutoSkip': instance.saveResultsOnAutoSkip,
      'forceWait': instance.forceWait,
    };

RPQuestionStep _$RPQuestionStepFromJson(Map<String, dynamic> json) =>
    RPQuestionStep(
        identifier: json['identifier'] as String,
        title: json['title'] as String,
        optional: json['optional'] as bool? ?? false,
        answerFormat: RPAnswerFormat.fromJson(
          json['answerFormat'] as Map<String, dynamic>,
        ),
        autoSkip: json['autoSkip'] as bool? ?? false,
        timeout: json['timeout'] == null
            ? const Duration(seconds: 0)
            : Duration(microseconds: (json['timeout'] as num).toInt()),
        autoFocus: json['autoFocus'] as bool? ?? false,
        footnote: json['footnote'] as String?,
      )
      ..$type = json['__type'] as String?
      ..text = json['text'] as String?
      ..nextButtonText = json['nextButtonText'] as String?
      ..placeholder = json['placeholder'] as String?;

Map<String, dynamic> _$RPQuestionStepToJson(RPQuestionStep instance) =>
    <String, dynamic>{
      '__type': ?instance.$type,
      'identifier': instance.identifier,
      'title': instance.title,
      'text': ?instance.text,
      'optional': instance.optional,
      'footnote': ?instance.footnote,
      'nextButtonText': ?instance.nextButtonText,
      'answerFormat': instance.answerFormat.toJson(),
      'placeholder': ?instance.placeholder,
      'autoSkip': instance.autoSkip,
      'timeout': instance.timeout.inMicroseconds,
      'autoFocus': instance.autoFocus,
    };

RPInstructionStep _$RPInstructionStepFromJson(Map<String, dynamic> json) =>
    RPInstructionStep(
        identifier: json['identifier'] as String,
        title: json['title'] as String,
        text: json['text'] as String?,
        optional: json['optional'] as bool? ?? false,
        detailText: json['detailText'] as String?,
        imagePath: json['imagePath'] as String?,
        audioPath: json['audioPath'] as String?,
        videoPath: json['videoPath'] as String?,
        footnote: json['footnote'] as String?,
      )
      ..$type = json['__type'] as String?
      ..nextButtonText = json['nextButtonText'] as String?;

Map<String, dynamic> _$RPInstructionStepToJson(RPInstructionStep instance) =>
    <String, dynamic>{
      '__type': ?instance.$type,
      'identifier': instance.identifier,
      'title': instance.title,
      'text': ?instance.text,
      'optional': instance.optional,
      'footnote': ?instance.footnote,
      'nextButtonText': ?instance.nextButtonText,
      'detailText': ?instance.detailText,
      'imagePath': ?instance.imagePath,
      'audioPath': ?instance.audioPath,
      'videoPath': ?instance.videoPath,
    };

RPCompletionStep _$RPCompletionStepFromJson(Map<String, dynamic> json) =>
    RPCompletionStep(
        identifier: json['identifier'] as String,
        title: json['title'] as String,
        text: json['text'] as String?,
        optional: json['optional'] as bool? ?? false,
      )
      ..$type = json['__type'] as String?
      ..footnote = json['footnote'] as String?
      ..nextButtonText = json['nextButtonText'] as String?;

Map<String, dynamic> _$RPCompletionStepToJson(RPCompletionStep instance) =>
    <String, dynamic>{
      '__type': ?instance.$type,
      'identifier': instance.identifier,
      'title': instance.title,
      'text': ?instance.text,
      'optional': instance.optional,
      'footnote': ?instance.footnote,
      'nextButtonText': ?instance.nextButtonText,
    };

RPActivityStep _$RPActivityStepFromJson(Map<String, dynamic> json) =>
    RPActivityStep(
        identifier: json['identifier'] as String,
        includeInstructions: json['includeInstructions'] as bool? ?? true,
        includeResults: json['includeResults'] as bool? ?? true,
      )
      ..$type = json['__type'] as String?
      ..title = json['title'] as String
      ..text = json['text'] as String?
      ..optional = json['optional'] as bool
      ..footnote = json['footnote'] as String?
      ..nextButtonText = json['nextButtonText'] as String?;

Map<String, dynamic> _$RPActivityStepToJson(RPActivityStep instance) =>
    <String, dynamic>{
      '__type': ?instance.$type,
      'identifier': instance.identifier,
      'title': instance.title,
      'text': ?instance.text,
      'optional': instance.optional,
      'footnote': ?instance.footnote,
      'nextButtonText': ?instance.nextButtonText,
      'includeInstructions': instance.includeInstructions,
      'includeResults': instance.includeResults,
    };

RPTimerStep _$RPTimerStepFromJson(Map<String, dynamic> json) =>
    RPTimerStep(
        identifier: json['identifier'] as String,
        title: json['title'] as String,
        optional: json['optional'] as bool? ?? false,
        timeout: Duration(microseconds: (json['timeout'] as num).toInt()),
        playSound: json['playSound'] as bool? ?? false,
        autoSkip: json['autoSkip'] as bool? ?? false,
        showTime: json['showTime'] as bool? ?? true,
        footnote: json['footnote'] as String?,
      )
      ..$type = json['__type'] as String?
      ..text = json['text'] as String?
      ..nextButtonText = json['nextButtonText'] as String?;

Map<String, dynamic> _$RPTimerStepToJson(RPTimerStep instance) =>
    <String, dynamic>{
      '__type': ?instance.$type,
      'identifier': instance.identifier,
      'title': instance.title,
      'text': ?instance.text,
      'optional': instance.optional,
      'footnote': ?instance.footnote,
      'nextButtonText': ?instance.nextButtonText,
      'timeout': instance.timeout.inMicroseconds,
      'playSound': instance.playSound,
      'autoSkip': instance.autoSkip,
      'showTime': instance.showTime,
    };

RPOrderedTask _$RPOrderedTaskFromJson(Map<String, dynamic> json) =>
    RPOrderedTask(
      identifier: json['identifier'] as String,
      closeAfterFinished: json['closeAfterFinished'] as bool? ?? true,
      steps: (json['steps'] as List<dynamic>)
          .map((e) => RPStep.fromJson(e as Map<String, dynamic>))
          .toList(),
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$RPOrderedTaskToJson(RPOrderedTask instance) =>
    <String, dynamic>{
      '__type': ?instance.$type,
      'identifier': instance.identifier,
      'closeAfterFinished': instance.closeAfterFinished,
      'steps': instance.steps.map((e) => e.toJson()).toList(),
    };

RPNavigableOrderedTask _$RPNavigableOrderedTaskFromJson(
  Map<String, dynamic> json,
) =>
    RPNavigableOrderedTask(
        identifier: json['identifier'] as String,
        steps: (json['steps'] as List<dynamic>)
            .map((e) => RPStep.fromJson(e as Map<String, dynamic>))
            .toList(),
        closeAfterFinished: json['closeAfterFinished'] as bool? ?? true,
      )
      ..$type = json['__type'] as String?
      ..stepNavigationRules =
          (json['stepNavigationRules'] as Map<String, dynamic>).map(
            (k, e) => MapEntry(
              k,
              RPStepNavigationRule.fromJson(e as Map<String, dynamic>),
            ),
          );

Map<String, dynamic> _$RPNavigableOrderedTaskToJson(
  RPNavigableOrderedTask instance,
) => <String, dynamic>{
  '__type': ?instance.$type,
  'identifier': instance.identifier,
  'closeAfterFinished': instance.closeAfterFinished,
  'steps': instance.steps.map((e) => e.toJson()).toList(),
  'stepNavigationRules': instance.stepNavigationRules.map(
    (k, e) => MapEntry(k, e.toJson()),
  ),
};

RPStepNavigationRule _$RPStepNavigationRuleFromJson(
  Map<String, dynamic> json,
) => RPStepNavigationRule()..$type = json['__type'] as String?;

Map<String, dynamic> _$RPStepNavigationRuleToJson(
  RPStepNavigationRule instance,
) => <String, dynamic>{'__type': ?instance.$type};

RPDirectStepNavigationRule _$RPDirectStepNavigationRuleFromJson(
  Map<String, dynamic> json,
) => RPDirectStepNavigationRule(
  destinationStepIdentifier: json['destinationStepIdentifier'] as String,
)..$type = json['__type'] as String?;

Map<String, dynamic> _$RPDirectStepNavigationRuleToJson(
  RPDirectStepNavigationRule instance,
) => <String, dynamic>{
  '__type': ?instance.$type,
  'destinationStepIdentifier': instance.destinationStepIdentifier,
};

RPStepReorganizerRule _$RPStepReorganizerRuleFromJson(
  Map<String, dynamic> json,
) => RPStepReorganizerRule(
  reorderingMap: (json['reorderingMap'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(int.parse(k), e as String),
  ),
)..$type = json['__type'] as String?;

Map<String, dynamic> _$RPStepReorganizerRuleToJson(
  RPStepReorganizerRule instance,
) => <String, dynamic>{
  '__type': ?instance.$type,
  'reorderingMap': instance.reorderingMap.map(
    (k, e) => MapEntry(k.toString(), e),
  ),
};

RPStepJumpRule _$RPStepJumpRuleFromJson(Map<String, dynamic> json) =>
    RPStepJumpRule(
      answerMap: (json['answerMap'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(int.parse(k), e as String),
      ),
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$RPStepJumpRuleToJson(RPStepJumpRule instance) =>
    <String, dynamic>{
      '__type': ?instance.$type,
      'answerMap': instance.answerMap.map((k, e) => MapEntry(k.toString(), e)),
    };

RPTask _$RPTaskFromJson(Map<String, dynamic> json) => RPTask(
  identifier: json['identifier'] as String,
  closeAfterFinished: json['closeAfterFinished'] as bool? ?? false,
)..$type = json['__type'] as String?;

Map<String, dynamic> _$RPTaskToJson(RPTask instance) => <String, dynamic>{
  '__type': ?instance.$type,
  'identifier': instance.identifier,
  'closeAfterFinished': instance.closeAfterFinished,
};

RPResult _$RPResultFromJson(Map<String, dynamic> json) =>
    RPResult(identifier: json['identifier'] as String)
      ..$type = json['__type'] as String?
      ..startDate = json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String)
      ..endDate = json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String);

Map<String, dynamic> _$RPResultToJson(RPResult instance) => <String, dynamic>{
  '__type': ?instance.$type,
  'identifier': instance.identifier,
  'startDate': ?instance.startDate?.toIso8601String(),
  'endDate': ?instance.endDate?.toIso8601String(),
};

RPTaskResult _$RPTaskResultFromJson(Map<String, dynamic> json) =>
    RPTaskResult(identifier: json['identifier'] as String)
      ..$type = json['__type'] as String?
      ..startDate = json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String)
      ..endDate = json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String)
      ..results = (json['results'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, RPResult.fromJson(e as Map<String, dynamic>)),
      );

Map<String, dynamic> _$RPTaskResultToJson(RPTaskResult instance) =>
    <String, dynamic>{
      '__type': ?instance.$type,
      'identifier': instance.identifier,
      'startDate': ?instance.startDate?.toIso8601String(),
      'endDate': ?instance.endDate?.toIso8601String(),
      'results': instance.results.map((k, e) => MapEntry(k, e.toJson())),
    };

RPStepResult _$RPStepResultFromJson(Map<String, dynamic> json) =>
    RPStepResult(
        identifier: json['identifier'] as String,
        questionTitle: json['questionTitle'] as String,
        answerFormat: RPAnswerFormat.fromJson(
          json['answerFormat'] as Map<String, dynamic>,
        ),
      )
      ..$type = json['__type'] as String?
      ..startDate = json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String)
      ..endDate = json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String)
      ..results = json['results'] as Map<String, dynamic>;

Map<String, dynamic> _$RPStepResultToJson(RPStepResult instance) =>
    <String, dynamic>{
      '__type': ?instance.$type,
      'identifier': instance.identifier,
      'startDate': ?instance.startDate?.toIso8601String(),
      'endDate': ?instance.endDate?.toIso8601String(),
      'questionTitle': instance.questionTitle,
      'results': instance.results,
      'answerFormat': instance.answerFormat.toJson(),
    };

RPConsentSignatureResult _$RPConsentSignatureResultFromJson(
  Map<String, dynamic> json,
) =>
    RPConsentSignatureResult(
        identifier: json['identifier'] as String,
        consentDocument: RPConsentDocument.fromJson(
          json['consentDocument'] as Map<String, dynamic>,
        ),
        signature: json['signature'] == null
            ? null
            : RPSignatureResult.fromJson(
                json['signature'] as Map<String, dynamic>,
              ),
      )
      ..$type = json['__type'] as String?
      ..startDate = json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String)
      ..endDate = json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String)
      ..userId = json['userId'] as String?;

Map<String, dynamic> _$RPConsentSignatureResultToJson(
  RPConsentSignatureResult instance,
) => <String, dynamic>{
  '__type': ?instance.$type,
  'identifier': instance.identifier,
  'startDate': ?instance.startDate?.toIso8601String(),
  'endDate': ?instance.endDate?.toIso8601String(),
  'consentDocument': instance.consentDocument.toJson(),
  'signature': ?instance.signature?.toJson(),
  'userId': ?instance.userId,
};

RPSignatureResult _$RPSignatureResultFromJson(Map<String, dynamic> json) =>
    RPSignatureResult(
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      signatureImage: json['signatureImage'] as String?,
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$RPSignatureResultToJson(RPSignatureResult instance) =>
    <String, dynamic>{
      '__type': ?instance.$type,
      'firstName': ?instance.firstName,
      'lastName': ?instance.lastName,
      'signatureImage': ?instance.signatureImage,
    };

RPNoResult _$RPNoResultFromJson(Map<String, dynamic> json) =>
    RPNoResult(identifier: json['identifier'] as String)
      ..$type = json['__type'] as String?
      ..startDate = json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String)
      ..endDate = json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String);

Map<String, dynamic> _$RPNoResultToJson(RPNoResult instance) =>
    <String, dynamic>{
      '__type': ?instance.$type,
      'identifier': instance.identifier,
      'startDate': ?instance.startDate?.toIso8601String(),
      'endDate': ?instance.endDate?.toIso8601String(),
    };

RPActivityResult _$RPActivityResultFromJson(Map<String, dynamic> json) =>
    RPActivityResult(identifier: json['identifier'] as String)
      ..$type = json['__type'] as String?
      ..startDate = json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String)
      ..endDate = json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String)
      ..results = json['results'] as Map<String, dynamic>
      ..stepTimes = StepTimes.fromJson(
        json['stepTimes'] as Map<String, dynamic>,
      )
      ..interactions = (json['interactions'] as List<dynamic>)
          .map((e) => Interaction.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$RPActivityResultToJson(RPActivityResult instance) =>
    <String, dynamic>{
      '__type': ?instance.$type,
      'identifier': instance.identifier,
      'startDate': ?instance.startDate?.toIso8601String(),
      'endDate': ?instance.endDate?.toIso8601String(),
      'results': instance.results,
      'stepTimes': instance.stepTimes.toJson(),
      'interactions': instance.interactions.map((e) => e.toJson()).toList(),
    };

Interaction _$InteractionFromJson(Map<String, dynamic> json) => Interaction(
  DateTime.parse(json['time'] as String),
  json['correctness'] as String,
  json['type'] as String,
  json['description'] as String,
);

Map<String, dynamic> _$InteractionToJson(Interaction instance) =>
    <String, dynamic>{
      'time': instance.time.toIso8601String(),
      'correctness': instance.correctness,
      'type': instance.type,
      'description': instance.description,
    };

StepTimes _$StepTimesFromJson(Map<String, dynamic> json) => StepTimes()
  ..instructionStarted = json['instruction_started'] == null
      ? null
      : DateTime.parse(json['instruction_started'] as String)
  ..instructionEnded = json['instruction_ended'] == null
      ? null
      : DateTime.parse(json['instruction_ended'] as String)
  ..testShown = json['test_shown'] == null
      ? null
      : DateTime.parse(json['test_shown'] as String)
  ..testStarted = json['test_started'] == null
      ? null
      : DateTime.parse(json['test_started'] as String)
  ..testEnded = json['test_ended'] == null
      ? null
      : DateTime.parse(json['test_ended'] as String)
  ..resultsShown = json['results_shown'] == null
      ? null
      : DateTime.parse(json['results_shown'] as String)
  ..resultsClosed = json['results_closed'] == null
      ? null
      : DateTime.parse(json['results_closed'] as String);

Map<String, dynamic> _$StepTimesToJson(StepTimes instance) => <String, dynamic>{
  'instruction_started': ?instance.instructionStarted?.toIso8601String(),
  'instruction_ended': ?instance.instructionEnded?.toIso8601String(),
  'test_shown': ?instance.testShown?.toIso8601String(),
  'test_started': ?instance.testStarted?.toIso8601String(),
  'test_ended': ?instance.testEnded?.toIso8601String(),
  'results_shown': ?instance.resultsShown?.toIso8601String(),
  'results_closed': ?instance.resultsClosed?.toIso8601String(),
};
