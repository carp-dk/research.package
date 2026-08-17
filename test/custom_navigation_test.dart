import 'package:carp_themes_package/carp_themes_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:research_package/research_package.dart';

/// Verifies the point of [RPUITask.bottomNavigationBuilder]: the built-in row
/// can go away without the forward, back and cancel actions going with it.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  /// A linear task of two instruction steps followed by a completion step.
  ///
  /// Instruction steps are ready to be left as soon as they appear, so
  /// `canProceed` is toggled through [BlocQuestion.sendReadyToProceed] - what a
  /// question body does - instead of by answering a question.
  RPOrderedTask task() => RPOrderedTask(
        identifier: 'task',
        steps: [
          RPInstructionStep(
              identifier: 'first', title: 'First', text: 'First step'),
          RPInstructionStep(
              identifier: 'second', title: 'Second', text: 'Second step'),
          RPCompletionStep(
              identifier: 'done', title: 'Done', text: 'Thank you'),
        ],
      );

  /// The navigation handed to the builder on the latest build.
  late RPTaskNavigation navigation;

  /// The result the task was cancelled with, if it was.
  RPTaskResult? cancelledWith;
  bool cancelled = false;

  setUp(() {
    ResearchPackage.ensureInitialized();
    cancelled = false;
    cancelledWith = null;
  });

  /// A task with a custom bottom bar and no carousel bar, pushed on top of a
  /// home page so that cancelling it has a route to return to.
  Widget app({RPBottomNavigationBuilder? bottomNavigationBuilder}) =>
      MaterialApp(
        theme: carpTheme,
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () =>
                  Navigator.of(context).push(MaterialPageRoute<void>(
                builder: (_) => RPUITask(
                  task: task(),
                  carouselBarBuilder: (_, __, ___) => const SizedBox.shrink(),
                  bottomNavigationBuilder: bottomNavigationBuilder,
                  onCancel: (result) {
                    cancelled = true;
                    cancelledWith = result;
                  },
                ),
              )),
              child: const Text('start'),
            ),
          ),
        ),
      );

  /// A bottom bar of plain buttons wired to nothing but [RPTaskNavigation],
  /// recorded so the test can inspect it.
  Widget customBar(BuildContext context, RPTaskNavigation nav) {
    navigation = nav;
    return Row(
      children: [
        TextButton(
          onPressed: nav.onBack,
          child: const Text('my back'),
        ),
        TextButton(
          onPressed: nav.onNext,
          child: const Text('my next'),
        ),
        TextButton(
          onPressed: nav.onCancel,
          child: const Text('my cancel'),
        ),
      ],
    );
  }

  /// Pumps [widget] and enters the task.
  Future<void> startTask(WidgetTester tester, Widget widget) async {
    await tester.pumpWidget(widget);
    await tester.tap(find.text('start'));
    await tester.pumpAndSettle();
  }

  /// Whether the button labelled [label] is enabled.
  bool isEnabled(WidgetTester tester, String label) =>
      tester.widget<TextButton>(find.widgetWithText(TextButton, label)).onPressed !=
      null;

  testWidgets('a custom bar replaces the default one', (tester) async {
    await startTask(tester, app(bottomNavigationBuilder: customBar));

    expect(find.text('my next'), findsOneWidget);
    // The default row is gone entirely - the builder owns the whole thing.
    expect(find.text('NEXT'), findsNothing);
    expect(find.text('BACK'), findsNothing);
  });

  testWidgets('the custom Next and Back navigate the task', (tester) async {
    await startTask(tester, app(bottomNavigationBuilder: customBar));

    expect(find.text('First step'), findsOneWidget);
    // Nothing to go back to on the first step.
    expect(isEnabled(tester, 'my back'), isFalse);

    await tester.tap(find.text('my next'));
    await tester.pumpAndSettle();
    expect(find.text('Second step'), findsOneWidget);

    // Offered even in a linear task, where the default row shows no BACK.
    expect(isEnabled(tester, 'my back'), isTrue);
    await tester.tap(find.text('my back'));
    await tester.pumpAndSettle();
    expect(find.text('First step'), findsOneWidget);
  });

  testWidgets('Next is withheld while the step is not ready', (tester) async {
    await startTask(tester, app(bottomNavigationBuilder: customBar));

    // An instruction step is ready as soon as it is shown.
    expect(navigation.canProceed, isTrue);
    expect(navigation.onNext, isNotNull);

    // What a question body does while its question is unanswered.
    blocQuestion.sendReadyToProceed(false);
    await tester.pumpAndSettle();

    expect(navigation.canProceed, isFalse);
    expect(navigation.onNext, isNull);
    expect(isEnabled(tester, 'my next'), isFalse);
  });

  testWidgets('the custom Cancel confirms before ending the task',
      (tester) async {
    await startTask(tester, app(bottomNavigationBuilder: customBar));

    await tester.tap(find.text('my cancel'));
    await tester.pumpAndSettle();
    // The same confirmation the default close button shows.
    expect(find.text('Discard results and quit?'), findsOneWidget);
    expect(cancelled, isFalse);

    await tester.tap(find.text('YES'));
    await tester.pumpAndSettle();

    expect(cancelled, isTrue);
    expect(cancelledWith?.identifier, 'task');
    // Back on the page the task was started from.
    expect(find.text('start'), findsOneWidget);
  });

  testWidgets('the custom bar is built on steps the default row hides on',
      (tester) async {
    await startTask(tester, app(bottomNavigationBuilder: customBar));

    await tester.tap(find.text('my next'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('my next'));
    await tester.pumpAndSettle();

    // A completion step carries its own button, so the default row hides here.
    expect(navigation.currentStep, isA<RPCompletionStep>());
    expect(find.text('my next'), findsOneWidget);
  });

  testWidgets('without a builder the default row still hides on those steps',
      (tester) async {
    await startTask(tester, app());

    expect(find.text('NEXT'), findsOneWidget);
    await tester.tap(find.text('NEXT'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('NEXT'));
    await tester.pumpAndSettle();

    expect(find.text('Thank you'), findsOneWidget);
    expect(find.text('NEXT'), findsNothing);
  });
}
