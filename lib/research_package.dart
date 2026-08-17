library research_package;

import 'model.dart';

export 'model.dart';
export 'ui.dart';
// So that declaring [RPConsentSection.healthDataTypes] needs no health import.
export 'package:health/health.dart' show HealthDataType;

/// Start class for this research_package library. Use as a singleton by
/// `ResearchPackage()`.
///
/// In order to ensure initialization of json serialization, call:
///
///    ResearchPackage.ensureInitialized();
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
  static ResearchPackage ensureInitialized() => _instance;
}
