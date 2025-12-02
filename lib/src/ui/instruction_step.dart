part of '../../ui.dart';

/// The UI representation of [RPInstructionStep]
///
/// In general, you don’t need to instantiate an instruction step widget directly.
/// Instead, add an instruction step to a task and present the task using a task widget.
/// When appropriate, the task widget instantiates the step widget for the step.
class RPUIInstructionStep extends StatefulWidget {
  final RPInstructionStep step;

  const RPUIInstructionStep({super.key, required this.step});

  @override
  RPUIInstructionStepState createState() => RPUIInstructionStepState();
}

class RPUIInstructionStepState extends State<RPUIInstructionStep> {
  late AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    blocQuestion.sendReadyToProceed(true);
    super.initState();
    player = AudioPlayer();
    player.setReleaseMode(ReleaseMode.stop);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        if (widget.step.audioPath != null) {
          if (widget.step.audioPath!.startsWith('http')) {
            await player.setSource(UrlSource(widget.step.audioPath!));
          } else {
            await player.setSource(AssetSource(widget.step.audioPath!));
          }
        }
      } catch (e) {
        print(e);
      }
    });
  }

  @override
  void dispose() {
    // Release all sources and dispose the player.
    player.dispose();
    super.dispose();
  }

  void _pushDetailTextRoute() {
    Navigator.of(context).push(
      MaterialPageRoute<dynamic>(
        builder: (context) {
          return _DetailTextRoute(
            title: widget.step.title,
            content: widget.step.detailText!,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    RPLocalizations? locale = RPLocalizations.of(context);
    return Scaffold(
      backgroundColor:
          Theme.of(context).extension<CarpColors>()!.backgroundGray,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // If image is provided show it
                    if (widget.step.imagePath != null)
                      Center(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: InstructionImage(
                              imagePath: widget.step.imagePath!),
                        ),
                      ),
                    if (widget.step.videoPath != null)
                      VideoApp(step: widget.step),
                    if (widget.step.audioPath != null)
                      AudioPlayerWidget(player: player),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 30, horizontal: 16),
                          child: Text(
                            locale?.translate(widget.step.text!) ??
                                widget.step.text!,
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                        if (widget.step.detailText != null)
                          TextButton(
                            style: TextButton.styleFrom(
                              textStyle: TextStyle(
                                color: (CupertinoTheme.of(context)
                                            .primaryColor ==
                                        CupertinoColors.activeBlue)
                                    ? Theme.of(context).primaryColor
                                    : CupertinoTheme.of(context).primaryColor,
                              ),
                            ),
                            onPressed: _pushDetailTextRoute,
                            child: Text(locale?.translate('learn_more') ??
                                "Learn more"),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (widget.step.footnote != null)
              Center(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    locale?.translate(widget.step.footnote!) ??
                        widget.step.footnote!,
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DetailTextRoute extends StatelessWidget {
  final String title;
  final String content;

  const _DetailTextRoute({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    RPLocalizations? locale = RPLocalizations.of(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 3),
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 30,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Text(locale?.translate('learn_more') ?? 'Learn more',
                    style: Theme.of(context).textTheme.headlineSmall),
              ],
            ),
            Expanded(
              child: Scrollbar(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      locale?.translate(content) ?? content,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
