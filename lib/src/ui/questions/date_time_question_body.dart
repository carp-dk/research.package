part of '../../../ui.dart';

// ignore: must_be_immutable
class RPUIDateTimeQuestionBody extends StatefulWidget {
  final RPDateTimeAnswerFormat answerFormat;
  final void Function(dynamic) onResultChange;
  late final CupertinoDatePickerMode mode;

  RPUIDateTimeQuestionBody(
    this.answerFormat,
    this.onResultChange, {
    super.key,
  }) {
    mode = (answerFormat.dateTimeAnswerStyle == RPDateTimeAnswerStyle.Date)
        ? CupertinoDatePickerMode.date
        : (answerFormat.dateTimeAnswerStyle == RPDateTimeAnswerStyle.TimeOfDay)
            ? CupertinoDatePickerMode.time
            : CupertinoDatePickerMode.dateAndTime;
  }

  @override
  RPUIDateTimeQuestionBodyState createState() =>
      RPUIDateTimeQuestionBodyState();
}

class RPUIDateTimeQuestionBodyState extends State<RPUIDateTimeQuestionBody>
    with AutomaticKeepAliveClientMixin<RPUIDateTimeQuestionBody> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      height: 200,
      padding: const EdgeInsets.all(8),
      alignment: Alignment.topLeft,
      child: CupertinoTheme(
        data: CupertinoThemeData(
          brightness: Theme.of(context).brightness,
        ),
        child: CupertinoDatePicker(
          mode: widget.mode,
          use24hFormat: MediaQuery.of(context).alwaysUse24HourFormat,
          initialDateTime: DateTime.now(),
          maximumDate: DateTime.now(),
          onDateTimeChanged: (DateTime dateTime) {
            widget.onResultChange(dateTime.toString());
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
