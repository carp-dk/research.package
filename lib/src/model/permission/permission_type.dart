part of '../../../model.dart';

/// The OS permissions Research Package can request on behalf of a study.
///
/// A [RPConsentSection] lists the permissions its text justifies in
/// [RPConsentSection.permissions]. They are requested in context — while the
/// section explaining them is on screen — which is what both Apple and Google
/// ask for.
enum RPPermissionType {
  /// Access to the device location while the app is in the foreground.
  location,

  /// Access to the device location also while the app is in the background.
  ///
  /// Both platforms require the foreground permission to be granted first, so
  /// requesting this asks for [location] before escalating.
  locationAlways,

  /// Access to the microphone, e.g. for audio recordings or noise sampling.
  microphone,

  /// Access to the camera.
  camera,

  /// Permission to show notifications, e.g. survey reminders.
  notification,

  /// Access to the recognized activity of the participant (walking, running,
  /// in a vehicle, ...).
  activityRecognition,

  /// Access to the body sensors of the device, e.g. heart rate.
  sensors,

  /// Access to Bluetooth, e.g. for connecting to a wearable device.
  bluetooth,

  /// Access to health data (Apple HealthKit / Android Health Connect).
  ///
  /// Unlike the others this is not a single OS permission — both platforms
  /// authorise each health data type separately — so the section must also
  /// list the types it needs in [RPConsentSection.healthDataTypes]. Without
  /// them there is nothing to ask for and this resolves to
  /// [RPPermissionStatus.unsupported].
  health,
}

/// The outcome of requesting an [RPPermissionType].
enum RPPermissionStatus {
  /// The permission was granted by the participant.
  granted,

  /// The permission was denied. It can be asked for again.
  denied,

  /// The permission was denied and the OS will not show the dialog again.
  /// The participant has to grant it from the system settings.
  permanentlyDenied,

  /// The OS does not allow this permission, e.g. due to parental controls.
  restricted,

  /// The permission does not exist on this platform, or it is
  /// [RPPermissionType.health] and the section listed no
  /// [RPConsentSection.healthDataTypes] to ask for.
  unsupported,

  /// The status could not be determined, e.g. because no platform
  /// implementation is available.
  unknown,
}
