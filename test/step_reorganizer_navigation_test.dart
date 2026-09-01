import 'package:carp_themes_package/carp_themes_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:research_package/research_package.dart';

/// A reorganizer rule keeps only the steps the answer selected. What it must
/// not do is drop the steps already visited - that is what left BACK dead.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => ResearchPackage.ensureInitialized());

  RPChoice a = RPChoice(text: 'A', value: 0);
  RPChoice b = RPChoice(text: 'B', value: 1);

  RPNavigableOrderedTask task() => RPNavigableOrderedTask(
        identifier: 'reorganizer',
        steps: [
          RPQuestionStep(
            identifier: 'pick',
            title: 'Pick',
            answerFormat: RPChoiceAnswerFormat(
                answerStyle: RPChoiceAnswerStyle.MultipleChoice,
                choices: [a, b]),
          ),
          RPInstructionStep(identifier: 'stepA', title: 'A', text: 'A body'),
          RPInstructionStep(identifier: 'stepB', title: 'B', text: 'B body'),
        ],
      )..setNavigationRuleForTriggerStepIdentifier(
          RPStepReorganizerRule(
              reorderingMap: {0: 'stepA', 1: 'stepB'}),
          'pick');

  testWidgets('the trigger step survives the reorganization, so BACK works',
      (tester) async {
    final reorganized = task();

    await tester.pumpWidget(MaterialApp(
      theme: carpTheme,
      home: RPUITask(
        task: reorganized,
        carouselBarBuilder: (_, __, ___) => const SizedBox.shrink(),
      ),
    ));
    await tester.pumpAndSettle();

    // Answer the question and move on.
    await tester.tap(find.text('B'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('NEXT'));
    await tester.pumpAndSettle();

    // Only the selected branch is left, but the answered step is still there.
    expect(find.text('B body'), findsOneWidget);
    expect(reorganized.steps.map((step) => step.identifier),
        containsAll(['pick', 'stepB']));
    expect(reorganized.steps.map((step) => step.identifier),
        isNot(contains('stepA')));

    // ...which is what BACK returns to.
    await tester.tap(find.text('BACK'));
    await tester.pumpAndSettle();
    expect(find.text('Pick'), findsOneWidget);
  });

  testWidgets('a branch dropped by an earlier answer comes back when the '
      'answer changes', (tester) async {
    final reorganized = task();

    await tester.pumpWidget(MaterialApp(
      theme: carpTheme,
      home: RPUITask(
        task: reorganized,
        carouselBarBuilder: (_, __, ___) => const SizedBox.shrink(),
      ),
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.text('B'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('NEXT'));
    await tester.pumpAndSettle();
    expect(find.text('B body'), findsOneWidget);

    // Go back and pick the branch the first answer had removed.
    await tester.tap(find.text('BACK'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('B'));
    await tester.tap(find.text('A'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('NEXT'));
    await tester.pumpAndSettle();

    expect(find.text('A body'), findsOneWidget);
  });

  testWidgets('a completion step ends the task whichever branch is taken',
      (tester) async {
    final withCompletion = RPNavigableOrderedTask(
      identifier: 'reorganizer',
      steps: [
        RPQuestionStep(
          identifier: 'pick',
          title: 'Pick',
          answerFormat: RPChoiceAnswerFormat(
              answerStyle: RPChoiceAnswerStyle.MultipleChoice,
              choices: [a, b]),
        ),
        RPInstructionStep(identifier: 'stepA', title: 'A', text: 'A body'),
        RPInstructionStep(identifier: 'stepB', title: 'B', text: 'B body'),
        RPCompletionStep(
            identifier: 'done', title: 'Done', text: 'Thank you'),
      ],
    )..setNavigationRuleForTriggerStepIdentifier(
        RPStepReorganizerRule(reorderingMap: {0: 'stepA', 1: 'stepB'}), 'pick');

    await tester.pumpWidget(MaterialApp(
      theme: carpTheme,
      home: RPUITask(
        task: withCompletion,
        carouselBarBuilder: (_, __, ___) => const SizedBox.shrink(),
      ),
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.text('A'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('NEXT'));
    await tester.pumpAndSettle();
    expect(find.text('A body'), findsOneWidget);

    await tester.tap(find.text('NEXT'));
    await tester.pumpAndSettle();
    expect(find.text('Thank you'), findsOneWidget);
    // Kept once, not duplicated as the old code did.
    expect(
        withCompletion.steps.where((step) => step.identifier == 'done').length,
        1);
  });

  testWidgets('BACK works on a step a rule navigated back to', (tester) async {
    // A rule sends the participant back to the first step - the visited steps
    // are what BACK follows, so standing on `steps.first` is not the end.
    final looping = RPNavigableOrderedTask(
      identifier: 'looping',
      steps: [
        RPInstructionStep(
            identifier: 'start', title: 'Start', text: 'the start body'),
        RPInstructionStep(
            identifier: 'second', title: 'Second', text: 'the second body'),
      ],
    )..setNavigationRuleForTriggerStepIdentifier(
        RPDirectStepNavigationRule(destinationStepIdentifier: 'start'),
        'second');

    await tester.pumpWidget(MaterialApp(
      theme: carpTheme,
      home: RPUITask(
        task: looping,
        carouselBarBuilder: (_, __, ___) => const SizedBox.shrink(),
      ),
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.text('NEXT'));
    await tester.pumpAndSettle();
    expect(find.text('the second body'), findsOneWidget);

    // Looped back to the first step.
    await tester.tap(find.text('NEXT'));
    await tester.pumpAndSettle();
    expect(find.text('the start body'), findsOneWidget);

    await tester.tap(find.text('BACK'));
    await tester.pumpAndSettle();
    expect(find.text('the second body'), findsOneWidget);
  });
}
