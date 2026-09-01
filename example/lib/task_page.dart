part of 'main.dart';

class TaskPage extends StatelessWidget {
  final RPOrderedTask task;
  const TaskPage(this.task, {super.key});

  void _log(String header, Object? result) =>
      log('$header\n${toJsonString(result ?? 'No result')}');

  @override
  Widget build(BuildContext context) => RPUITask(
        task: task,
        onSubmit: (result) => _log('FINAL RESULT SUBMITTED:', result),
        onCancel: (result) => _log('RESULT SO FAR BEFORE CANCELED:', result),
        carouselBarImage: Image.asset(
          'assets/icons/carp_logo_example.png',
          package: 'research_package',
          fit: BoxFit.contain,
          height: 16,
        ),
        carouselBarBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
      );
}
