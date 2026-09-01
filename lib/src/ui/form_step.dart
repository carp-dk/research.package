part of '../../ui.dart';

class RPUIFormStep extends StatefulWidget {
  final RPFormStep formStep;

  const RPUIFormStep(this.formStep, {super.key});

  @override
  RPUIFormStepState createState() => RPUIFormStepState();
}

class RPUIFormStepState extends State<RPUIFormStep> {
  bool readyToProceed = false;
  RPStepResult? stepResult;
  RPTaskProgress? recentTaskProgress;
  int timeInSeconds = 0;
  bool? timerFinished;

  // Since the QuestionBody's are sending null if they are not answered yet we
  // can loop through the results of the steps.
  // If any of the non-optional steps have a null-answer in the stepResult,
  // it means the user has not answered it and CANNOT go to the next step.
  void checkReadyToProceed() {
    if (stepResult == null) return;

    bool temp = true;
    for (var step in widget.formStep.questions) {
      if (!step.optional) {
        if (stepResult!.results.values.any((element) =>
            (element as RPStepResult).identifier == step.identifier &&
            element.results['answer'] == null)) {
          temp = false;
        }
      }
    }

    if (widget.formStep.forceWait) {
      if (timerFinished == false) {
        temp = false;
      }
    }

    setState(() {
      readyToProceed = temp;
    });
    createAndSendResult();
    blocQuestion.sendReadyToProceed(temp);
  }

