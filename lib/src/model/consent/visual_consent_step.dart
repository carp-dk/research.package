part of '../../../model.dart';

/// The step used for presenting the consent document to the participant
///
/// To use a visual consent step, first create a consent document ([RPConsentDocument])
/// with at least one section and attach the document to a visual consent step.
/// Put the visual consent step into a Research Package task, and present it
/// with an [RPUITask].
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class RPVisualConsentStep extends RPStep {
  /// The consent document whose sections determine the order and appearance of
  /// scenes in the visual consent step.
  RPConsentDocument consentDocument;

  /// Should the OS permissions declared on the sections of the
  /// [consentDocument] be requested while going through them?
  ///
  /// When `true`, tapping "NEXT" on a section which has
  /// [RPConsentSection.permissions] triggers the native permission dialog for
  /// each of them before moving on, so the participant is asked in context. The
  /// outcome of every request is collected in an [RPPermissionResult] which is
  /// added to the task result under this step's [identifier]. A denied
  /// permission is recorded but never blocks the participant.
  ///
  /// `false` by default, in which case no permission is ever requested and no
  /// [RPPermissionResult] is produced.
  ///
  /// Note that the host app is responsible for declaring the permissions it
  /// asks for in `Info.plist` (iOS) and `AndroidManifest.xml` (Android), and
  /// that [RPPermissionType.health] additionally needs a
  /// [RPPermissions.healthHandler].
  bool askPermission;

  RPVisualConsentStep({
    required super.identifier,
    required this.consentDocument,
    this.askPermission = false,
  }) : super(title: '');

  /// The widget (UI representation) of the step
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  Widget get stepWidget => RPUIVisualConsentStep(step: this);

  @override
  Function get fromJsonFunction => _$RPVisualConsentStepFromJson;
  factory RPVisualConsentStep.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson<RPVisualConsentStep>(json);
  @override
  Map<String, dynamic> toJson() => _$RPVisualConsentStepToJson(this);
}
