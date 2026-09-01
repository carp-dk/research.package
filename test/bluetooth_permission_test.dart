import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:research_package/research_package.dart';

/// Verifies that asking for [RPPermissionType.bluetooth] on Android requests
/// the "Nearby devices" permissions, and the adapter permission elsewhere.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('flutter.baseflow.com/permissions/methods');

  // The permission values of permission_handler, as sent over the channel.
  const bluetooth = 21;
  const bluetoothScan = 28;
  const bluetoothConnect = 30;
  const granted = 1;
  const permanentlyDenied = 4;

  late List<int> requested;

  /// Fakes the plugin, answering every requested permission with [outcome].
  void fakePermissions(int outcome) {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          switch (call.method) {
            case 'requestPermissions':
              final values = List<int>.from(call.arguments as List);
              requested.addAll(values);
              return {for (final value in values) value: outcome};
            case 'checkPermissionStatus':
              return outcome;
            default:
              return null;
          }
        });
  }

  setUp(() {
    requested = [];
    fakePermissions(granted);
  });

  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('asks for the nearby devices permissions on Android', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;

    final status = await RPPermissions.request(RPPermissionType.bluetooth);

    expect(requested, [bluetoothScan, bluetoothConnect]);
    expect(requested, isNot(contains(bluetooth)));
    expect(status, RPPermissionStatus.granted);
  });

  test('reports the refused permission of the pair', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    fakePermissions(permanentlyDenied);

    final status = await RPPermissions.request(RPPermissionType.bluetooth);

    expect(status, RPPermissionStatus.permanentlyDenied);
  });

  test('asks for the adapter permission on iOS', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

    final status = await RPPermissions.request(RPPermissionType.bluetooth);

    expect(requested, [bluetooth]);
    expect(status, RPPermissionStatus.granted);
  });
}
