part of '../../../ui.dart';

class RPUIIntegerQuestionBody extends StatefulWidget {
  final RPIntegerAnswerFormat answerFormat;
  final void Function(dynamic) onResultChange;

  const RPUIIntegerQuestionBody(
    this.answerFormat,
    this.onResultChange, {
    super.key,
  });

  @override
  RPUIIntegerQuestionBodyState createState() => RPUIIntegerQuestionBodyState();
}

class RPUIIntegerQuestionBodyState extends State<RPUIIntegerQuestionBody>
    with AutomaticKeepAliveClientMixin<RPUIIntegerQuestionBody> {
  TextEditingController? _textEditingController;
  String? _errorMessage;
  bool _valid = true;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    _valid = true;
    super.initState();
  }

  void _validate(String text, RPLocalizations? locale) {
    int value;
    try {
      value = int.parse(text);
    } catch (error) {
      setState(() {
        _valid = false;
        _errorMessage = locale?.translate('input_number') ?? "Input a number";
      });
      widget.onResultChange(null);
      return;
    }

    if (value >= widget.answerFormat.minValue &&
        value <= widget.answerFormat.maxValue) {
      setState(() {
        _valid = true;
      });
    } else {
      setState(() {
        _valid = false;
        _errorMessage =
            "${locale?.translate('between') ?? 'Should be between'} ${widget.answerFormat.minValue} ${locale?.translate('and') ?? 'and'} ${widget.answerFormat.maxValue}";
      });
      widget.onResultChange(null);
      return;
    }
    widget.onResultChange(text);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    RPLocalizations? locale = RPLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(8),
      alignment: Alignment.topLeft,
      child: TextFormField(
        controller: _textEditingController,
        decoration: InputDecoration(
          filled: true,
          hintText: locale?.translate('tap_to_answer') ?? "Tap to answer",
          helperStyle:
              TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
          suffix: widget.answerFormat.suffix != null
              ? Text(locale?.translate(widget.answerFormat.suffix!) ??
                  widget.answerFormat.suffix!)
              : null,
          errorText: _valid ? null : _errorMessage,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        onChanged: (text) => _validate(text, locale),
        keyboardType: TextInputType.number,
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController?.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
