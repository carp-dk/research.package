part of '../../../model.dart';

/// Class representing an Answer Format that lets participants choose a
/// star rating
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class RPStarChoiceAnswerFormat extends RPAnswerFormat {
  /// A list of available [RPStarChoice] objects which represent the choices to
  /// the participants.
  List<RPStarChoice> choices;

  /// Returns an initialized [RPStarChoiceAnswerFormat] with the given list of
  /// [RPStarChoice]s.
  RPStarChoiceAnswerFormat({required this.choices}) : super();

  @override
  RPQuestionType get questionType => RPQuestionType.ImageChoice;

  @override
  Function get fromJsonFunction => _$RPStarChoiceAnswerFormatFromJson;
  factory RPStarChoiceAnswerFormat.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson<RPStarChoiceAnswerFormat>(json);
  @override
  Map<String, dynamic> toJson() => _$RPStarChoiceAnswerFormatToJson(this);
}

/// The image choice object which the participants can choose from, during a
/// [RPQuestionStep] with [RPStarChoiceAnswerFormat]
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class RPStarChoice extends Serializable {
  /// The image portraying the choice.
  String starActiveUrl;
  String starNotActiveUrl;

  /// The key of the image if this is to be loaded from the images
  /// in the assets on the phone.
  /// Specify either the [image] or the [key].
  String? keyActive;
  String? keyNotActive;

  /// The value of the choice. Can be any type but MUST be serializable if this feature is used.
  dynamic value;

  /// The description fitting the image. Is displayed when selected.
  String description;

  RPStarChoice({
    required this.starActiveUrl,
    required this.starNotActiveUrl,
    this.keyActive,
    this.keyNotActive,
    this.value,
    required this.description,
  }) : super();

  @override
  Function get fromJsonFunction => _$RPStarChoiceFromJson;
  factory RPStarChoice.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson<RPStarChoice>(json);
  @override
  Map<String, dynamic> toJson() => _$RPStarChoiceToJson(this);
}
