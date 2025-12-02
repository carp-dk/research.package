part of '../../../model.dart';

/// A step which can be used to show instructions and other information
/// to the participant.
/// Usually it is used as the first step in a Task explaining the task.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class RPInstructionStep extends RPStep {
  /// The text which is shown in a new window by pressing the "Learn more" button.
  /// If `null`, no "Learn more" button is shown.
  String? detailText;

  /// The path of the image to show during the Instruction Step
  /// (e.g.: "assets/picture.png").
  ///
  /// Remember to add images to use as an asset to your `pubspec.yaml` file.
  ///
  /// If `null` nothing is shown.
  String? imagePath;

  /// The path of the audio to play after the Instruction Step is finished.
  ///
  /// Remember to add audio to use as an asset to your `pubspec.yaml` file.
  ///
  /// If `null` the ui is not shown.
  String? audioPath;

  String? videoPath;

  RPInstructionStep({
    required super.identifier,
    required super.title,
    super.text,
    super.optional,
    this.detailText,
    this.imagePath,
    this.audioPath,
    this.videoPath,
    super.footnote,
  });

  @override
  Widget get stepWidget => RPUIInstructionStep(step: this);

  @override
  Function get fromJsonFunction => _$RPInstructionStepFromJson;
  factory RPInstructionStep.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson<RPInstructionStep>(json);
  @override
  Map<String, dynamic> toJson() => _$RPInstructionStepToJson(this);

  @override
  String toString() {
    return "identifier: $identifier, title: $title, text: $text, detailText: $detailText, imagePath: $imagePath, audioPath: $audioPath, videoPath: $videoPath, footnote: $footnote";
  }
}
