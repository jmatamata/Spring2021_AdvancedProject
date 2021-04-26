import 'dart:async';

class TaskDeadlineClock {
  final _taskDeadlineClockStreamController =
      StreamController<DateTime>.broadcast(onListen: () {});
  StreamSink<DateTime> get _clockSink =>
      _taskDeadlineClockStreamController.sink;
  Stream<DateTime> get clockStream =>
      _taskDeadlineClockStreamController.stream.asBroadcastStream();

  TaskDeadlineClock() {
    Timer.periodic(Duration(minutes: 1), (timer) {
      _clockSink.add(DateTime.now());

      print("===================Time Update ======================");
    });
  }

  void dispose() {
    _taskDeadlineClockStreamController.close();
  }
}
