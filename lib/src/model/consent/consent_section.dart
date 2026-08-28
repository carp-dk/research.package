part of '../../../model.dart';

/// A content section in a [RPConsentDocument].
///
/// It represents one section in a [RPConsentDocument].
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class RPConsentSection extends Serializable {
  /// The type of the section.
  ///
  /// The [title] and the image which is shown on the section card is associated
  /// to the [type].
  RPConsentSectionType type;

  /// The title of the consent section which appears both in [RPVisualConsentStep]
  /// and [RPConsentReviewStep].
  late String title;

  /// A short summary of the section. It appears during [RPVisualConsentStep]
  String summary;

  /// A longer content text of the section.
  ///
  /// It's presented during [RPVisualConsentStep] when tapping on the "Learn more"
  /// button and during [RPConsentReviewStep] where each section's content is
  /// shown to the user.
  String? content;

  /// The data type sections that will be displayed if the consent section is of
  /// type UserDataCollection or PassiveDataCollection.
  List<RPDataTypeSection>? dataTypes;

  /// The OS permissions which this section explains the need for.
  ///
  /// They are requested when the participant taps "NEXT" on this section during
  /// a [RPVisualConsentStep] which has [RPVisualConsentStep.askPermission] set
  /// to `true`. This way the permission dialog is shown in context, with the
  /// [summary] and [content] of this section as the rationale — which is what
  /// both Apple and Google ask for.
  ///
  /// If `null` or empty, no permissions are requested for this section.
  List<RPPermissionType>? permissions;

  /// The health data types this section explains the need for.
  ///
  /// Health data is not a single permission — Apple HealthKit and Android
  /// Health Connect authorise each data type separately — so listing
  /// [RPPermissionType.health] in [permissions] is not enough on its own. This
  /// is the list which is actually asked for, and it also documents in the
  /// consent document itself which health data the study reads.
  ///
  /// Read access is requested for every type listed. Ignored unless
  /// [permissions] contains [RPPermissionType.health]; conversely, that
  /// permission resolves to [RPPermissionStatus.unsupported] if this is `null`
  /// or empty, since there would be nothing to ask for.
  List<HealthDataType>? healthDataTypes;

  /// A custom illustration (an [Image] or [Icon] to show for Custom [RPConsentSectionType]
  @JsonKey(includeFromJson: false, includeToJson: false)
  Widget? customIllustration;

  /// Create a new [RPConsentSection] of a given [type].
  ///
  /// It is enough to provide the [type] and [summary] of the section.
  /// If a [title] is not provided, a default title is used, unless the type is
  /// [RPConsentSectionType.Custom]. In that case, the title must be provided.
  RPConsentSection(
      {required this.type,
      String? title,
      required this.summary,
      this.content,
      this.dataTypes,
      this.permissions,
      this.healthDataTypes,
      this.customIllustration}) {
    assert(type != RPConsentSectionType.Custom || title != null,
        "If a you are creating a Custom ConsentSection, then a title must be provided.");
    this.title = (type == RPConsentSectionType.Custom)
        ? title!
        : (title != null)
            ? title
            : "title.${type.name.toLowerCase()}";
  }

  @override
  Function get fromJsonFunction => _$RPConsentSectionFromJson;
  factory RPConsentSection.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson<RPConsentSection>(json);
  @override
  Map<String, dynamic> toJson() => _$RPConsentSectionToJson(this);
}

/// Enum containing the available types for [RPConsentSection].
///
/// Every type has a title and a logo associated to it.
/// Use [Custom] to create your own section type and avoid any pre-population
/// (title, logo, animation).
/// See more at: [http://researchkit.org/docs/Constants/ORKConsentSectionType.html]
enum RPConsentSectionType {
  Overview,
  DataGathering,
  Privacy,
  DataUse,
  TimeCommitment,
  Duration,
  StudyTasks,
  StudySurvey,
  Withdrawing,
  YourRights,
  Welcome,
  AboutUs,
  Goals,
  Benefits,
  DataHandling,
  Location,
  BackgroundSensing,
  Health,
  HealthDataCollection,
  UserDataCollection,
  PassiveDataCollection,
  Custom
}
