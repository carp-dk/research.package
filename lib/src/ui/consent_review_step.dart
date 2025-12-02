part of '../../ui.dart';

/// The UI representation of [RPConsentReviewStep]
///
/// You should not need to instantiate a consent review step widget directly.
/// Instead, include a consent review step in a task, and present a task widget for that task.
class RPUIConsentReviewStep extends StatefulWidget {
  final RPConsentReviewStep step;

  const RPUIConsentReviewStep(this.step, {super.key});

  @override
  RPUIConsentReviewStepState createState() => RPUIConsentReviewStepState();
}

class RPUIConsentReviewStepState extends State<RPUIConsentReviewStep>
    with CanSaveResult {
  RPConsentSignatureResult? consentSignatureResult;
  RPSignatureResult? signatureResult;

  void _setSignatureResult(RPSignatureResult? result) {
    setState(() {
      signatureResult = result;
    });
    createAndSendResult();
  }

  @override
  void createAndSendResult() {
    // Transforming the consent document from the string values in the objects
    // to the translation the users were presented with
    List<RPConsentSection> translatedConsentSections = [];
    RPLocalizations? locale = RPLocalizations.of(context);
    for (RPConsentSection section in widget.step.consentDocument.sections) {
      List<RPDataTypeSection> translatedDataTypeSections = [];
      if ([
            RPConsentSectionType.UserDataCollection,
            RPConsentSectionType.PassiveDataCollection,
            RPConsentSectionType.HealthDataCollection
          ].contains(section.type) &&
          section.dataTypes != null) {
        for (RPDataTypeSection dataTypeSection in section.dataTypes!) {
          translatedDataTypeSections.add(
            RPDataTypeSection(
              dataName: locale?.translate(dataTypeSection.dataName) ??
                  dataTypeSection.dataName,
              dataInformation:
                  locale?.translate(dataTypeSection.dataInformation) ??
                      dataTypeSection.dataInformation,
            ),
          );
        }
      }
      translatedConsentSections.add(RPConsentSection(
        title: locale?.translate(section.title) ?? section.title,
        summary: locale?.translate(section.summary) ?? section.summary,
        content: section.content != null
            ? locale?.translate(section.content!) ?? section.content
            : null,
        type: section.type,
        dataTypes: (translatedDataTypeSections.isNotEmpty)
            ? translatedDataTypeSections
            : null,
      ));
    }
    RPConsentDocument translatedConsentDocument = RPConsentDocument(
        title: locale?.translate(widget.step.consentDocument.title) ??
            widget.step.consentDocument.title,
        sections: translatedConsentSections);

    for (RPConsentSignature signature
        in widget.step.consentDocument.signatures) {
      translatedConsentDocument.addSignature(signature);
    }

    // Creating the result object
    consentSignatureResult = RPConsentSignatureResult(
        identifier: widget.step.identifier,
        consentDocument: translatedConsentDocument,
        signature: signatureResult)
      ..endDate = DateTime.now();

    blocTask.sendStepResult(consentSignatureResult!);
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: 'consent_review/text',
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case 'consent_review/text':
            builder = (BuildContext _) => _TextPresenterRoute(widget.step,
                (signatureResult) => _setSignatureResult(signatureResult));
            break;
          case 'consent_review/signature':
            builder = (BuildContext _) => _SignatureRoute(
                  widget.step.title,
                  widget.step.consentDocument.signatures.first,
                  _setSignatureResult,
                );
            break;
          default:
            throw Exception('Invalid route: ${settings.name}');
        }
        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }
}

class _TextPresenterRoute extends StatefulWidget {
  final RPConsentReviewStep step;
  final void Function(RPSignatureResult?) onNoSignature;

  const _TextPresenterRoute(this.step, this.onNoSignature);

  @override
  __TextPresenterRouteState createState() => __TextPresenterRouteState();
}

