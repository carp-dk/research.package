part of '../../ui.dart';

/// The UI representation of [RPVisualConsentStep]
///
/// In general, you don’t need to instantiate an visual consent step widget directly.
/// Instead, add an visual consent step to a task and present the task using a task widget.
/// When appropriate, the task widget instantiates the visual consent step widget for the step.
class RPUIVisualConsentStep extends StatefulWidget {
  const RPUIVisualConsentStep({super.key, required this.consentDocument});
  final RPConsentDocument consentDocument;

  @override
  RPUIVisualConsentStepState createState() => RPUIVisualConsentStepState();
}

class RPUIVisualConsentStepState extends State<RPUIVisualConsentStep>
    with SingleTickerProviderStateMixin {
  int _pageNr = 0;
  int _totalPages = 0;
  bool _lastPage = false;

  @override
  void initState() {
    super.initState();
    _totalPages = widget.consentDocument.sections.length;
  }

  void _goToNextPage(int pageNr) {
    setState(() {
      _pageNr = pageNr;
      if (_pageNr == widget.consentDocument.sections.length - 1) {
        _lastPage = true;
      }
    });
  }

  void _pushContent(String title, String content) {
    Navigator.of(context).push(
      MaterialPageRoute<dynamic>(
        builder: (context) => _DetailTextRoute(
          title: title,
          content: content,
        ),
      ),
    );
  }

  void _showCancelDialog() {
    showDialog<dynamic>(
      context: context,
      builder: (context) {
        RPLocalizations? locale = RPLocalizations.of(context);
        return AlertDialog(
          content: Text(locale?.translate('quit_confirmation') ??
              "Are you sure you want to quit?"),
          actions: <Widget>[
            OutlinedButton(
              child: Text(
                locale?.translate('NO') ?? "NO",
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              onPressed: () => Navigator.of(context).pop(), // Pop the popup,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).extension<CarpColors>()!.primary),
              child: Text(
                RPLocalizations.of(context)?.translate('YES') ?? 'YES',
                style: Theme.of(context).primaryTextTheme.labelLarge,
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Pop the popup
                Navigator.of(context).pop(); // Pop the screen
              },
            ),
          ],
        );
      },
    );
  }

  Widget _illustrationForType(RPConsentSection section) {
    const double iconSize = 80.0;
    // const double largeIconSize = 200.0;

    switch (section.type) {
      case RPConsentSectionType.Overview:
        return Image.asset(
          'assets/icons/handshake.png',
          package: 'research_package',
          width: iconSize,
          height: iconSize,
        );
      case RPConsentSectionType.DataUse:
        return Image.asset(
          'assets/icons/document.png',
          package: 'research_package',
          width: iconSize,
          height: iconSize,
        );
      case RPConsentSectionType.TimeCommitment:
        return Image.asset(
          'assets/icons/deadline.png',
          package: 'research_package',
          width: iconSize,
          height: iconSize,
        );
      case RPConsentSectionType.StudySurvey:
        return Image.asset(
          'assets/icons/analysis.png',
          package: 'research_package',
          width: iconSize,
          height: iconSize,
        );
      case RPConsentSectionType.Withdrawing:
        return Image.asset(
          'assets/icons/networking.png',
          package: 'research_package',
          width: iconSize,
          height: iconSize,
        );
      case RPConsentSectionType.Custom:
        return section.customIllustration ?? Container();
      case RPConsentSectionType.DataGathering:
        return Image.asset(
          'assets/icons/management.png',
          package: 'research_package',
          width: iconSize,
          height: iconSize,
        );
      case RPConsentSectionType.Privacy:
        return Image.asset(
          'assets/icons/archive.png',
          package: 'research_package',
          width: iconSize,
          height: iconSize,
        );
      case RPConsentSectionType.StudyTasks:
        return Image.asset(
          'assets/icons/task.png',
          package: 'research_package',
          width: iconSize,
          height: iconSize,
        );
      case RPConsentSectionType.Welcome:
        return Image.asset(
          'assets/icons/handshake.png',
          package: 'research_package',
          width: iconSize,
          height: iconSize,
        );
      case RPConsentSectionType.AboutUs:
        return Image.asset(
          'assets/icons/id.png',
          package: 'research_package',
          width: iconSize,
          height: iconSize,
        );
      case RPConsentSectionType.Goals:
        return Image.asset(
          'assets/icons/target.png',
          package: 'research_package',
          width: iconSize,
          height: iconSize,
        );
      case RPConsentSectionType.Benefits:
        return Image.asset(
          'assets/icons/analysis.png',
          package: 'research_package',
          width: iconSize,
          height: iconSize,
        );
      case RPConsentSectionType.DataHandling:
        return Image.asset(
          'assets/icons/archive.png',
          package: 'research_package',
          width: iconSize,
          height: iconSize,
        );
      case RPConsentSectionType.Duration:
        return Image.asset(
          'assets/icons/deadline.png',
          package: 'research_package',
          width: iconSize,
          height: iconSize,
        );
      case RPConsentSectionType.YourRights:
        return Image.asset(
          'assets/icons/networking.png',
          package: 'research_package',
          width: iconSize,
          height: iconSize,
        );
      case RPConsentSectionType.Location:
        return Image.asset(
          'assets/icons/location.png',
          package: 'research_package',
          width: iconSize,
          height: iconSize,
        );
      case RPConsentSectionType.Health:
        return Image.asset(
          'assets/icons/health.png',
          package: 'research_package',
          width: iconSize,
          height: iconSize,
        );
      case RPConsentSectionType.HealthDataCollection:
        return Image.asset(
          'assets/icons/health.png',
          package: 'research_package',
          width: iconSize,
          height: iconSize,
        );
      default:
        return Container();
    }
  }

  Widget _consentSectionPageBuilder(BuildContext context, int index) {
    RPConsentSection section = widget.consentDocument.sections[index];
    RPLocalizations? locale = RPLocalizations.of(context);

    // Display the list builder if type is of these types otherwise show normal.
    if (section.type == RPConsentSectionType.UserDataCollection ||
        section.type == RPConsentSectionType.PassiveDataCollection ||
        section.type == RPConsentSectionType.HealthDataCollection) {
      return Container(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                locale?.translate(section.title) ?? section.title,
                style: fs24fw700ls0.copyWith(
                  color: Theme.of(context).extension<CarpColors>()!.primary,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Text(
              locale?.translate(section.summary) ?? section.summary,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.start,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: section.dataTypes!.length,
                itemBuilder: (context, index) {
                  return DataCollectionListItem(section.dataTypes![index]);
                },
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Stack(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: _illustrationForType(section),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  locale?.translate(section.title) ?? section.title,
                  style: fs24fw700ls0.copyWith(
                    color: Theme.of(context).extension<CarpColors>()!.primary,
                  ),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 5),
                Text(
                  locale?.translate(section.summary) ?? section.summary,
                  style: fs16fw400ls0.copyWith(
                    color: Theme.of(context).extension<CarpColors>()!.grey900,
                  ),
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () => _pushContent(
                    section.title,
                    section.content!,
                  ),
                  child: Text(
                    RPLocalizations.of(context)?.translate('learn_more') ??
                        "Learn more",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color:
                            Theme.of(context).extension<CarpColors>()!.primary),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  Widget _progressIndicator() {
    if (_totalPages <= 1) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_totalPages - 1, (index) {
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              height: 4, // Thickness of the indicator
              decoration: BoxDecoration(
                color: index < _pageNr
                    ? Theme.of(context).extension<CarpColors>()!.primary
                    : Theme.of(context).extension<CarpColors>()!.grey300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _navigationButtons(PageController controller) {
    return Container(
      padding:
          const EdgeInsets.only(bottom: 15.0, top: 10.0, left: 30, right: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          OutlinedButton(
            child: Text(
              RPLocalizations.of(context)?.translate('CANCEL') ?? 'CANCEL',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            onPressed: () => _showCancelDialog(),
          ),
          TextButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(
                  Theme.of(context).extension<CarpColors>()!.primary),
            ),
            onPressed: _lastPage
                ? () => blocTask.sendStatus(RPStepStatus.Finished)
                : () => controller.nextPage(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.fastOutSlowIn),
            child: _lastPage
                ? Text(
                    RPLocalizations.of(context)?.translate('SEE_SUMMARY') ??
                        "SEE SUMMARY",
                    style: const TextStyle(color: Colors.white),
                  )
                : Text(
                    RPLocalizations.of(context)?.translate('NEXT') ?? "NEXT",
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                  ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    PageController controller = PageController();

    return PopScope<RPUIVisualConsentStep>(
      canPop: false,
      child: Scaffold(
        backgroundColor:
            Theme.of(context).extension<CarpColors>()!.backgroundGray,
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _progressIndicator(),
              Expanded(
                child: PageView.builder(
                  onPageChanged: (pageNr) {
                    _goToNextPage(pageNr);
                  },
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.consentDocument.sections.length,
                  controller: controller,
                  itemBuilder: _consentSectionPageBuilder,
                ),
              ),
              _navigationButtons(controller),
            ],
          ),
        ),
      ),
    );
  }
}

class DataCollectionListItem extends StatefulWidget {
  final RPDataTypeSection dataTypeSection;

  const DataCollectionListItem(this.dataTypeSection, {super.key});
  @override
  DataCollectionListItemState createState() => DataCollectionListItemState();
}

class DataCollectionListItemState extends State<DataCollectionListItem> {
  @override
  Widget build(BuildContext context) {
    RPLocalizations? locale = RPLocalizations.of(context);
    return ExpansionTile(
      tilePadding: const EdgeInsets.only(left: 0),
      expandedAlignment: Alignment.centerLeft,
      title: Text(
        locale?.translate(widget.dataTypeSection.dataName) ??
            widget.dataTypeSection.dataName,
        style: fs20fw700ls0.copyWith(
          color: Theme.of(context).extension<CarpColors>()!.grey900,
        ),
        textAlign: TextAlign.start,
      ),
      childrenPadding: const EdgeInsets.only(bottom: 5),
      children: [
        Text(
          locale?.translate(widget.dataTypeSection.dataInformation) ??
              widget.dataTypeSection.dataInformation,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.start,
        ),
      ],
    );
  }
}
