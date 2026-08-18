part of '../../ui.dart';

/// The UI representation of the [RPQuestionStep].
///
/// This widget is the container, the concrete content depends on the input
/// step's [RPAnswerFormat].
///
/// As soon as the participant has finished with the question the [RPStepResult]
/// is being added to the [RPTaskResult]'s result list.
class RPUIQuestionStep extends StatefulWidget {
  final RPQuestionStep step;

  const RPUIQuestionStep(this.step, {super.key});

  @override
  RPUIQuestionStepState createState() => RPUIQuestionStepState();
}

class RPUIQuestionStepState extends State<RPUIQuestionStep> with CanSaveResult {
  // dynamic because we don't know what value the RPChoice will have
  dynamic _currentQuestionBodyResult;
  RPStepResult? result;
  RPTaskProgress? recentTaskProgress;
  int timeInSeconds = 0;
  Timer? timer;

  set currentQuestionBodyResult(dynamic currentQuestionBodyResult) {
    _currentQuestionBodyResult = currentQuestionBodyResult;
    createAndSendResult();
    if (_currentQuestionBodyResult != null) {
      blocQuestion.sendReadyToProceed(true);
    } else {
      blocQuestion.sendReadyToProceed(false);
    }
  }

  void skipQuestion() {
    timer?.cancel();

    FocusManager.instance.primaryFocus?.unfocus();
    blocTask.sendStatus(RPStepStatus.Skipped);
    currentQuestionBodyResult = null;
  }

  @override
  void initState() {
    super.initState();

    if (timeInSeconds <= 0) {
      timeInSeconds = widget.step.timeout.inSeconds;
      const oneSec = Duration(seconds: 1);
      timer = Timer.periodic(oneSec, (t) {
        if (mounted) {
          setState(() {
            timeInSeconds--;
          });
        }
        if (widget.step.autoSkip) {
          t.cancel();
          skipQuestion();
        }
      });
    }

    // Create the result object here to record the start time
    result = RPStepResult(
        identifier: widget.step.identifier,
        questionTitle: widget.step.title,
        answerFormat: widget.step.answerFormat);
    blocQuestion.sendReadyToProceed(false);
    recentTaskProgress = blocTask.lastProgressValue;
  }

  @override
  void deactivate() {
    timer?.cancel();
    super.deactivate();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  // Returning the according step body widget based on the answerFormat of the step
  Widget stepBody(RPAnswerFormat answerFormat) {
    switch (answerFormat.runtimeType) {
      case const (RPIntegerAnswerFormat):
        return RPUIIntegerQuestionBody((answerFormat as RPIntegerAnswerFormat),
            (result) {
          currentQuestionBodyResult = result;
        });
      case const (RPDoubleAnswerFormat):
        return RPUIDoubleQuestionBody((answerFormat as RPDoubleAnswerFormat),
            (result) {
          currentQuestionBodyResult = result;
        });
      case const (RPChoiceAnswerFormat):
        return RPUIChoiceQuestionBody((answerFormat as RPChoiceAnswerFormat),
            (result) {
          currentQuestionBodyResult = result;
        });
      case const (RPSliderAnswerFormat):
        return RPUISliderQuestionBody((answerFormat as RPSliderAnswerFormat),
            (result) {
          currentQuestionBodyResult = result;
        });
      case const (RPImageChoiceAnswerFormat):
        return RPUIImageChoiceQuestionBody(
            (answerFormat as RPImageChoiceAnswerFormat), (result) {
          currentQuestionBodyResult = result;
        });
      case const (RPStarChoiceAnswerFormat):
        return RPUIStarChoiceQuestionBody(
            (answerFormat as RPStarChoiceAnswerFormat), (result) {
          currentQuestionBodyResult = result;
        });
      case const (RPDateTimeAnswerFormat):
        return RPUIDateTimeQuestionBody(
            (answerFormat as RPDateTimeAnswerFormat), (result) {
          currentQuestionBodyResult = result;
        });
      case const (RPTextAnswerFormat):
        return RPUITextInputQuestionBody((answerFormat as RPTextAnswerFormat),
            (result) {
          currentQuestionBodyResult = result;
        });
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    RPLocalizations? locale = RPLocalizations.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(8),
                children: [
                  // Title
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 24, left: 8, right: 8, top: 0),
                    child: Text(
                      locale?.translate(widget.step.title) ?? widget.step.title,
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: stepBody(widget.step.answerFormat),
                  ),
                  widget.step.optional
                      ? TextButton(
                          onPressed: () => skipQuestion(),
                          child: Text(locale?.translate("Skip this question") ??
                              "Skip this question"),
                        )
                      : Container(),
                ],
              ),
            ),
            if (widget.step.footnote != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  locale?.translate(widget.step.footnote!) ??
                      widget.step.footnote!,
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

  @override
  void createAndSendResult() {
    timer?.cancel();

    if (result != null) {
      result?.questionTitle = widget.step.title;
      result?.setResult(_currentQuestionBodyResult);
      blocTask.sendStepResult(result!);
    }
  }
}