class __TextPresenterRouteState extends State<_TextPresenterRoute> {
  Widget _reviewCellBuilder(BuildContext context, int index) {
    RPLocalizations? locale = RPLocalizations.of(context);
    // Return the header as the first element.
    if (index == 0) {
      return Column(children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 44.0),
          child: Text(
            locale?.translate('review_form') ??
                'Review this form below, and tap AGREE if you\'re ready to continue.',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.start,
          ),
        ),
      ]);
    }
    index -= 1;

    if (widget.step.consentDocument.sections[index].type ==
            RPConsentSectionType.PassiveDataCollection ||
        widget.step.consentDocument.sections[index].type ==
            RPConsentSectionType.UserDataCollection ||
        widget.step.consentDocument.sections[index].type ==
            RPConsentSectionType.HealthDataCollection) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 24, bottom: 4),
            child: Text(
              locale?.translate(
                      widget.step.consentDocument.sections[index].title) ??
                  widget.step.consentDocument.sections[index].title,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.start,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.step.consentDocument.sections[index]
                .dataTypes! // DataTypes must be provided given a data collection section has been created.
                .map((e) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4, top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      locale?.translate(e.dataName) ?? e.dataName,
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.start,
                    ),
                    Text(
                      locale?.translate(e.dataInformation) ?? e.dataInformation,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            locale?.translate(
                    widget.step.consentDocument.sections[index].title) ??
                widget.step.consentDocument.sections[index].title,
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(color: Theme.of(context).primaryColor),
            textAlign: TextAlign.start,
          ),
        ),
        Text(
          locale?.translate(
                  widget.step.consentDocument.sections[index].summary) ??
              widget.step.consentDocument.sections[index].summary,
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.start,
        ),
        widget.step.consentDocument.sections[index].content != null
            ? Text(
                locale?.translate(
                        widget.step.consentDocument.sections[index].content!) ??
                    widget.step.consentDocument.sections[index].content!,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.start,
              )
            : Container(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    RPLocalizations? locale = RPLocalizations.of(context);
    void showConsentDialog(VoidCallback onPressedCallback) {
      showDialog<dynamic>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title:
                Text(locale?.translate(widget.step.text!) ?? widget.step.text!),
            content: Text(locale?.translate(widget.step.reasonForConsent!) ??
                widget.step.reasonForConsent!),
            actions: <Widget>[
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  locale?.translate('CANCEL') ?? 'CANCEL',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
              TextButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                      Theme.of(context).extension<CarpColors>()!.primary),
                ),
                onPressed: onPressedCallback,
                child: Text(locale?.translate('AGREE') ?? "AGREE",
                    style: Theme.of(context).textTheme.labelLarge),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      backgroundColor:
          Theme.of(context).extension<CarpColors>()!.backgroundGray,
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: widget.step.consentDocument.sections.length + 1,
          itemBuilder: _reviewCellBuilder,
        ),
      ),
      persistentFooterButtons: <Widget>[
        OutlinedButton(
          child: Text(
            locale?.translate('DISAGREE') ?? 'DISAGREE',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          onPressed: () {
            blocTask.sendStatus(RPStepStatus.Canceled);
          },
        ),
        TextButton(
          style: ButtonStyle(
            backgroundColor:
                WidgetStateProperty.all(Theme.of(context).primaryColor),
          ),
          child: Text(
            locale?.translate('AGREE') ?? "AGREE",
            style: Theme.of(context).textTheme.labelLarge,
          ),
          onPressed: () {
            showConsentDialog(
              widget.step.consentDocument.signatures.isNotEmpty
                  ? () {
                      // Dismiss pop-up. It uses the root Navigator since it's an overlay
                      Navigator.of(context, rootNavigator: true).pop();
                      Navigator.of(context)
                          .pushReplacementNamed('consent_review/signature');
                    }
                  : () {
                      // Dismiss pop-up. It uses the root Navigator since it's an overlay
                      Navigator.of(context, rootNavigator: true).pop();
                      widget.onNoSignature(null);
                      blocTask.sendStatus(RPStepStatus.Finished);
                    },
            );
          },
        ),
      ],
    );
  }
}

class _SignatureRoute extends StatefulWidget {
  final RPConsentSignature _consentSignature;
  final void Function(RPSignatureResult) _onFinished;

  const _SignatureRoute(_, this._consentSignature, this._onFinished);

