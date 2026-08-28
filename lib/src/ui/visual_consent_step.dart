part of '../../ui.dart';

/// The UI representation of [RPVisualConsentStep]
///
/// In general, you don’t need to instantiate an visual consent step widget directly.
/// Instead, add an visual consent step to a task and present the task using a task widget.
/// When appropriate, the task widget instantiates the visual consent step widget for the step.
class RPUIVisualConsentStep extends StatefulWidget {
  const RPUIVisualConsentStep({super.key, required this.step});
  final RPVisualConsentStep step;

  @override
  RPUIVisualConsentStepState createState() => RPUIVisualConsentStepState();
}

class RPUIVisualConsentStepState extends State<RPUIVisualConsentStep>
    with SingleTickerProviderStateMixin {
  int _pageNr = 0;
  int _totalPages = 0;
  bool _lastPage = false;

  final PageController _controller = PageController();

  /// Collects the outcome of the permissions asked for while going through the
  /// sections. `null` unless [RPVisualConsentStep.askPermission] is set.
  RPPermissionResult? _permissionResult;

  /// Guards against asking again while the dialog for the previous request is
  /// still up.
  bool _requestingPermissions = false;

  /// The permissions declared on the section currently on screen. Empty when it
  /// declares none, or when the step did not opt in with `askPermission`.
  List<RPPermissionType> get _permissionsOnScreen => _permissionResult == null
      ? const []
      : widget.step.consentDocument.sections[_pageNr].permissions ?? const [];

  /// Whether tapping the forward button on the section currently on screen is
  /// still going to open a system permission alert.
  ///
  /// Apple requires such a screen to carry a single button which leads to the
  /// alert, and no way of leaving it without seeing the alert - so BACK is
  /// hidden while this is true. Once the alert has been shown, whatever the
  /// participant answered, the screen is an ordinary consent section again and
  /// BACK returns. It keys on whether the permission was *asked for* rather
  /// than granted, because a denial does not re-open the alert either.
  bool get _awaitsPermissionAlert {
    final result = _permissionResult;
    if (result == null) return false;
    return _permissionsOnScreen
        .any((permission) => !result.statuses.containsKey(permission));
  }

  @override
  void initState() {
    super.initState();
    _totalPages = widget.step.consentDocument.sections.length;
    if (widget.step.askPermission) {
      _permissionResult = RPPermissionResult(identifier: widget.step.identifier)
        ..startDate = DateTime.now();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onPageChanged(int pageNr) {
    setState(() {
      _pageNr = pageNr;
      // Recomputed, so going back turns "SEE SUMMARY" into "NEXT" again.
      _lastPage = _pageNr == widget.step.consentDocument.sections.length - 1;
    });
  }

  /// Asks for the permissions declared on the section currently on screen.
  ///
  /// The requests are made one at a time, because iOS shows a single permission
  /// dialog at a time and asking for several at once is unreliable. A permission
  /// which was already granted is skipped, so going back and forth - or through
  /// the consent flow a second time - does not prompt again.
  Future<void> _requestPermissionsForCurrentSection() async {
    final result = _permissionResult;
    if (result == null || _requestingPermissions) return;

    final permissions = _permissionsOnScreen;
    if (permissions.isEmpty) return;

    final section = widget.step.consentDocument.sections[_pageNr];

    _requestingPermissions = true;
    try {
      for (var permission in permissions) {
        if (result.statuses[permission] == RPPermissionStatus.granted) continue;
        result.setStatus(
            permission,
            await RPPermissions.request(permission,
                healthDataTypes: section.healthDataTypes ?? const []));
      }
    } finally {
      _requestingPermissions = false;
    }
  }

  /// Adds the outcome of the permission requests to the task result, under the
  /// identifier of this step. Does nothing if nothing was asked for.
  void _sendPermissionResult() {
    final result = _permissionResult;
    if (result == null || result.statuses.isEmpty) return;
    result.endDate = DateTime.now();
    blocTask.sendStepResult(result);
  }

  /// Moves on from the section currently on screen, asking for its permissions
  /// first so the dialog is shown while its explanation is still visible.
  Future<void> _proceed() async {
    await _requestPermissionsForCurrentSection();
    if (!mounted) return;

    if (_lastPage) {
      _sendPermissionResult();
      blocTask.sendStatus(RPStepStatus.Finished);
    } else {
      await _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  /// Returns to the previous section, so the participant can re-read it.
  Future<void> _goBack() => _controller.previousPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.fastOutSlowIn);

  void _pushContent(String title, String content) {
    Navigator.of(context).push(
      MaterialPageRoute<dynamic>(
        builder: (context) => _DetailTextRoute(title: title, content: content),
      ),
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
      case RPConsentSectionType.BackgroundSensing:
        return Image.asset(
          'assets/icons/settings.png',
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
    RPConsentSection section = widget.step.consentDocument.sections[index];
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
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
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
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 5),
                Text(
                  locale?.translate(section.summary) ?? section.summary,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge!.copyWith(color: Colors.grey.shade900),
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () => _pushContent(section.title, section.content!),
                  child: Text(
                    RPLocalizations.of(context)?.translate('learn_more') ??
                        "Learn more",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
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
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _navigationButtons() {
    // A section still about to open a permission alert offers the forward
    // button and nothing else. The empty slot is kept so it does not move.
    final showBackButton = _pageNr > 0 && !_awaitsPermissionAlert;

    return Container(
      padding: const EdgeInsets.only(
        bottom: 15.0,
        top: 10.0,
        left: 30,
        right: 30,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          !showBackButton
              ? const SizedBox.shrink()
              : OutlinedButton(
                  onPressed: _goBack,
                  child: Text(
                    RPLocalizations.of(context)?.translate('BACK') ?? 'BACK',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
          FilledButton(
            onPressed: _proceed,
            child: _lastPage
                ? Text(
                    RPLocalizations.of(context)?.translate('SEE_SUMMARY') ??
                        "SEE SUMMARY",
                  )
                : Text(
                    RPLocalizations.of(context)?.translate('NEXT') ?? "NEXT",
                  ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope<RPUIVisualConsentStep>(
      canPop: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _progressIndicator(),
              Expanded(
                child: PageView.builder(
                  onPageChanged: _onPageChanged,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.step.consentDocument.sections.length,
                  controller: _controller,
                  itemBuilder: _consentSectionPageBuilder,
                ),
              ),
              _navigationButtons(),
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
      shape: const Border(),
      collapsedShape: const Border(),
      expandedAlignment: Alignment.centerLeft,
      title: Text(
        locale?.translate(widget.dataTypeSection.dataName) ??
            widget.dataTypeSection.dataName,
        style: Theme.of(context).textTheme.titleLarge!
            .copyWith(fontSize: 20)
            .copyWith(color: Colors.grey.shade900),
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
