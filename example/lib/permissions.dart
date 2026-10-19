part of 'main.dart';

/// Asks the OS for [type] on behalf of Research Package - see
/// [RPPermissions.requester]. A complete requester, which an app can copy.
Future<RPPermissionStatus> requestPermission(
  RPPermissionType type, {
  List<String> healthDataTypes = const [],
}) async {
  switch (type) {
    case RPPermissionType.health:
      return await requestHealthData(healthDataTypes);

    case RPPermissionType.ignoreBatteryOptimizations:
      // iOS grants background execution through declared background modes.
      if (defaultTargetPlatform != TargetPlatform.android) {
        return RPPermissionStatus.unsupported;
      }
      return statusOf(await ph.Permission.ignoreBatteryOptimizations.request());

    case RPPermissionType.locationAlways:
      // Background location requires the foreground one first, on both
      // platforms.
      final foreground = statusOf(
        await ph.Permission.locationWhenInUse.request(),
      );
      if (foreground != RPPermissionStatus.granted) return foreground;
      return statusOf(await ph.Permission.locationAlways.request());

    case RPPermissionType.bluetooth:
      // Android 12 replaced the Bluetooth permission - which is granted
      // without asking - with the "Nearby devices" pair. Asking for both in
      // one call shows a single dialog.
      if (defaultTargetPlatform == TargetPlatform.android) {
        final statuses = await [
          ph.Permission.bluetoothScan,
          ph.Permission.bluetoothConnect,
        ].request();

        return statuses.values
            .map(statusOf)
            .firstWhere(
              (status) => status != RPPermissionStatus.granted,
              orElse: () => RPPermissionStatus.granted,
            );
      }
      return statusOf(await ph.Permission.bluetooth.request());

    case RPPermissionType.activityRecognition:
      // iOS has no such permission - the data comes from CoreMotion.
      return statusOf(
        await (defaultTargetPlatform == TargetPlatform.iOS
                ? ph.Permission.sensors
                : ph.Permission.activityRecognition)
            .request(),
      );

    case RPPermissionType.location:
      return statusOf(await ph.Permission.locationWhenInUse.request());
    case RPPermissionType.microphone:
      return statusOf(await ph.Permission.microphone.request());
    case RPPermissionType.camera:
      return statusOf(await ph.Permission.camera.request());
    case RPPermissionType.notification:
      return statusOf(await ph.Permission.notification.request());
    case RPPermissionType.sensors:
      return statusOf(await ph.Permission.sensors.request());
  }
}

/// Asks for read access to the health data [types] - the names of
/// [HealthDataType]s.
Future<RPPermissionStatus> requestHealthData(List<String> types) async {
  final health = Health();
  final healthTypes = types.map(HealthDataType.values.byName).toList();

  // Below Android 14 Health Connect is a separate app, which can be missing.
  // The health plugin throws when asked without it.
  if (!await health.isHealthConnectAvailable()) {
    await health.installHealthConnect();
    return RPPermissionStatus.unsupported;
  }

  // Null on iOS - undetermined, not denied. Asking again when everything has
  // been granted can block.
  if (await health.hasPermissions(healthTypes) ?? false) {
    return RPPermissionStatus.granted;
  }

  return await health.requestAuthorization(healthTypes)
      ? RPPermissionStatus.granted
      : RPPermissionStatus.denied;
}

RPPermissionStatus statusOf(ph.PermissionStatus status) {
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
