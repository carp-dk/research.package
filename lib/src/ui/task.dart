part of '../../ui.dart';

/// Signature for building a replacement for the default carousel bar shown at
/// the top of an [RPUITask].
///
/// [stepIndex] is the zero-based index of the step currently on screen.
/// [stepCount] is the number of steps in the task — for an
/// [RPNavigableOrderedTask] not every step is necessarily shown, so it is an
/// upper bound rather than an exact total.
typedef RPCarouselBarBuilder = Widget Function(
  BuildContext context,
  int stepIndex,
  int stepCount,
);

/// Signature for building a replacement for the default bottom navigation shown
/// at the bottom of an [RPUITask].
///
/// [navigation] carries the actions of the task — advancing, going back and
/// cancelling — so a custom bar drives the task the same way the default one
/// does. See [RPTaskNavigation].
typedef RPBottomNavigationBuilder = Widget Function(
  BuildContext context,
  RPTaskNavigation navigation,
);

/// The navigation of an [RPUITask], handed to an [RPBottomNavigationBuilder].
///
/// It exposes what the default bottom bar does — advance, go back, cancel —
/// together with the state those actions depend on, so that a custom bar can be
/// built without reaching into the task's internals.
class RPTaskNavigation {
  /// Advances to the next step, or `null` while the current step is not ready
  /// to be left — an unanswered question, typically.
  ///
  /// Passing it straight to a button's `onPressed` therefore disables the
  /// button until the step is answered.
  final VoidCallback? onNext;

  /// Returns to the previous step, or `null` on the first step of the task,
  /// where there is nothing to go back to.
  ///
  /// Note that the default bar is stricter than this: it only offers BACK in an
  /// [RPNavigableOrderedTask]. A custom bar may offer it in a linear task too.
  final VoidCallback? onBack;

  /// Cancels the task, after asking the participant to confirm in a dialog.
  ///
  /// This is what the close button of the default carousel bar does. To end the
  /// task without confirmation, call [RPUITask.onCancel] directly and pop the
  /// route.
  final VoidCallback onCancel;

  /// Whether the current step is ready to be left, i.e. whether [onNext] is
  /// non-null.
  final bool canProceed;

  /// The step currently on screen.
  ///
  /// The default bar draws nothing on an [RPCompletionStep],
  /// [RPVisualConsentStep] or [RPConsentReviewStep], since those steps carry
  /// their own buttons. A custom bar is built on every step instead, and can
  /// use this to make the same choice.
  final RPStep? currentStep;

  /// The zero-based index of [currentStep].
  final int stepIndex;

  /// The number of steps in the task — for an [RPNavigableOrderedTask] not
  /// every step is necessarily shown, so it is an upper bound rather than an
  /// exact total.
  final int stepCount;

  const RPTaskNavigation({
    required this.onNext,
    required this.onBack,
    required this.onCancel,
    required this.canProceed,
    required this.currentStep,
    required this.stepIndex,
    required this.stepCount,
  });
}

/// This class is the primary entry point for the presentation of the Research
/// Package framework UI.
/// It presents the steps of an [RPOrderedTask] (either navigable or just linear)
/// and then provides the [RPTaskResult] object.
class RPUITask extends StatefulWidget {
  /// The task to present. It can be either an [RPOrderedTask] or an [RPNavigableOrderedTask].
  /// The [RPUITask] presents its steps after each other and creates an [RPTaskResult]
  /// object with the same identifier as the [task]'s identifier.
  final RPOrderedTask task;

  final Image? carouselBarImage;

  final double? carouselBarHorizontalPadding;
  final double? carouselBarVerticalPadding;

  final Color? carouselBarBackgroundColor;

  /// Builds a replacement for the default carousel bar at the top of the task.
  ///
  /// When `null` the default bar is shown — logo, "x of y" progress and a close
  /// button — configured through [carouselBarImage],
  /// [carouselBarHorizontalPadding], [carouselBarVerticalPadding] and
  /// [carouselBarBackgroundColor]. Those four are ignored when a builder is
  /// supplied, since the builder owns the whole bar.
  ///
  /// Return `const SizedBox.shrink()` to remove the bar entirely.
  ///
  /// Note that the default bar holds the only built-in way to cancel a task, so
  /// a replacement should provide its own affordance — either
  /// `blocTask.sendStatus(RPStepStatus.Canceled)` to cancel directly, or
  /// [RPUITaskState.showCancelConfirmationDialog] to confirm first.
  final RPCarouselBarBuilder? carouselBarBuilder;