  @override
  _SignatureRouteState createState() => _SignatureRouteState();
}

class _SignatureRouteState extends State<_SignatureRoute> {
  bool _isNameFilled = false;
  bool _isSignatureAdded = false;

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  SignatureController? _signatureController;

  void _checkNameIsNotEmpty() {
    setState(() {
      _isNameFilled =
          (_firstNameController.text != '' && _lastNameController.text != '');
    });
  }

  @override
  void initState() {
    _signatureController = SignatureController(
      penStrokeWidth: 4,
      penColor: Colors.red,
      exportBackgroundColor: Colors.transparent,
      onDrawEnd: () {
        if (_signatureController!.isNotEmpty) {
          setState(() {
            _isSignatureAdded = true;
          });
        }
      },
    );

    widget._consentSignature.requiresSignatureImage
        ? _isSignatureAdded = false
        : _isSignatureAdded = true;
    widget._consentSignature.requiresName
        ? _isNameFilled = false
        : _isNameFilled = true;
    _firstNameController.addListener(_checkNameIsNotEmpty);
    _lastNameController.addListener(_checkNameIsNotEmpty);

    super.initState();
  }

  Widget _nameFields(BuildContext context) {
    RPLocalizations? locale = RPLocalizations.of(context);
    final node = FocusScope.of(context);
    return Column(
      children: <Widget>[
        TextFormField(
          autofocus: true,
          textInputAction: TextInputAction.next,
          onEditingComplete: () => node.nextFocus(),
          controller: _firstNameController,
          decoration: InputDecoration(
            labelText: locale?.translate('first_name') ?? "First Name",
          ),
        ),
        TextFormField(
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => node.unfocus(),
          controller: _lastNameController,
          decoration: InputDecoration(
              labelText: locale?.translate('last_name') ?? "Last Name"),
        ),
      ],
    );
  }

  Widget _signingField(BuildContext context) {
    RPLocalizations? locale = RPLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          children: <Widget>[
            Text(
              locale?.translate('sign_with_finger') ??
                  'Please sign using your finger in the box below',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 2,
                  ),
                ),
                child: Signature(
                  controller: _signatureController!,
                  height: 200,
                  width: MediaQuery.of(context).size.width - 70,
                  backgroundColor: Colors.transparent,
                ),
              ),
            ),
            OutlinedButton(
              onPressed: _isSignatureAdded
                  ? () {
                      _signatureController?.clear();
                      setState(() {
                        _isSignatureAdded = false;
                      });
                    }
                  : null,
              child: Text(
                locale?.translate('clear') ?? 'Clear',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    RPLocalizations? locale = RPLocalizations.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onPanDown: (_) => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor:
            Theme.of(context).extension<CarpColors>()!.backgroundGray,
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(12),
            physics: const NeverScrollableScrollPhysics(),
            children: <Widget>[
              widget._consentSignature.requiresName
                  ? _nameFields(context)
                  : Container(),
              widget._consentSignature.requiresSignatureImage
                  ? _signingField(context)
                  : Container(),
            ],
          ),
        ),
        persistentFooterButtons: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor),
            onPressed: (_isNameFilled && _isSignatureAdded)
                ? () {
                    if (widget._consentSignature.requiresSignatureImage) {
                      _signatureController?.toPngBytes().then(
                        (image) {
                          widget._onFinished(
                            RPSignatureResult.withParams(
                              _firstNameController.value.text,
                              _lastNameController.value.text,
                              // Converting the Uint8List into a string to make it compatible with JSON serialization
                              image.toString(),
                            ),
                          );
                        },
                      );
                    } else {
                      widget._onFinished(
                        RPSignatureResult.withParams(
                          _firstNameController.value.text,
                          _lastNameController.value.text,
                          // Since no signature was asked set the image blob to null
                          null,
                        ),
                      );
                    }
                    blocTask.sendStatus(RPStepStatus.Finished);
                  }
                : null,
            child: Text(
              locale?.translate('NEXT') ?? "NEXT",
              style: Theme.of(context).primaryTextTheme.labelLarge,
            ),
          ),
          //),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }
}
