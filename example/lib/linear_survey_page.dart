part of 'main.dart';

class LinearSurveyPage extends StatelessWidget {
  const LinearSurveyPage({super.key});

  String _encode(Object object) =>
      const JsonEncoder.withIndent(' ').convert(object);

  void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  void resultCallback(RPTaskResult result) {
    // Do anything with the final result
    print('FINAL RESULT SUBMITTED:');
    printWrapped(_encode(result));
  }

  void cancelCallBack(RPTaskResult? result) {
    // Do anything with the result at the moment of the cancellation
    print('RESULT SO FAR BEFORE CANCELED:');
    printWrapped(_encode(result ?? 'No Result'));
  }

  @override
  Widget build(BuildContext context) {
    return RPUITask(
      task: linearSurveyTask,
      onSubmit: resultCallback,
      onCancel: cancelCallBack,
      carouselBarImage: Image.asset(
        'assets/icons/carp_logo_example.png',
        package: 'research_package',
        fit: BoxFit.contain,
        height: 16,
      ),
      carouselBarBackgroundColor:
          Theme.of(context).extension<CarpColors>()!.backgroundGray,
      // onCancel: (RPTaskResult? result) {
      //   if (result == null) {
      //     print("No result");
      //   } else {
      //     cancelCallBack(result);
      //   }
      // },
    );
  }
}