  /// Builds a replacement for the default bottom navigation of the task.
  ///
  /// When `null` the default row is shown — a BACK button in a navigable task
  /// and a NEXT button, configured through [nextButtonText] and
  /// [nextButtonStyle]. Those two are ignored when a builder is supplied, since
  /// the builder owns the whole row.
  ///
  /// Return `const SizedBox.shrink()` to remove the row entirely.
  ///
  /// The default row hides itself on the steps which carry their own buttons
  /// ([RPCompletionStep], [RPVisualConsentStep] and [RPConsentReviewStep]); the
  /// builder is called on every step instead, with
  /// [RPTaskNavigation.currentStep] telling it which one is on screen.
  final RPBottomNavigationBuilder? bottomNavigationBuilder;

  /// Text for the button that advances to the next step.
  ///
  /// May be a localization key or a literal — anything the localizations do
  /// not recognise is shown as-is.
  ///
  /// When `null` the localized `'NEXT'` key is used, falling back to `"NEXT"`.
  /// Applies to every step; a step's own [RPStep.nextButtonText] wins over it.
  final String? nextButtonText;

  /// Style for the button that advances to the next step.
  ///
  /// Properties set here win. Anything left null falls back to the default —
  /// a [CarpColors.primary] background — and then to the ambient
  /// [ElevatedButtonThemeData], so overriding only `shape` keeps the default
  /// colour. Pass a `backgroundColor` to change the colour too.
  ///
  /// The label is drawn white unless a `foregroundColor` is given here.
  final ButtonStyle? nextButtonStyle;

  /// The callback function which has to return an [RPTaskResult] object.
  /// This function is called when the participant has finished the last step.
  final void Function(RPTaskResult)? onSubmit;

  /// The callback function which has to return an [RPTaskResult] object.
  /// This function is called when the participant cancels a survey. The result parameter is optional so if you don't want to do grab the result as part of the callback function you can do so, like the following:
  ///
  /// ```
  /// onCancel: ([result]) {
  ///        cancelCallBack();
  ///      },
  /// ```
  ///
  /// It's optional. If not provided (is `null`) the survey just stops
  /// without doing anything with the result.
  final void Function(RPTaskResult? result)? onCancel;

  const RPUITask({
    super.key,
    required this.task,
    this.carouselBarImage,
    this.carouselBarHorizontalPadding,
    this.carouselBarVerticalPadding,
    this.carouselBarBackgroundColor,
    this.carouselBarBuilder,
    this.bottomNavigationBuilder,
    this.nextButtonText,
    this.nextButtonStyle,
    this.onSubmit,
    this.onCancel,
  });

  @override
  RPUITaskState createState() => RPUITaskState();
}

class RPUITaskState extends State<RPUITask> with CanSaveResult {
  RPTaskResult? _taskResult;

  /// A list of actual steps to show in the task.
  ///
  /// If the task is a [RPNavigableOrderedTask] not all the questions necessarily
  /// show up because of branching, i.e., some questions could be skipped based
  /// on previous answers.
  ///
  /// It is a dynamic list which grows and shrinks according to the forward of
  /// back navigation of the task.
  final List<RPStep> _activeSteps = [];

  RPStep? _currentStep;
  int _currentStepIndex = 0;
  int _currentQuestionIndex = 1;

  StreamSubscription<RPStepStatus>? _stepStatusSubscription;
  StreamSubscription<RPResult>? _stepResultSubscription;

  final PageController _taskPageViewController =
      PageController(keepPage: false);

  bool _isNavigableTask = false;

