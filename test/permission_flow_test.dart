import 'dart:async';

import 'package:carp_themes_package/carp_themes_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:research_package/research_package.dart';

/// Drives the visual consent step to verify that the permissions declared on a
/// section are asked for when leaving that section, and only when the step opted
/// in with `askPermission`.
///
/// [RPPermissionType.health] is used throughout because it is resolved through
/// [RPPermissions.healthHandler] rather than the platform, which keeps these
/// tests free of a method channel.
void main() {
  /// A consent document whose first section asks for health data and whose
  /// second section asks for nothing.
  RPConsentDocument documentWithHealthOnFirstSection() => RPConsentDocument(
    title: 'Consent',
    sections: [
      RPConsentSection(
        // A Custom section with its own illustration, so the test does not
        // depend on the package's image assets.
        type: RPConsentSectionType.Custom,
        title: 'Health data',
        summary: 'Why we need your health data',
        customIllustration: const SizedBox.shrink(),
        permissions: [RPPermissionType.health],
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

  late List<RPPermissionType> requested;
  late List<RPResult> sentResults;
  late StreamSubscription<RPResult> subscription;

  setUp(() {
    ResearchPackage.ensureInitialized();
    requested = [];
    sentResults = [];
    subscription = blocTask.stepResult.listen(sentResults.add);
    RPPermissions.healthHandler = () async {
      requested.add(RPPermissionType.health);
      return RPPermissionStatus.granted;
    };
  });

  tearDown(() async {
    RPPermissions.healthHandler = null;
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

      // Nothing is asked for while the section is still being read - only when
      // the participant moves on from it.
      expect(requested, isEmpty);

      await tapForward(tester, 'NEXT');
      expect(requested, [RPPermissionType.health]);
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
    // Keyed by the step identifier, which is how RPUITask files it on the task
    // result.
    expect(result.identifier, 'visualStep');
    expect((result as RPPermissionResult).statuses, {
      RPPermissionType.health: RPPermissionStatus.granted,
    });
  });

  testWidgets('an already granted permission is not asked for twice', (
    tester,
  ) async {
    final document = documentWithHealthOnFirstSection();
    // Both sections ask for health, so leaving the second one would prompt again
    // if granted permissions were not skipped.
    document.sections.last.permissions = [RPPermissionType.health];

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

    expect(requested, [RPPermissionType.health]);
  });

  testWidgets('without askPermission nothing is requested or recorded', (
    tester,
  ) async {
    await tester.pumpWidget(
      app(
        RPVisualConsentStep(
          identifier: 'visualStep',
          consentDocument: documentWithHealthOnFirstSection(),
          // Not passing askPermission at all - the default has to stay opt-out so
          // that existing consent flows keep behaving as before.
        ),
      ),
    );

    await tapForward(tester, 'NEXT');
    await tapForward(tester, 'SEE SUMMARY');

    expect(requested, isEmpty);
    expect(sentResults, isEmpty);
  });
}
