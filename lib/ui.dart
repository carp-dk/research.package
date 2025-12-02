/// The UI library of Research Package.
///
/// Normally you don't need to use these widgets directly. After creating the model objects from [research_package_model]
/// and adding them to an [RPTask] you can present the different elements by passing it to an [RPUITask].
///
/// This library contains various UI representations (Widgets) of the objects declared in [research_package_model].
/// Many of these Widgets are responsible for making the collected results accessible to others.
/// Also contains general styles, UI statics used in Research Package UI in [RPStyles].

library;

import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:signature/signature.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:video_player/video_player.dart';
import 'package:carp_themes_package/carp_themes_package.dart';

import 'model.dart';

// Library elements
part 'src/localization/localizations.dart';
part 'src/localization/assets_localization.dart';
part 'src/loggers/activity_event_logger.dart';
part 'src/ui/questions/choice_question_body.dart';
part 'src/ui/questions/date_time_question_body.dart';
part 'src/ui/questions/image_choice_question_body.dart';
part 'src/ui/questions/integer_question_body.dart';
part 'src/ui/questions/double_question_body.dart';
part 'src/ui/questions/slider_question_body.dart';
part 'src/ui/questions/text_input_question_body.dart';
part 'src/ui/completion_step.dart';
part 'src/ui/consent_review_step.dart';
part 'src/ui/form_step.dart';
part 'src/ui/instruction_step.dart';
part 'src/ui/instruction_step.audio_instruction.dart';
part 'src/ui/instruction_step.image_instruction.dart';
part 'src/ui/instruction_step.video_instruction.dart';
part 'src/ui/question_step.dart';
part 'src/ui/task.dart';
part 'src/ui/visual_consent_step.dart';
part 'src/ui/activity_step.dart';
part 'src/ui/timer_step.dart';
