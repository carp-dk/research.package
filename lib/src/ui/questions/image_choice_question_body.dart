part of '../../../ui.dart';

class RPUIImageChoiceQuestionBody extends StatefulWidget {
  final RPImageChoiceAnswerFormat answerFormat;
  final void Function(dynamic) onResultChance;

  const RPUIImageChoiceQuestionBody(
    this.answerFormat,
    this.onResultChance, {
    super.key,
  });

  @override
  RPUIImageChoiceQuestionBodyState createState() =>
      RPUIImageChoiceQuestionBodyState();
}

class RPUIImageChoiceQuestionBodyState
    extends State<RPUIImageChoiceQuestionBody>
    with AutomaticKeepAliveClientMixin<RPUIImageChoiceQuestionBody> {
  RPImageChoice? _selectedItem;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    RPLocalizations? locale = RPLocalizations.of(context);
    String text = (_selectedItem == null)
        ? (locale?.translate('select_image') ?? 'Select an image')
        : (locale?.translate(_selectedItem!.description) ??
            _selectedItem!.description);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _buildList(context, widget.answerFormat.choices),
        const SizedBox(height: 16),
        Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }

  Widget _buildList(BuildContext context, List<RPImageChoice> items) {
    // Wraps rather than shrinking every image to fit one row, so a long list
    // stays tappable.
    const double size = 72;

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: [
        for (var item in items)
          InkWell(
            borderRadius: BorderRadius.circular(size),
            onTap: () {
              setState(() {
                _selectedItem = item == _selectedItem ? null : item;
              });
              widget.onResultChance(_selectedItem);
            },
            child: Container(
              // Highlighting of chosen answer
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _selectedItem == item
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
                  width: 3,
                ),
              ),
              padding: const EdgeInsets.all(4),
              width: size,
              height: size,
              child: Image.asset(item.imageUrl),
            ),
          ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
