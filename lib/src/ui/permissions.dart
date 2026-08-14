part of '../../ui.dart';

/// Requests the OS permissions declared on the sections of a
/// [RPConsentDocument].
///
/// This is the only place in Research Package which talks to the platform about
/// permissions. It is used by [RPUIVisualConsentStep] when the step has
/// [RPVisualConsentStep.askPermission] set to `true`, but can also be called
/// directly by an app which wants to ask for a permission outside a consent
/// flow.
class RPPermissions {
  RPPermissions._();

  /// Requests access to health data (Apple HealthKit / Android Health Connect).
  ///
  /// Health data is not covered by the `permission_handler` plugin used by
  /// Research Package, so an app which uses [RPPermissionType.health] has to
  /// provide the request itself. For example, using the `health` package:
  ///
  /// ```dart
  /// RPPermissions.healthHandler = () async =>
  ///     await Health().requestAuthorization(types)
  ///         ? RPPermissionStatus.granted
  ///         : RPPermissionStatus.denied;
  /// ```
  ///
  /// While this is `null`, [RPPermissionType.health] resolves to
  /// [RPPermissionStatus.unsupported] without showing anything.
  static Future<RPPermissionStatus> Function()? healthHandler;

  /// Asks the OS for [type] and returns the outcome.
  ///
  /// If the participant has already granted the permission the OS does not show
  /// a dialog and [RPPermissionStatus.granted] is returned right away.
  ///
  /// Never throws — a platform without an implementation for the permission
  /// resolves to [RPPermissionStatus.unknown] rather than interrupting the
  /// consent flow.
  static Future<RPPermissionStatus> request(RPPermissionType type) async {
    if (type == RPPermissionType.health) {
      return await healthHandler?.call() ?? RPPermissionStatus.unsupported;
    }

    try {
      // Background location can only be asked for once the foreground
      // permission is granted - on both platforms.
      if (type == RPPermissionType.locationAlways) {
        final foreground = _statusOf(
          await ph.Permission.locationWhenInUse.request(),
        );
        if (foreground != RPPermissionStatus.granted) return foreground;
      }

      return _statusOf(await _permissionOf(type).request());
    } catch (error) {
      debugPrint('$RPPermissions - error requesting $type - error: $error');
      return RPPermissionStatus.unknown;
    }
  }

  /// The platform permission to ask for to obtain [type].
  ///
  /// Most types map one-to-one, but activity recognition does not exist as such
  /// on iOS, where the equivalent data comes from CoreMotion.
  static ph.Permission _permissionOf(RPPermissionType type) {
    switch (type) {
      case RPPermissionType.location:
        return ph.Permission.locationWhenInUse;
      case RPPermissionType.locationAlways:
        return ph.Permission.locationAlways;
      case RPPermissionType.microphone:
        return ph.Permission.microphone;
      case RPPermissionType.camera:
        return ph.Permission.camera;
      case RPPermissionType.notification:
        return ph.Permission.notification;
      case RPPermissionType.activityRecognition:
        // Android 10+ has a dedicated permission; on iOS the activity of the
        // participant is read through CoreMotion.
        return Platform.isIOS
            ? ph.Permission.sensors
            : ph.Permission.activityRecognition;
      case RPPermissionType.sensors:
        return ph.Permission.sensors;
      case RPPermissionType.bluetooth:
        return ph.Permission.bluetooth;
      case RPPermissionType.health:
        // Handled by [healthHandler] before this method is reached.
        throw UnsupportedError(
          '$RPPermissionType.health is not a platform permission.',
        );
    }
  }

  static RPPermissionStatus _statusOf(ph.PermissionStatus status) {
    switch (status) {
      case ph.PermissionStatus.granted:
      // The participant granted access, but to a subset of what was asked for
      // (e.g. some photos, or provisional notifications). Access was given, so
      // it counts as granted.
      case ph.PermissionStatus.limited:
      case ph.PermissionStatus.provisional:
        return RPPermissionStatus.granted;
      case ph.PermissionStatus.denied:
        return RPPermissionStatus.denied;
      case ph.PermissionStatus.permanentlyDenied:
        return RPPermissionStatus.permanentlyDenied;
      case ph.PermissionStatus.restricted:
        return RPPermissionStatus.restricted;
    }
  }
}
