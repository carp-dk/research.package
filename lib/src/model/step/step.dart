part of '../../../model.dart';

/// The base class for steps which can compose a task.
///
/// Each [RPStep] object represents one logical piece of data entry or activity
/// in a larger task.
/// Whether your app is giving instructions, presenting a form or survey,
/// obtaining consent, or running an active task, everything in the Research
/// Package framework is a collection of steps ([RPStep] objects), which together
/// form a task (an [RPTask] object)
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class RPStep extends Serializable {
  /// A unique identifier of the Step. This identifier connects the step to its
  /// result ([RPResult]) object.
  final String identifier;

  /// The title text. Different types of Steps are using the [title] text differently.
  ///
  /// For e.g. the [title] of [RPCompletionStep] is rendered in the middle of
  /// the screen while the [title] of an [RPQuestionStep] is the text of the
  /// actual question.
  String title;

  /// The text of the Step. Different types of Steps are using the [text] text
  /// differently.
  ///
  /// For e.g. the [text] of [RPCompletionStep] is rendered in the middle of
  /// the screen while the [RPQuestionStep] does not even use it.
  String? text;

  /// Can this step be skipped? If so, the result for the step will be `null`.
  bool optional;

  @JsonKey(includeFromJson: false, includeToJson: false)
  Timer? timer;

  /// Optional footer text to be displayed below the question.
  /// This can be used to provide additional information, such as copyright, or instructions.
  /// This text will be displayed in a smaller font size.
  String? footnote;

  /// Text for the button that advances past this step.
  ///
  /// May be a localization key or a literal — anything the localizations do
  /// not recognise is shown as-is.
  ///
  /// When `null` the task-wide `RPUITask.nextButtonText` is used, which in turn
  /// falls back to the localized `'NEXT'` key. Set this for steps whose forward
  /// action reads better as something specific, e.g. "Start Practicing".
  String? nextButtonText;

  /// Create a [RPStep] object with a unique [identifier], a [title], and
  /// a [text] to be displayed.
  RPStep({
    required this.identifier,
    required this.title,
    this.text,
    this.optional = false,
    this.footnote,
    this.nextButtonText,
  });

  /// The widget (UI representation) of the step.
  ///
  /// [RPQuestionStep]s don't have it because their UI representation depends
  /// on the Answer Format.
  /// Their Answer Format is assessed by [RPUIQuestionStep] or [RPUIFormStep] and
  /// they return the corresponding UI.
  ///
  /// When needed, it should be overridden to fit the different types of Steps.
  Widget? get stepWidget => null;

  @override
  Function get fromJsonFunction => _$RPStepFromJson;
  factory RPStep.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson<RPStep>(json);
  @override
  Map<String, dynamic> toJson() => _$RPStepToJson(this);
}

/// Status of a [RPStep].
/// Used in the Bloc so the Task Widget is notified about step navigation.
enum RPStepStatus { Finished, Skipped, Canceled, Ongoing, Back }
