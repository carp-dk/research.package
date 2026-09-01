import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:research_package/research_package.dart';

/// The close button of a task asks before throwing away what was answered.
/// The dialog has to name what is being left and what is lost by leaving, so
/// that "yes" is never the answer to an unread question.
void main() {
  RPOrderedTask surveyTask() => RPOrderedTask(
        identifier: 'surveyTask',
        steps: [
          RPInstructionStep(
            identifier: 'instructionID',
            title: 'Welcome',
            text: 'A survey.',
          ),
        ],
      );

  Future<void> pumpAndOpenDialog(
    WidgetTester tester,
    RPOrderedTask task, {
    void Function(RPTaskResult?)? onCancel,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: RPUITask(
          task: task,
          onCancel: onCancel,
          // The default bar draws no close button on a consent task, so the
          // dialog is opened through the same hook an app would use.
          bottomNavigationBuilder: (context, navigation) => TextButton(
            onPressed: navigation.onCancel,
            child: const Text('close'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('close'));
    await tester.pumpAndSettle();
  }

  testWidgets('names the survey and the answers that are lost', (tester) async {
    await pumpAndOpenDialog(tester, surveyTask());

    expect(find.text('Leave survey?'), findsOneWidget);
    expect(find.text('Your answers will not be saved.'), findsOneWidget);

    // The destructive action says what it does - "YES" answers a question the
    // participant may not have read.
    expect(find.text('LEAVE'), findsOneWidget);
    expect(find.text('CANCEL'), findsOneWidget);
    expect(find.text('YES'), findsNothing);
  });

  testWidgets('a consent task has no answers to lose, and says so', (
    tester,
  ) async {
    final document = RPConsentDocument(
      title: 'Consent',
      sections: [
        RPConsentSection(
          type: RPConsentSectionType.Custom,
          title: 'Welcome',
          summary: 'What this study is about',
          customIllustration: const SizedBox.shrink(),
        ),
      ],
    );

    await pumpAndOpenDialog(
      tester,
      // The review step is what makes this a consent task.
      RPOrderedTask(
        identifier: 'consentTask',
        steps: [
          RPVisualConsentStep(
            identifier: 'visualStep',
            consentDocument: document,
          ),
          RPConsentReviewStep(
            identifier: 'reviewStep',
            title: 'Review',
            consentDocument: document,
          ),
        ],
      ),
    );

    expect(find.text('Leave consent form?'), findsOneWidget);
    expect(find.text('You have not given your consent yet.'), findsOneWidget);
    expect(find.text('Your answers will not be saved.'), findsNothing);
  });

  testWidgets('CANCEL keeps the task and its answers', (tester) async {
    var cancelled = false;
    await pumpAndOpenDialog(
      tester,
      surveyTask(),
      onCancel: (_) => cancelled = true,
    );

    await tester.tap(find.text('CANCEL'));
    await tester.pumpAndSettle();

    expect(cancelled, isFalse, reason: 'dismissing must not end the task');
    expect(find.text('Welcome'), findsOneWidget);
  });

  testWidgets('LEAVE ends the task', (tester) async {
    var cancelled = false;
    await pumpAndOpenDialog(
      tester,
      surveyTask(),
      onCancel: (_) => cancelled = true,
    );

    await tester.tap(find.text('LEAVE'));
    await tester.pumpAndSettle();

    expect(cancelled, isTrue);
  });
}

/// A 1x1 transparent PNG, so the carousel bar has an image to draw.
final Uint8List transparentPixelPng = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk'
  'YPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==',
);
