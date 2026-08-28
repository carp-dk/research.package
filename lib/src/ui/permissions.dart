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

  /// Asks the OS for [type] and returns the outcome.
  ///
  /// If the participant has already granted the permission the OS does not show
  /// a dialog and [RPPermissionStatus.granted] is returned right away.
  ///
  /// [healthDataTypes] is only used for [RPPermissionType.health], which is not
  /// a single permission — see [requestHealthData]. Without it that type
  /// resolves to [RPPermissionStatus.unsupported].
  ///
  /// Never throws — a platform without an implementation for the permission
  /// resolves to [RPPermissionStatus.unknown] rather than interrupting the
  /// consent flow.
  static Future<RPPermissionStatus> request(
    RPPermissionType type, {
    List<HealthDataType> healthDataTypes = const [],
  }) async {
    if (type == RPPermissionType.health) {
      return await requestHealthData(healthDataTypes);
    }

    // iOS grants background execution through declared background modes.
    if (type == RPPermissionType.ignoreBatteryOptimizations &&
        defaultTargetPlatform != TargetPlatform.android) {
      return RPPermissionStatus.unsupported;
    }

    try {
      // Background location requires the foreground one first, on both
      // platforms.
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

  /// Requests read access to health [types] and returns the outcome.
  ///
  /// Health data is not one permission: Apple HealthKit and Android Health
  /// Connect authorise each [HealthDataType] separately, so the caller has to
  /// say which ones the study reads. An empty list resolves to
  /// [RPPermissionStatus.unsupported] — there is nothing to ask for.
  ///
  /// Nothing is requested when access to all of [types] has already been given,
  /// because `requestAuthorization` can block in that case.
  ///
  /// **On iOS the returned status is optimistic.** HealthKit does not disclose
  /// whether read access was granted — for privacy, an app cannot tell the
  /// difference between "no permission" and "no data" — so
  /// [RPPermissionStatus.granted] here means the authorisation sheet was shown
  /// without error, not that the participant agreed. Android Health Connect
  /// reports the real outcome.
  static Future<RPPermissionStatus> requestHealthData(
    List<HealthDataType> types,
  ) async {
    if (types.isEmpty) return RPPermissionStatus.unsupported;

    try {
      final health = Health();
      // Null on iOS - undetermined, not denied.
      if (await health.hasPermissions(types) ?? false) {
        return RPPermissionStatus.granted;
      }

      return await health.requestAuthorization(types)
          ? RPPermissionStatus.granted
          : RPPermissionStatus.denied;
    } catch (error) {
      debugPrint('$RPPermissions - error requesting health data - $error');
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
        // iOS has no such permission - the data comes from CoreMotion.
        return Platform.isIOS
            ? ph.Permission.sensors
            : ph.Permission.activityRecognition;
      case RPPermissionType.sensors:
        return ph.Permission.sensors;
      case RPPermissionType.bluetooth:
        return ph.Permission.bluetooth;
      case RPPermissionType.ignoreBatteryOptimizations:
        return ph.Permission.ignoreBatteryOptimizations;
      case RPPermissionType.health:
        // Handled by [requestHealthData] before this method is reached.
        throw UnsupportedError(
          '$RPPermissionType.health is not a platform permission.',
        );
    }
  }

  static RPPermissionStatus _statusOf(ph.PermissionStatus status) {
    switch (status) {
      case ph.PermissionStatus.granted:
      // Partial access - some photos, provisional notifications - still counts.
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
