/// The domain model part of Research Package.
///
/// Contains the "building blocks" for creating surveys and obtaining informed consents.
/// Holds the different types of result classes.
/// Also responsible for the streams and BLoC classes to provide communication channels
/// between different parts of the package. ([BlocQuestion], [BlocTask])
/// For the UI representations of the classes visit the [research_package_ui] library.
library;

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:carp_serializable/carp_serializable.dart';
// `show`n, to keep the ~100 other names it exports out of the namespace shared
// by every part file of this library.
import 'package:health/health.dart' show HealthDataType;
import 'package:research_package/ui.dart';

// JSON
part 'model.g.dart';
part 'model.json.dart';

// Library elements
part 'src/model/answerformat/answer_format.dart';
part 'src/model/answerformat/integer_answer_format.dart';
part 'src/model/answerformat/double_answer_format.dart';
part 'src/model/answerformat/choice_answer_format.dart';
part 'src/model/answerformat/form_answer_format.dart';
part 'src/model/answerformat/slider_answer_format.dart';
part 'src/model/answerformat/image_choice_answer_format.dart';
part 'src/model/answerformat/date_time_answer_format.dart';
part 'src/model/answerformat/text_answer_format.dart';

part 'src/model/consent/consent_document.dart';
part 'src/model/consent/consent_section.dart';
part 'src/model/consent/consent_signature.dart';
part 'src/model/consent/visual_consent_step.dart';
part 'src/model/consent/consent_review_step.dart';
part 'src/model/consent/data_type_section.dart';

part 'src/model/permission/permission_type.dart';
part 'src/model/permission/permission_result.dart';

part 'src/model/step/step.dart';
part 'src/model/step/form_step.dart';
part 'src/model/step/question_step.dart';
part 'src/model/step/instruction_step.dart';
part 'src/model/step/completion_step.dart';
part 'src/model/step/activity_step.dart';
part 'src/model/step/timer_step.dart';

part 'src/model/task/ordered_task.dart';
part 'src/model/task/navigable_ordered_task.dart';
part 'src/model/task/step_navigation_rule.dart';
part 'src/model/task/direct_step_navigation_rule.dart';
part 'src/model/task/step_reorganizer_rule.dart';
part 'src/model/task/step_jump_rule.dart';
part 'src/model/task/task.dart';

part 'src/model/result/result.dart';
part 'src/model/result/task_result.dart';
part 'src/model/result/step_result.dart';
part 'src/model/result/consent_signature_result.dart';
part 'src/model/result/signature_result.dart';
part 'src/model/result/no_result.dart';
part 'src/model/result/activity_result.dart';

// BLoCs
part 'src/model/blocs/bloc_task.dart';
part 'src/model/blocs/bloc_question.dart';

/// A protocol to mark the Widgets which are producing [RPResult] objects.
/// They all need to implement the [createAndSendResult] method
abstract mixin class CanSaveResult {
  /// This method should be implemented in all the Widgets which are producing
  /// an [RPResult] object.
  void createAndSendResult();
}
