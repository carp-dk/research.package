part of '../../ui.dart';

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

  final Color? carouselBarBackgroundColor;

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
    this.carouselBarBackgroundColor,
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

          // In case of last step we save the result and close the task
          if (_currentStep == widget.task.steps.last) {
            createAndSendResult();
            if (widget.task.closeAfterFinished) {
              if (context.mounted) {
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

          // Find the next step and then navigate there
          setState(() {
            _currentStep = _activeSteps.last;
            _currentStep = widget.task.getStepAfterStep(_currentStep, null);
            if (_currentStep != null) _activeSteps.add(_currentStep!);
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
          // If the stepWidgets list only has 1 element it means the user is on
          // the first question, so no back navigation is enabled.
          if (_activeSteps.length == 1) {
            break;
          }
          if (_currentStep == widget.task.steps.first) {
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
    showDialog<dynamic>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(widget.task.isConsentTask
              ? RPLocalizations.of(context)?.translate('cancel_confirmation') ??
                  "Cancel?"
              : RPLocalizations.of(context)
                      ?.translate('discard_confirmation') ??
                  "Discard results and quit?"),
          actions: <Widget>[
            OutlinedButton(
              child: Text(
                RPLocalizations.of(context)?.translate('NO') ?? "NO",
                style: TextStyle(
                    color: ((CupertinoTheme.of(context).primaryColor ==
                            CupertinoColors.activeBlue)
                        ? Theme.of(context).primaryColor
                        : CupertinoTheme.of(context).primaryColor)),
              ),
              onPressed: () =>
                  Navigator.of(context).pop(), // Dismissing the pop-up
            ),
            ButtonTheme(
              minWidth: 70,
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                      (CupertinoTheme.of(context).primaryColor ==
                              CupertinoColors.activeBlue)
                          ? Theme.of(context).primaryColor
                          : CupertinoTheme.of(context).primaryColor),
                ),
                child: Text(
                  RPLocalizations.of(context)?.translate('YES') ?? "YES",
                  style: const TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  // Calling the onCancel method with which the developer can for
                  // e.g. save the result on the device.
                  // Only call it if it's not null
                  widget.onCancel?.call(_taskResult);
                  // Popup dismiss
                  Navigator.of(context).pop();
                  // Exit the Ordered Task
                  Navigator.of(context).pop();
                },
              ),
            ),
            OutlinedButton(
              child: Text(
                RPLocalizations.of(context)?.translate('YES') ?? "YES",
                style: TextStyle(
                    color: ((CupertinoTheme.of(context).primaryColor ==
                            CupertinoColors.activeBlue)
                        ? Theme.of(context).primaryColor
                        : CupertinoTheme.of(context).primaryColor)),
              ),
              onPressed: () {
                // Calling the onCancel method with which the developer can for
                // e.g. save the result on the device.
                // Only call it if it's not null
                widget.onCancel?.call(_taskResult);
                // Popup dismiss
                Navigator.of(context).pop();
                // Do not Exit the Ordered Task to let the user handle it
                // Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  Widget _carouselBar(RPLocalizations? locale) {
    return Container(
      color: widget.carouselBarBackgroundColor ??
          Theme.of(context).extension<CarpColors>()!.backgroundGray,
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
                      style: Theme.of(context).appBarTheme.titleTextStyle,
                      textAlign: TextAlign.center,
                    )
                  : Container(),
            ),
            // Close button
            Expanded(
              flex: 5,
              child: IconButton(
                padding: const EdgeInsets.only(right: 30),
                alignment: Alignment.centerRight,
                icon: Icon(
                  Icons.highlight_off,
                  color: ((CupertinoTheme.of(context).primaryColor ==
                          CupertinoColors.activeBlue)
                      ? Theme.of(context).primaryColor
                      : CupertinoTheme.of(context).primaryColor),
                ),
                onPressed: () => blocTask.sendStatus(RPStepStatus.Canceled),
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

    return PopScope<bool>(
      canPop: false,
      // removed again - see issue #141
      // onPopInvokedWithResult: (bool didPop, Object? result) async {
      //   return widget.onCancel?.call(_taskResult);
      // },
      child: Scaffold(
        backgroundColor:
            Theme.of(context).extension<CarpColors>()!.backgroundGray,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top bar
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

              // Bottom navigation
              if (![RPCompletionStep, RPVisualConsentStep, RPConsentReviewStep]
                  .contains(_currentStep.runtimeType))
                Padding(
                  padding:
                      const EdgeInsets.only(left: 15, right: 15, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // if first question or its a navigable task
                      _currentStepIndex == 0 || !_isNavigableTask
                          ? Container()
                          : OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  backgroundColor: (CupertinoTheme.of(context)
                                              .primaryColor ==
                                          CupertinoColors.activeBlue)
                                      ? Theme.of(context).primaryColor
                                      : CupertinoTheme.of(context)
                                          .primaryColor),
                              onPressed: () =>
                                  blocTask.sendStatus(RPStepStatus.Back),
                              child: Text(
                                locale?.translate('BACK') ?? 'BACK',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                      StreamBuilder<bool>(
                        stream: blocQuestion.questionReadyToProceed,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context)
                                      .extension<CarpColors>()!
                                      .primary),
                              onPressed: snapshot.data!
                                  ? () {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      blocTask
                                          .sendStatus(RPStepStatus.Finished);
                                    }
                                  : null,
                              child: Text(
                                style: const TextStyle(color: Colors.white),
                                RPLocalizations.of(context)
                                        ?.translate('NEXT') ??
                                    "NEXT",
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