  @override
  void initState() {
    super.initState();
    // Instantiate the task result so it starts tracking time
    _taskResult = RPTaskResult(identifier: widget.task.identifier);

    // If it's navigable we don't want to show result on app bar
    if (widget.task is RPNavigableOrderedTask) {
      blocTask.updateTaskProgress(RPTaskProgress(0, widget.task.steps.length));
      _isNavigableTask = true;
    } else {
      // Sending the initial Task Progress so the Question UI can use it in the app bar
      blocTask.updateTaskProgress(RPTaskProgress(
          _currentQuestionIndex, widget.task.numberOfQuestionSteps));
    }

    // Subscribe to step status changes so the navigation can be triggered
    _stepStatusSubscription = blocTask.stepStatus.listen((status) async {
      switch (status) {
        case RPStepStatus.Finished:
        case RPStepStatus.Skipped:
          // For now, the same thing has to happen whether a step is finished or skipped.
          // But the "Skipped" status is included to cover this case also.

          // Whether the task is over is the task's answer to give: a navigation
          // rule may route on from the step that happens to be last in the
          // list, and may route to it long before the end.
          RPStep? nextStep =
              widget.task.getStepAfterStep(_activeSteps.last, null);

          // On the last step we save the result and close the task - unless the
          // task is the only route (e.g. a redirect target), in which case
          // onSubmit decides where to go.
          if (nextStep == null) {
            createAndSendResult();
            if (widget.task.closeAfterFinished) {
              if (context.mounted && Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            }
            break;
          }
          _currentStep?.timer?.cancel();
          // Updating taskProgress stream
          if (_currentStep.runtimeType == RPQuestionStep) {
            _currentQuestionIndex++;
            if (!_isNavigableTask) {
              blocTask.updateTaskProgress(RPTaskProgress(
                  _currentQuestionIndex, widget.task.numberOfQuestionSteps));
            }
          }

          setState(() {
            _currentStep = nextStep;
            _activeSteps.add(nextStep);
          });
          _currentStepIndex++;

          _taskPageViewController.nextPage(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut);
          break;
        case RPStepStatus.Canceled:
          showCancelConfirmationDialog();
          break;
        case RPStepStatus.Back:
          // The visited steps are the only thing back navigation depends on:
          // with a single one there is nothing to go back to. Comparing against
          // `task.steps.first` instead would strand any step a navigation rule
          // moved to the front of the task.
          if (_activeSteps.length == 1) {
            break;
          } else {
            _currentQuestionIndex--;
            _currentStepIndex--;
            if (!_isNavigableTask) {
              blocTask.updateTaskProgress(RPTaskProgress(
                  _currentQuestionIndex, widget.task.numberOfQuestionSteps));
            }
            // await because it can only update the stepWidgets list while the current step is out of the screen
            await _taskPageViewController.previousPage(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut);

            setState(() {
              _activeSteps.removeLast();
              _currentStep = _activeSteps.last;
            });
          }
          blocQuestion.sendReadyToProceed(true);
          break;
        case RPStepStatus.Ongoing:
          break;
      }
    });

    _stepResultSubscription = blocTask.stepResult.listen((stepResult) {
      if (_taskResult != null) {
        _taskResult?.setStepResultForIdentifier(
            stepResult.identifier, stepResult);
        blocTask.updateTaskResult(_taskResult!);
      }
    });

    setState(() {
      // Getting the first step
      _currentStep = widget.task.getStepAfterStep(null, null);
      if (_currentStep != null) _activeSteps.add(_currentStep!);
    });
  }

  @override
  createAndSendResult() {
    // Populate the result object with value and end the time tracker (set endDate)
    _taskResult?.endDate = DateTime.now();
    RPTaskResult? translatedTaskResult;
    if (RPLocalizations.of(context) != null && _taskResult != null) {
      translatedTaskResult =
          _translateTaskResult(RPLocalizations.of(context)!, _taskResult!);
    }
    translatedTaskResult?.startDate = _taskResult?.startDate;
    translatedTaskResult?.endDate = _taskResult?.endDate;
    widget.onSubmit?.call(translatedTaskResult ?? _taskResult!);
  }

  void showCancelConfirmationDialog() {
    // A consent form has no answers to lose, so it says what is actually at
    // stake: leaving without having consented.
    final key =
        widget.task.isConsentTask ? 'cancel_confirmation' : 'discard_confirmation';

    showDialog<dynamic>(
      context: context,
      // Tapping outside keeps the task, which is the safe outcome.
      builder: (BuildContext context) {
        final locale = RPLocalizations.of(context);
        return AlertDialog(
          title: Text(locale?.translate(key) ??
              (widget.task.isConsentTask
                  ? "Leave consent form?"
                  : "Leave survey?")),
          content: Text(locale?.translate('${key}_body') ??
              (widget.task.isConsentTask
                  ? "You have not given your consent yet."
                  : "Your answers will not be saved.")),
          actions: <Widget>[
            OutlinedButton(
              onPressed: () =>
                  Navigator.of(context).pop(), // Dismissing the pop-up
              child: Text(locale?.translate('CANCEL') ?? "CANCEL"),
            ),
            FilledButton(
              onPressed: () {
                // Calling the onCancel method with which the developer can for
                // e.g. save the result on the device.
                // Only call it if it's not null
                widget.onCancel?.call(_taskResult);
                // Popup dismiss
                Navigator.of(context).pop();
                // Exit the Ordered Task - if the task is the only route
                // (e.g. a redirect target), onCancel decides where to go.
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              },
              child: Text(locale?.translate('LEAVE') ?? "LEAVE"),
            ),
          ],
        );
      },
    );
  }

  /// Label for the Next button.
  ///
  /// The current step's [RPStep.nextButtonText] wins over the task-wide
  /// [RPUITask.nextButtonText]; with neither set the `'NEXT'` key is used.
  /// Either value may be a localization key or a literal — [translate] returns
  /// anything it does not recognise unchanged.
  String _nextButtonLabel(RPLocalizations? locale) {
    final custom =
        _currentStep?.nextButtonText ?? widget.nextButtonText ?? 'NEXT';
    return locale?.translate(custom) ?? custom;
  }

  /// The navigation handed to [RPUITask.bottomNavigationBuilder]. [canProceed]
  /// comes from the same stream the default Next button listens to.
  RPTaskNavigation _navigation(bool canProceed) => RPTaskNavigation(
        onNext: canProceed
            ? () {
                FocusManager.instance.primaryFocus?.unfocus();
                blocTask.sendStatus(RPStepStatus.Finished);
              }
            : null,
        // Offered whenever there is a step to go back to, unlike the default
        // bar, which offers BACK in navigable tasks only.
        onBack: _activeSteps.length > 1
            ? () => blocTask.sendStatus(RPStepStatus.Back)
            : null,
        onCancel: () => blocTask.sendStatus(RPStepStatus.Canceled),
        canProceed: canProceed,
        currentStep: _currentStep,
        stepIndex: _currentStepIndex,
        stepCount: widget.task.steps.length,
      );

  Widget _carouselBar(RPLocalizations? locale) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: widget.carouselBarHorizontalPadding ?? 0,
        vertical: widget.carouselBarVerticalPadding ?? 0,
      ),
      color: widget.carouselBarBackgroundColor ??
          Theme.of(context).scaffoldBackgroundColor,
      child: SizedBox(
        height: AppBar().preferredSize.height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 5,
              child: widget.carouselBarImage ??
                  Image.asset(
                    'assets/icons/carp_logo_example.png',
                    package: 'research_package',
                    fit: BoxFit.contain,
                    height: 16,
                  ),
            ),
            // Carousel indicator
            Expanded(
              flex: 2,
              child: (!_isNavigableTask)
                  ? Text(
                      '${_currentStepIndex + 1} '
                      '${locale?.translate('of') ?? 'of'} '
                      '${widget.task.steps.length}',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontSize: 18),
                      textAlign: TextAlign.center,
                    )
                  : Container(),
            ),
            // Close button. A consent flow has none - a screen explaining an
            // upcoming permission request may offer no way out but the system
            // alert (Apple HIG, Privacy) - and is left with DISAGREE instead.
            // The empty slot keeps the carousel indicator in place.
            Expanded(
              flex: 5,
              child: widget.task.isConsentTask
                  ? const SizedBox.shrink()
                  : IconButton(
                      padding: const EdgeInsets.only(right: 30),
                      alignment: Alignment.centerRight,
                      icon: Icon(
                        Icons.highlight_off,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () =>
                          blocTask.sendStatus(RPStepStatus.Canceled),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    RPLocalizations? locale = RPLocalizations.of(context);

    // Back is only offered part-way through a navigable task.
    final showBackButton = _currentStepIndex != 0 && _isNavigableTask;

    return PopScope<bool>(
      canPop: false,
      // removed again - see issue #141
      // onPopInvokedWithResult: (bool didPop, Object? result) async {
      //   return widget.onCancel?.call(_taskResult);
      // },
      child: Scaffold(
        backgroundColor:
            Theme.of(context).scaffoldBackgroundColor,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top bar — a custom builder replaces the default bar entirely.
              widget.carouselBarBuilder?.call(
                    context,
                    _currentStepIndex,
                    widget.task.steps.length,
                  ) ??
                  _carouselBar(locale),
              // Body
              Expanded(
                child: PageView.builder(
                  itemBuilder: (BuildContext context, int position) =>
                      _activeSteps[position].stepWidget,
                  itemCount: _activeSteps.length,
                  controller: _taskPageViewController,
                  physics: const NeverScrollableScrollPhysics(),
                ),
              ),

              // Bottom navigation — a custom builder replaces the default row
              // and is built on every step, including the ones it hides on.
              if (widget.bottomNavigationBuilder != null)
                StreamBuilder<bool>(
                  stream: blocQuestion.questionReadyToProceed,
                  builder: (context, snapshot) =>
                      widget.bottomNavigationBuilder!(
                    context,
                    _navigation(snapshot.data ?? false),
                  ),
                )
              else if (!(_currentStep is RPCompletionStep ||
                  _currentStep is RPVisualConsentStep ||
                  _currentStep is RPConsentReviewStep))
                Padding(
                  padding:
                      const EdgeInsets.only(left: 15, right: 15, bottom: 10),
                  child: Row(
                    // Without a Back button, `spaceBetween` would push a lone
                    // Next button to the trailing edge — centre it instead.
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // if first question or its a navigable task
                      !showBackButton
                          ? Container()
                          : OutlinedButton(
                              onPressed: () =>
                                  blocTask.sendStatus(RPStepStatus.Back),
                              child: Text(locale?.translate('BACK') ?? 'BACK'),
                            ),
                      StreamBuilder<bool>(
                        stream: blocQuestion.questionReadyToProceed,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            // Caller's style wins; anything it leaves null
                            // falls back to the default background colour.
                            final defaultNextStyle = ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).colorScheme.primary);
                            return ElevatedButton(
                              style:
                                  widget.nextButtonStyle?.merge(
                                        defaultNextStyle,
                                      ) ??
                                      defaultNextStyle,
                              onPressed: snapshot.data!
                                  ? () {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      blocTask
                                          .sendStatus(RPStepStatus.Finished);
                                    }
                                  : null,
                              child: Text(
                                // Historically always white; defer to the
                                // caller when they set a foreground colour.
                                style:
                                    widget.nextButtonStyle?.foregroundColor ==
                                        null
                                    ? const TextStyle(color: Colors.white)
                                    : null,
                                _nextButtonLabel(locale),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  dispose() {
    _stepStatusSubscription?.cancel();
    _stepResultSubscription?.cancel();
    _taskPageViewController.dispose();
    super.dispose();
  }

  /// Translates the [taskResult] values to the specified [locale],
  /// which was used during the task.
  RPTaskResult _translateTaskResult(
    RPLocalizations locale,
    RPTaskResult taskResult,
  ) {
    RPTaskResult translatedTaskResult =
        RPTaskResult(identifier: taskResult.identifier);
    // For each step result in the task
    for (MapEntry<String, RPResult> mapEntry in taskResult.results.entries) {
      if (mapEntry.value is RPStepResult) {
        // Translate answer format
        RPStepResult stepResult = mapEntry.value as RPStepResult;
        RPAnswerFormat translatedAnswerFormat =
            _translateAnswerFormat(locale, stepResult.answerFormat);

        // Create step result to fill with answers
        RPStepResult translatedResult = RPStepResult(
            identifier: stepResult.identifier,
            questionTitle: stepResult.questionTitle,
            answerFormat: translatedAnswerFormat);

        // For each answer in the map
        for (MapEntry<String, dynamic> resultEntry
            in stepResult.results.entries) {
          if (stepResult.answerFormat.runtimeType == RPFormAnswerFormat) {
            translatedResult.setResultForIdentifier(
                resultEntry.key, _translateResult(locale, resultEntry.value));
          } else {
            translatedResult
                .setResult(_translateResult(locale, resultEntry.value));
          }
        }

        translatedTaskResult.setStepResultForIdentifier(
            mapEntry.key, translatedResult);
      } else {
        // if mapEntry.value is RPConsentSignatureResult
        // which is handled in the RPUIConsentReviewStep.
        // Other result types are also transferred.
        translatedTaskResult.setStepResultForIdentifier(
            mapEntry.key, mapEntry.value);
      }
    }
    return translatedTaskResult;
  }

  RPAnswerFormat _translateAnswerFormat(
      RPLocalizations locale, RPAnswerFormat answerFormat) {
    switch (answerFormat.runtimeType) {
      case const (RPIntegerAnswerFormat):
        answerFormat as RPIntegerAnswerFormat;
        return RPIntegerAnswerFormat(
            maxValue: answerFormat.maxValue,
            minValue: answerFormat.minValue,
            suffix: (answerFormat.suffix == null)
                ? null
                : locale.translate(answerFormat.suffix!));

      case const (RPChoiceAnswerFormat):
        answerFormat as RPChoiceAnswerFormat;
        List<RPChoice> translatedRPChoices = [];
        for (RPChoice choice in answerFormat.choices) {
          translatedRPChoices.add(RPChoice(
              text: locale.translate(choice.text),
              value: choice.value,
              detailText: choice.detailText == null
                  ? null
                  : locale.translate(choice.detailText!),
              isFreeText: choice.isFreeText));
        }
        return RPChoiceAnswerFormat(
            answerStyle: answerFormat.answerStyle,
            choices: translatedRPChoices);

      case const (RPSliderAnswerFormat):
        answerFormat as RPSliderAnswerFormat;
        return RPSliderAnswerFormat(
            minValue: answerFormat.minValue,
            maxValue: answerFormat.maxValue,
            divisions: answerFormat.divisions,
            suffix: (answerFormat.suffix == null)
                ? null
                : locale.translate(answerFormat.suffix!),
            prefix: (answerFormat.prefix == null)
                ? null
                : locale.translate(answerFormat.prefix!));

      case const (RPImageChoiceAnswerFormat):
        answerFormat as RPImageChoiceAnswerFormat;
        List<RPImageChoice> translatedImageChoices = [];
        for (RPImageChoice imageChoice in answerFormat.choices) {
          translatedImageChoices.add(RPImageChoice(
              imageUrl: imageChoice.imageUrl,
              description: locale.translate(imageChoice.description),
              key: imageChoice.key,
              value: imageChoice.value));
        }
        return RPImageChoiceAnswerFormat(choices: translatedImageChoices);

      // case RPDateTimeAnswerFormat:
      //   answerFormat as RPDateTimeAnswerFormat;
      //   return RPDateTimeAnswerFormat();
      // case RPTextAnswerFormat:
      //   answerFormat as RPTextAnswerFormat;
      //   return RPTextAnswerFormat();
      default:
        return answerFormat;
    }
  }

  dynamic _translateResult(RPLocalizations locale, dynamic value) {
    switch (value.runtimeType) {
      case const (RPImageChoice):
        value as RPImageChoice;
        return RPImageChoice(
            imageUrl: value.imageUrl,
            description: value.description,
            key: value.key,
            value: value.value);
      case const (RPChoice):
        value as RPChoice;
        return RPChoice(
            text: locale.translate(value.text),
            value: value.value,
            detailText: value.detailText == null
                ? null
                : locale.translate(value.detailText!),
            isFreeText: value.isFreeText);
      case const (List<RPChoice>):
        value as List;
        return value.map((e) => _translateResult(locale, e)).toList();
      default:
        return value;
    }
  }
}
