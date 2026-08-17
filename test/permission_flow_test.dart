import 'dart:async';
import 'dart:convert';

import 'package:carp_themes_package/carp_themes_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:research_package/research_package.dart';

/// Verifies that the permissions declared on a consent section are asked for
/// when leaving it, and only when the step opted in with `askPermission`.
///
/// [RPPermissionType.health] is used throughout because its single method
/// channel can be faked, so the real request path runs.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  /// The channel of the `health` plugin, faked below.
  const healthChannel = MethodChannel('flutter_health');

  /// The health data types this study reads - two, because health is not one
  /// permission.
  const healthTypes = [HealthDataType.STEPS, HealthDataType.SLEEP_ASLEEP];
  const healthTypeNames = ['STEPS', 'SLEEP_ASLEEP'];

  /// A document whose first section asks for health data and whose second asks
  /// for nothing.
  RPConsentDocument documentWithHealthOnFirstSection() => RPConsentDocument(
    title: 'Consent',
    sections: [
      RPConsentSection(
        // A Custom section, so no image asset of the package is needed.
        type: RPConsentSectionType.Custom,
        title: 'Health data',
        summary: 'Why we need your health data',
        customIllustration: const SizedBox.shrink(),
        permissions: [RPPermissionType.health],
        healthDataTypes: healthTypes,
      ),
      RPConsentSection(
        type: RPConsentSectionType.Custom,
        title: 'Your rights',
        summary: 'What you can do',
        customIllustration: const SizedBox.shrink(),
      ),
    ],
  );

  /// A three section document whose *middle* section asks for health data.
  RPConsentDocument documentWithHealthOnMiddleSection() => RPConsentDocument(
    title: 'Consent',
    sections: [
      RPConsentSection(
        type: RPConsentSectionType.Custom,
        title: 'Welcome',
        summary: 'What this study is about',
        customIllustration: const SizedBox.shrink(),
      ),
      RPConsentSection(
        type: RPConsentSectionType.Custom,
        title: 'Health data',
        summary: 'Why we need your health data',
        customIllustration: const SizedBox.shrink(),
        permissions: [RPPermissionType.health],
        healthDataTypes: healthTypes,
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

  /// Taps the forward button of the consent step and settles.
  Future<void> tapForward(WidgetTester tester, String label) async {
    await tester.tap(find.text(label));
    await tester.pumpAndSettle();
  }

  /// The health data types passed to `requestAuthorization`, one entry per call.
  late List<List<String>> requested;
  late List<RPResult> sentResults;
  late StreamSubscription<RPResult> subscription;

  /// What the faked plugin answers. A null `hasPermissions` is the iOS
  /// behaviour - HealthKit does not disclose read access.
  late bool? alreadyGranted;
  late bool authorizationSucceeds;

  setUp(() {
    ResearchPackage.ensureInitialized();
    requested = [];
    sentResults = [];
    alreadyGranted = null;
    authorizationSucceeds = true;
    subscription = blocTask.stepResult.listen(sentResults.add);

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(healthChannel, (call) async {
          final types = ((call.arguments as Map)['types'] as List)
              .cast<String>();
          switch (call.method) {
            case 'hasPermissions':
              return alreadyGranted;
            case 'requestAuthorization':
              requested.add(types);
              return authorizationSucceeds;
          }
          return null;
        });
  });

  tearDown(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(healthChannel, null);
    await subscription.cancel();
  });

  testWidgets(
    'askPermission asks for the permissions of the section on screen',
    (tester) async {
      await tester.pumpWidget(
        app(
          RPVisualConsentStep(
            identifier: 'visualStep',
            consentDocument: documentWithHealthOnFirstSection(),
            askPermission: true,
          ),
        ),
      );

      // Only asked for when the participant moves on from the section.
      expect(requested, isEmpty);

      await tapForward(tester, 'NEXT');
      expect(requested, [healthTypeNames]);
    },
  );

  testWidgets('the outcome is added to the task result when the step finishes', (
    tester,
  ) async {
    await tester.pumpWidget(
      app(
        RPVisualConsentStep(
          identifier: 'visualStep',
          consentDocument: documentWithHealthOnFirstSection(),
          askPermission: true,
        ),
      ),
    );

    await tapForward(tester, 'NEXT');
    // The result is only sent once, at the end of the step - not per section.
    expect(sentResults, isEmpty);

    await tapForward(tester, 'SEE SUMMARY');

    expect(sentResults, hasLength(1));
    final result = sentResults.single;
    expect(result, isA<RPPermissionResult>());
    // Keyed by the step identifier, as RPUITask files it.
    expect(result.identifier, 'visualStep');
    expect((result as RPPermissionResult).statuses, {
      RPPermissionType.health: RPPermissionStatus.granted,
    });
  });

  testWidgets('an already granted permission is not asked for twice', (
    tester,
  ) async {
    final document = documentWithHealthOnFirstSection();
    // Both sections ask for health, so the second would prompt again if
    // granted permissions were not skipped.
    document.sections.last.permissions = [RPPermissionType.health];
    document.sections.last.healthDataTypes = healthTypes;

    await tester.pumpWidget(
      app(
        RPVisualConsentStep(
          identifier: 'visualStep',
          consentDocument: document,
          askPermission: true,
        ),
      ),
    );

    await tapForward(tester, 'NEXT');
    await tapForward(tester, 'SEE SUMMARY');

    expect(requested, [healthTypeNames]);
  });

  testWidgets('without askPermission nothing is requested or recorded', (
    tester,
  ) async {
    await tester.pumpWidget(
      app(
        RPVisualConsentStep(
          identifier: 'visualStep',
          consentDocument: documentWithHealthOnFirstSection(),
          // Not passing askPermission at all - it has to stay opt-out.
        ),
      ),
    );

    await tapForward(tester, 'NEXT');
    await tapForward(tester, 'SEE SUMMARY');

    expect(requested, isEmpty);
    expect(sentResults, isEmpty);
  });

  /// Health is not a single permission, so the section says which types it
  /// needs and those are what reaches the plugin.
  group('health data types', () {
    Future<RPPermissionResult> runStep(
      WidgetTester tester,
      RPConsentDocument document,
    ) async {
      await tester.pumpWidget(
        app(
          RPVisualConsentStep(
            identifier: 'visualStep',
            consentDocument: document,
            askPermission: true,
          ),
        ),
      );
      await tapForward(tester, 'NEXT');
      await tapForward(tester, 'SEE SUMMARY');
      return sentResults.single as RPPermissionResult;
    }

    testWidgets('the types declared on the section are the ones requested', (
      tester,
    ) async {
      final document = documentWithHealthOnFirstSection();
      document.sections.first.healthDataTypes = const [
        HealthDataType.HEART_RATE,
      ];

      await runStep(tester, document);

      // Not the two types of the shared fixture - the ones this section names.
      expect(requested, [
        ['HEART_RATE'],
      ]);
    });

    testWidgets('declaring health without any type asks for nothing', (
      tester,
    ) async {
      final document = documentWithHealthOnFirstSection();
      // With no types there is nothing to request, so no sheet to show.
      document.sections.first.healthDataTypes = null;

      final result = await runStep(tester, document);

      expect(requested, isEmpty);
      expect(result.statuses, {
        RPPermissionType.health: RPPermissionStatus.unsupported,
      });
    });

    testWidgets('data already authorised is not asked for again', (
      tester,
    ) async {
      // requestAuthorization can block when access was already granted.
      alreadyGranted = true;

      final result = await runStep(tester, documentWithHealthOnFirstSection());

      expect(requested, isEmpty);
      expect(result.statuses, {
        RPPermissionType.health: RPPermissionStatus.granted,
      });
    });

    testWidgets('a refused authorisation is recorded as denied', (
      tester,
    ) async {
      authorizationSucceeds = false;

      final result = await runStep(tester, documentWithHealthOnFirstSection());

      expect(requested, [healthTypeNames]);
      // Recorded, not blocking - the participant still reaches the end.
      expect(result.statuses, {
        RPPermissionType.health: RPPermissionStatus.denied,
      });
    });
  });

  /// A screen explaining an upcoming permission request may offer no way out
  /// but the alert it leads to (Apple HIG, Privacy). These tests pin the
  /// resulting button layout.
  group('a section explaining a permission offers no way out but the alert', () {
    testWidgets('it carries the forward button and nothing else', (
      tester,
    ) async {
      await tester.pumpWidget(
        app(
          RPVisualConsentStep(
            identifier: 'visualStep',
            consentDocument: documentWithHealthOnMiddleSection(),
            askPermission: true,
          ),
        ),
      );

      // Onto the health section - not the first, so it would show Back.
      await tapForward(tester, 'NEXT');
      expect(find.text('Health data'), findsOneWidget);

      expect(find.text('BACK'), findsNothing);
      expect(find.text('CANCEL'), findsNothing);
    });

    testWidgets('Back returns once the alert has been shown', (tester) async {
      await tester.pumpWidget(
        app(
          RPVisualConsentStep(
            identifier: 'visualStep',
            consentDocument: documentWithHealthOnMiddleSection(),
            askPermission: true,
          ),
        ),
      );

      // Onto the health section, then past it - which is what shows the alert.
      await tapForward(tester, 'NEXT');
      await tapForward(tester, 'NEXT');
      expect(requested, [healthTypeNames]);

      // No longer about to open an alert, so it behaves normally again.
      await tapForward(tester, 'BACK');
      expect(find.text('Health data'), findsOneWidget);
      expect(find.text('BACK'), findsOneWidget);
    });

    testWidgets('the consent step has no cancel button at all', (tester) async {
      await tester.pumpWidget(
        app(
          RPVisualConsentStep(
            identifier: 'visualStep',
            consentDocument: documentWithHealthOnMiddleSection(),
          ),
        ),
      );

      for (var section = 0; section < 3; section++) {
        expect(find.text('CANCEL'), findsNothing);
        if (section < 2) await tapForward(tester, 'NEXT');
      }
    });
  });

  group('navigating back through the consent sections', () {
    testWidgets('the first section has nothing to go back to', (tester) async {
      await tester.pumpWidget(
        app(
          RPVisualConsentStep(
            identifier: 'visualStep',
            consentDocument: documentWithHealthOnMiddleSection(),
          ),
        ),
      );

      expect(find.text('Welcome'), findsOneWidget);
      expect(find.text('BACK'), findsNothing);
    });

    testWidgets('Back returns to the previous section', (tester) async {
      await tester.pumpWidget(
        app(
          RPVisualConsentStep(
            identifier: 'visualStep',
            // Without askPermission no section is a permission screen.
            consentDocument: documentWithHealthOnMiddleSection(),
          ),
        ),
      );

      await tapForward(tester, 'NEXT');
      expect(find.text('Health data'), findsOneWidget);

      await tapForward(tester, 'BACK');
      expect(find.text('Welcome'), findsOneWidget);
      expect(find.text('BACK'), findsNothing);
    });

    testWidgets('leaving the last section restores the NEXT label', (
      tester,
    ) async {
      await tester.pumpWidget(
        app(
          RPVisualConsentStep(
            identifier: 'visualStep',
            consentDocument: documentWithHealthOnMiddleSection(),
          ),
        ),
      );

      await tapForward(tester, 'NEXT');
      await tapForward(tester, 'NEXT');
      expect(find.text('SEE SUMMARY'), findsOneWidget);

      // Going back has to un-set "last page", or the forward button would
      // finish the step from the middle of the document.
      await tapForward(tester, 'BACK');
      expect(find.text('SEE SUMMARY'), findsNothing);
      expect(find.text('NEXT'), findsOneWidget);
    });
  });

  group('the close button of the task', () {
    RPConsentReviewStep reviewStep(RPConsentDocument document) =>
        RPConsentReviewStep(
          identifier: 'reviewStep',
          title: 'Review',
          consentDocument: document,
        );

    RPVisualConsentStep visualStep(RPConsentDocument document) =>
        RPVisualConsentStep(
          identifier: 'visualStep',
          consentDocument: document,
        );

    Future<void> pumpTask(WidgetTester tester, RPOrderedTask task) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: carpTheme,
          home: RPUITask(
            task: task,
            // The default is an asset, which no widget test resolves.
            carouselBarImage: Image.memory(transparentPixelPng),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets(
      'an informed consent flow has none - it is left with DISAGREE',
      (tester) async {
        final document = documentWithHealthOnMiddleSection();
        await pumpTask(
          tester,
          // The presence of a review step is what makes this a consent task.
          RPOrderedTask(
            identifier: 'consentTask',
            steps: [visualStep(document), reviewStep(document)],
          ),
        );

        expect(find.byIcon(Icons.highlight_off), findsNothing);
      },
    );

    testWidgets('any other task keeps it', (tester) async {
      final document = documentWithHealthOnMiddleSection();
      await pumpTask(
        tester,
        RPOrderedTask(identifier: 'plainTask', steps: [visualStep(document)]),
      );

      expect(find.byIcon(Icons.highlight_off), findsOneWidget);
    });
  });
}

/// A 1x1 transparent PNG, so a test can supply an image without an asset.
final Uint8List transparentPixelPng = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII=',
);
