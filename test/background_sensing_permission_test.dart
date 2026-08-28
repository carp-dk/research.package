import 'dart:async';

import 'package:carp_themes_package/carp_themes_package.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:research_package/research_package.dart';

/// Verifies [RPPermissionType.ignoreBatteryOptimizations] - the exemption which
/// lets a study keep sampling while the app is in the background.
///
/// It is the odd one out: Android opens a settings page rather than a dialog,
/// and iOS has no equivalent at all.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  /// The channel of the `permission_handler` plugin, faked below.
  const permissionChannel = MethodChannel(
    'flutter.baseflow.com/permissions/methods',
  );

  /// `Permission.ignoreBatteryOptimizations.value`, as it goes over the channel.
  const ignoreBatteryOptimizations = 16;

  /// `PermissionStatus.granted.index`.
  const granted = 1;

  /// `PermissionStatus.denied.index`.
  const denied = 0;

  RPConsentDocument document() => RPConsentDocument(
    title: 'Consent',
    sections: [
      RPConsentSection(
        type: RPConsentSectionType.BackgroundSensing,
        summary: 'The study keeps collecting data while the app is closed',
        permissions: [RPPermissionType.ignoreBatteryOptimizations],
      ),
      RPConsentSection(
        type: RPConsentSectionType.Custom,
        title: 'Your rights',
        summary: 'What you can do',
        customIllustration: const SizedBox.shrink(),
      ),
    ],
  );

  Widget app(RPVisualConsentStep step) => MaterialApp(
    theme: carpTheme,
    home: RPUIVisualConsentStep(step: step),
  );

  Future<void> tapForward(WidgetTester tester, String label) async {
    await tester.tap(find.text(label));
    await tester.pumpAndSettle();
  }

  /// The permissions passed to `requestPermissions`, one entry per call.
  late List<List<int>> requested;
  late List<RPResult> sentResults;
  late StreamSubscription<RPResult> subscription;

  /// What the faked plugin answers when the permission is requested.
  late int requestOutcome;

  setUp(() {
    ResearchPackage.ensureInitialized();
    requested = [];
    sentResults = [];
    requestOutcome = granted;
    subscription = blocTask.stepResult.listen(sentResults.add);

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(permissionChannel, (call) async {
          switch (call.method) {
            case 'requestPermissions':
              final permissions = (call.arguments as List).cast<int>();
              requested.add(permissions);
              return {for (final p in permissions) p: requestOutcome};
            case 'checkPermissionStatus':
              return denied;
          }
          return null;
        });
  });

  tearDown(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(permissionChannel, null);
    await subscription.cancel();
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('the exemption is asked for when leaving its section', (
    tester,
  ) async {
    await tester.pumpWidget(
      app(
        RPVisualConsentStep(
          identifier: 'visualStep',
          consentDocument: document(),
          askPermission: true,
        ),
      ),
    );

    // Only asked for when the participant moves on from the section.
    expect(requested, isEmpty);

    await tapForward(tester, 'NEXT');

    expect(requested, [
      [ignoreBatteryOptimizations],
    ]);
  });

  testWidgets('the outcome is recorded in the task result', (tester) async {
    await tester.pumpWidget(
      app(
        RPVisualConsentStep(
          identifier: 'visualStep',
          consentDocument: document(),
          askPermission: true,
        ),
      ),
    );

    await tapForward(tester, 'NEXT');
    await tapForward(tester, 'SEE SUMMARY');

    final result = sentResults.single as RPPermissionResult;
    expect(result.statuses, {
      RPPermissionType.ignoreBatteryOptimizations: RPPermissionStatus.granted,
    });
  });

  testWidgets('a refused exemption is recorded, not blocking', (tester) async {
    requestOutcome = denied;

    await tester.pumpWidget(
      app(
        RPVisualConsentStep(
          identifier: 'visualStep',
          consentDocument: document(),
          askPermission: true,
        ),
      ),
    );

    await tapForward(tester, 'NEXT');
    // The participant still reaches the end of the consent.
    await tapForward(tester, 'SEE SUMMARY');

    final result = sentResults.single as RPPermissionResult;
    expect(result.statuses, {
      RPPermissionType.ignoreBatteryOptimizations: RPPermissionStatus.denied,
    });
  });

  test(
    'on iOS it resolves to unsupported without touching the platform',
    () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

      // iOS grants background execution through the background modes the app
      // declares, so there is nothing to ask the participant for.
      expect(
        await RPPermissions.request(
          RPPermissionType.ignoreBatteryOptimizations,
        ),
        RPPermissionStatus.unsupported,
      );
      expect(requested, isEmpty);
    },
  );
}
