part of '../../ui.dart';

/// The UI representation of [RPCompletionStep]
///
/// Typically, you don’t need to instantiate a completion step widget directly. Instead, add a completion step to a task, and present the task with a task widget.
/// The task widget instantiates the step widget for the completion step.
class RPUICompletionStep extends StatefulWidget {
  final RPCompletionStep step;

  const RPUICompletionStep({super.key, required this.step});

  @override
  RPUICompletionStepState createState() => RPUICompletionStepState();
}

class RPUICompletionStepState extends State<RPUICompletionStep>
    with SingleTickerProviderStateMixin {
  Animation<double>? _scale;
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 350));
    _scale = Tween(begin: 0.3, end: 1.1)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_controller!);
    _controller?.forward();
  }

  @override
  Widget build(BuildContext context) {
    RPLocalizations? locale = RPLocalizations.of(context);
    return Scaffold(
      backgroundColor:
          Theme.of(context).extension<CarpColors>()!.backgroundGray,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  locale?.translate(widget.step.title) ?? widget.step.title,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      locale?.translate(widget.step.text!) ?? widget.step.text!,
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            ScaleTransition(
              scale: _scale!,
              child: Image.asset(
                'assets/icons/checkmark.png',
                package: 'research_package',
                height: 120,
                width: 120,
              ),
            ),
            ButtonTheme(
              buttonColor: Theme.of(context).extension<CarpColors>()!.primary,
              minWidth: 150,
              child: OutlinedButton(
                onPressed: () {
                  blocTask.sendStatus(RPStepStatus.Finished);
                },
                child: Text(
                  RPLocalizations.of(context)?.translate('DONE') ?? "DONE",
                  style: TextStyle(
                    color: (CupertinoTheme.of(context).primaryColor ==
                            CupertinoColors.activeBlue)
                        ? Theme.of(context).primaryColor
                        : CupertinoTheme.of(context).primaryColor,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
