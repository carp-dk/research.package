part of '../../ui.dart';

/// Asks the OS for [type] and returns the outcome — see
/// [RPPermissions.requester].
///
/// [healthDataTypes] is only given for [RPPermissionType.health], and is never
/// empty then — see [RPConsentSection.healthDataTypes].
typedef RPPermissionRequester = Future<RPPermissionStatus> Function(
    RPPermissionType type,
    {List<String> healthDataTypes});

/// Requests the OS permissions declared on the sections of a
/// [RPConsentDocument].
///
/// It is used by [RPUIVisualConsentStep] when the step has
/// [RPVisualConsentStep.askPermission] set to `true`, but can also be called
/// directly by an app which wants to ask for a permission outside a consent
/// flow. The asking itself is done by the app, through [requester].
class RPPermissions {
  RPPermissions._();

  /// Asks the OS for a permission, on behalf of [request].
  ///
  /// Research Package does not talk to the platform about permissions itself,
  /// so that it does not force a native plugin on every app using it. Linking
  /// the `health` plugin for instance links Apple HealthKit, and App Store
  /// review rejects an app which links HealthKit without using it. An app
  /// which sets [RPVisualConsentStep.askPermission] therefore provides this,
  /// built on e.g. `permission_handler` and `health`, by passing it to
  /// [ResearchPackage.ensureInitialized].
  ///
  /// While this is `null`, every permission resolves to
  /// [RPPermissionStatus.unsupported].
  static RPPermissionRequester? requester;

  /// Asks the OS for [type] through [requester] and returns the outcome.
  ///
  /// [healthDataTypes] is only used for [RPPermissionType.health], which is not
  /// a single permission: Apple HealthKit and Android Health Connect authorise
  /// each data type separately. Without any, there is nothing to ask for and
  /// that type resolves to [RPPermissionStatus.unsupported].
  ///
  /// Never throws — an error in [requester] resolves to
  /// [RPPermissionStatus.unknown] rather than interrupting the consent flow.
  static Future<RPPermissionStatus> request(
    RPPermissionType type, {
    List<String> healthDataTypes = const [],
  }) async {
    if (type == RPPermissionType.health && healthDataTypes.isEmpty) {
      return RPPermissionStatus.unsupported;
    }

    final requester = RPPermissions.requester;
    if (requester == null) {
      debugPrint('$RPPermissions - $type cannot be requested, because no '
          'RPPermissions.requester has been set.');
      return RPPermissionStatus.unsupported;
    }

    try {
      return await requester(type, healthDataTypes: healthDataTypes);
    } catch (error) {
      debugPrint('$RPPermissions - error requesting $type - error: $error');
      return RPPermissionStatus.unknown;
    }
  }
}
