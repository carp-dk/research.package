library research_package;

import 'model.dart';
import 'ui.dart';

export 'model.dart';
export 'ui.dart';

/// Start class for this research_package library. Use as a singleton by
/// `ResearchPackage()`.
///
/// In order to ensure initialization of json serialization, call:
///
///    ResearchPackage.ensureInitialized();
///
/// An app which asks for OS permissions passes its requester here too — see
/// [ensureInitialized].
///
class ResearchPackage {
  static final _instance = ResearchPackage._();
  factory ResearchPackage() => _instance;
  ResearchPackage._() {
    registerFromJsonFunctions();
  }

  /// Returns the singleton instance of [ResearchPackage].
  /// If it has not yet been initialized, this call makes sure to create and
  /// initialize it.
  ///
  /// [permissionRequester] asks the OS for the permissions of a consent flow
  /// with [RPVisualConsentStep.askPermission] set — see
  /// [RPPermissions.requester]. Leaving it out keeps the requester given
  /// earlier, so calling this again elsewhere does not drop it.
  static ResearchPackage ensureInitialized({
    RPPermissionRequester? permissionRequester,
  }) {
    if (permissionRequester != null) {
      RPPermissions.requester = permissionRequester;
    }
    return _instance;
  }
}