  @override
  void initState() {
    // Create the result object here to record the start time
    stepResult = RPStepResult(
        identifier: widget.formStep.identifier,
        questionTitle: widget.formStep.title,
        answerFormat: widget.formStep.answerFormat);
    stepResult?.questionTitle =
        "Form Step - See titles for every question included";

    // Filling up the results with nulls
    for (var item in widget.formStep.questions) {
      stepResult?.setResultForIdentifier(
          item.identifier,
          RPStepResult(
            identifier: item.identifier,
            questionTitle: item.title,
            answerFormat: item.answerFormat,
          ));
      // Set each questionTitle here in case this question can be skipped.
      (stepResult?.results[item.identifier] as RPStepResult).questionTitle =
          item.title;
    }

    readyToProceed = false;
    blocQuestion.sendReadyToProceed(false);
    recentTaskProgress = blocTask.lastProgressValue;
    timerFinished = false;

    super.initState();

    if (widget.formStep.autoSkip) {
      timeInSeconds = widget.formStep.timeout.inSeconds;
      int previousTimeInSeconds = 0;
      const oneSec = Duration(seconds: 1);
      Timer.periodic(oneSec, (t) {
        widget.formStep.timer = t;
        if (mounted) {
          setState(() {
            previousTimeInSeconds = timeInSeconds;
            timeInSeconds--;
          });
        } else {
          t.cancel();
        }
        if (timeInSeconds <= 0) {
          timerFinished = true;
          t.cancel();
          if (widget.formStep.saveResultsOnAutoSkip) {
            submitQuestionWithTempResult();
          } else {
            skipQuestion();
          }
          blocQuestion.sendReadyToProceed(true);
          t.cancel();
        }
        // For some reason, when initializing this UIFormStep, it always does it
        // twice. Thus, we need to kill the second timer if it exists.
        if (previousTimeInSeconds == timeInSeconds) {
          t.cancel();
        }
      });
    }
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Builds the step body widget based on the answer format of each step.
  Widget stepBody(String id, RPAnswerFormat answerFormat) {
    switch (answerFormat.runtimeType) {
      case const (RPIntegerAnswerFormat):
        return RPUIIntegerQuestionBody((answerFormat as RPIntegerAnswerFormat),
            (result) {
          RPStepResult tempResult = stepResult?.results[id] as RPStepResult;
          tempResult.questionTitle = widget.formStep.questions
              .where((step) => step.identifier == id)
              .first
              .title;
          tempResult.setResult(result);

          checkReadyToProceed();
        });
      case const (RPDoubleAnswerFormat):
        return RPUIDoubleQuestionBody((answerFormat as RPDoubleAnswerFormat),
            (result) {
          RPStepResult tempResult = stepResult?.results[id] as RPStepResult;
          tempResult.questionTitle = widget.formStep.questions
              .where((step) => step.identifier == id)
              .first
              .title;
          tempResult.setResult(result);

          checkReadyToProceed();
        });
      case const (RPChoiceAnswerFormat):
        return RPUIChoiceQuestionBody((answerFormat as RPChoiceAnswerFormat),
            (result) {
          RPStepResult tempResult = stepResult?.results[id] as RPStepResult;
          tempResult.questionTitle = widget.formStep.questions
              .where((step) => step.identifier == id)
              .first
              .title;
          tempResult.setResult(result);

          checkReadyToProceed();
        });
      case const (RPSliderAnswerFormat):
        return RPUISliderQuestionBody((answerFormat as RPSliderAnswerFormat),
            (result) {
          RPStepResult tempResult = stepResult?.results[id] as RPStepResult;
          tempResult.questionTitle = widget.formStep.questions
              .where((step) => step.identifier == id)
              .first
              .title;
          tempResult.setResult(result);

          checkReadyToProceed();
        });
      case const (RPImageChoiceAnswerFormat):
        return RPUIImageChoiceQuestionBody(
            (answerFormat as RPImageChoiceAnswerFormat), (result) {
          RPStepResult tempResult = stepResult?.results[id] as RPStepResult;
          tempResult.questionTitle = widget.formStep.questions
              .where((step) => step.identifier == id)
              .first
              .title;
          tempResult.setResult(result);

          checkReadyToProceed();
        });
      case const (RPDateTimeAnswerFormat):
        return RPUIDateTimeQuestionBody(
            (answerFormat as RPDateTimeAnswerFormat), (result) {
          RPStepResult tempResult = stepResult?.results[id] as RPStepResult;
          tempResult.questionTitle = widget.formStep.questions
              .where((step) => step.identifier == id)
              .first
              .title;
          tempResult.setResult(result);

          checkReadyToProceed();
        });
      case const (RPTextAnswerFormat):
        return RPUITextInputQuestionBody((answerFormat as RPTextAnswerFormat),
            (result) {
          RPStepResult tempResult = stepResult?.results[id] as RPStepResult;
          tempResult.questionTitle = widget.formStep.questions
              .where((step) => step.identifier == id)
              .first
              .title;
          tempResult.setResult(result);
          stepResult?.results[id] = tempResult;

          checkReadyToProceed();
        });
      default:
        return Container();
    }
  }

  void skipQuestion() {
    FocusManager.instance.primaryFocus?.unfocus();

    if (stepResult != null) {
      for (var key in stepResult!.results.keys) {
        (stepResult?.results[key] as RPStepResult).setResult(null);
      }
    }
    blocTask.sendStatus(RPStepStatus.Skipped);
    createAndSendResult();
  }

  void submitQuestionWithTempResult() {
    FocusManager.instance.primaryFocus?.unfocus();
    blocTask.sendStatus(RPStepStatus.Finished);
    createAndSendResult();
  }

  Widget formItemBuilder(BuildContext context, int index) {
    RPLocalizations? locale = RPLocalizations.of(context);
    if (index == 0) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 24, left: 8, right: 8, top: 8),
        child: Text(
          locale?.translate(widget.formStep.title) ?? widget.formStep.title,
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.left,
        ),
      );
    }
    index -= 1;

    if (index == widget.formStep.questions.length) {
      return widget.formStep.optional
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () => skipQuestion(),
                child: Text(locale?.translate("Skip these questions") ??
                    "Skip these questions"),
              ),
            )
          : Container();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              locale?.translate(widget.formStep.questions[index].title) ??
                  widget.formStep.questions[index].title,
              // The form's own title is the headline; a question inside it is
              // one level down.
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: stepBody(
              widget.formStep.questions[index].identifier,
              widget.formStep.questions[index].answerFormat,
            ),
          ),
          const Divider(height: 24),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    RPLocalizations? locale = RPLocalizations.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemBuilder: formItemBuilder,
                itemCount: widget.formStep.questions.length + 2,
              ),
            ),
            if (widget.formStep.footnote != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  locale?.translate(widget.formStep.footnote!) ??
                      widget.formStep.footnote!,
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void createAndSendResult() {
    if (stepResult != null) blocTask.sendStepResult(stepResult!);
  }
}
