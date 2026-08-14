part of '../../../model.dart';

/// The result of requesting the OS permissions declared on the sections of a
/// [RPConsentDocument].
///
/// It holds one [RPPermissionStatus] per [RPPermissionType] which was asked
/// for. A permission the participant denied is still recorded — the flow is
/// never blocked by a denial, so the study needs the record to know what it
/// may collect.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class RPPermissionResult extends RPResult {
  /// The status of each permission which was requested.
  Map<RPPermissionType, RPPermissionStatus> statuses;

  RPPermissionResult({
    required super.identifier,
    Map<RPPermissionType, RPPermissionStatus>? statuses,
  }) : statuses = statuses ?? {};

  /// Record the [status] of [type], replacing any previous status for it.
  void setStatus(RPPermissionType type, RPPermissionStatus status) =>
      statuses[type] = status;

  @override
  Function get fromJsonFunction => _$RPPermissionResultFromJson;
  factory RPPermissionResult.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson<RPPermissionResult>(json);

  @override
  Map<String, dynamic> toJson() => _$RPPermissionResultToJson(this);

  @override
  String toString() => '${super.toString()}, statuses: $statuses';
}
