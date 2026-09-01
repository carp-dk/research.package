part of '../../../ui.dart';

class RPUIStarChoiceQuestionBody extends StatefulWidget {
  final RPStarChoiceAnswerFormat answerFormat;
  final void Function(dynamic) onResultChance;

  const RPUIStarChoiceQuestionBody(
    this.answerFormat,
    this.onResultChance, {
    super.key,
  });

  @override
  RPUIStarChoiceQuestionBodyState createState() =>
      RPUIStarChoiceQuestionBodyState();
}

class RPUIStarChoiceQuestionBodyState
    extends State<RPUIStarChoiceQuestionBody>
    with AutomaticKeepAliveClientMixin<RPUIStarChoiceQuestionBody> {
  RPStarChoice? _selectedItem;

  bool isLeftOfSelected(RPStarChoice item,List<RPStarChoice> items){
    return (_selectedItem==null)?false:(items.indexOf(_selectedItem!)>=items.indexOf(item));
    //items.indexOf(_selectedItem);
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    RPLocalizations? locale = RPLocalizations.of(context);
    String text = (_selectedItem == null)
        ? (locale?.translate('select_star') ?? 'Select how many')
        : (locale?.translate(_selectedItem!.description) ??
            _selectedItem!.description);
    return SizedBox(
        height: 160,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _buildList(context, widget.answerFormat.choices),
            Text(
              text,
              style: Theme.of(context).textTheme.headlineSmall,
            )
          ],
        ));
  }

  Row _buildList(BuildContext context, List<RPStarChoice> items) {
    List<Widget> list = [];
    for (var item in items) {
      list.add(
        InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {
            setState(() {
              _selectedItem = item == _selectedItem ? null : item;
            });
            widget.onResultChance(_selectedItem);
          },
          child: Container(
            // Highlighting of chosen answer
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.all(Radius.circular(5 * 25 / items.length)),
              border: Border.all(
                color: _selectedItem == item
                    ? Theme.of(context).dividerColor
                    : Colors.transparent,
                width: 3,
              ),
            ),
            // Scaling item size with number of choices
            // Max size is 125
            padding: EdgeInsets.all(10 / items.length),
            width:
                (MediaQuery.of(context).size.width * 0.8) / items.length > 125
                    ? 125
                    : MediaQuery.of(context).size.width * 0.8 / items.length,
            height:
                (MediaQuery.of(context).size.width * 0.8) / items.length > 125
                    ? 125
                    : MediaQuery.of(context).size.width * 0.8 / items.length,
            child: isLeftOfSelected(item,items)?Image.asset(item.starActiveUrl):Image.asset(item.starNotActiveUrl),
          ),
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: list,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
