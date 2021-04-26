import 'dart:async';
import 'package:acm_widget_mobile_app/models/checklist_color_changer.dart';
import 'package:flutter/material.dart';

class ChecklistBloc {
  TaskList _userTaskList;

  final _taskListStreamController = StreamController<TaskList>();
  StreamSink<TaskList> get _taskListSink => _taskListStreamController.sink;
  Stream<TaskList> get taskListStream => _taskListStreamController.stream;

  final _taskController = StreamController<Task>();
  StreamSink<Task> get taskSink => _taskController.sink;
  Stream<Task> get _taskStream => _taskController.stream;

  ChecklistBloc() {
    _userTaskList = TaskList();

    _taskStream.listen(
      (task) {
        if (task != null && _userTaskList.getTaskList.contains(task)) {
          List<Task> tempTaskList = _userTaskList.getTaskList;

          tempTaskList.replaceRange(tempTaskList.indexOf(task),
              tempTaskList.indexOf(task) + 1, [task]);

          _taskListSink.add(_userTaskList);
        } else if (task != null) {
          _userTaskList.addTask(task);

          _taskListSink.add(_userTaskList);
        } else if (task == null) {
          _taskListSink.add(_userTaskList);
        }
      },
      onError: (err) {
        print("Error");
      },
    );
  }

  void dispose() {
    _taskListStreamController.close();

    _taskController.close();
  }
}

class Task {
  String _taskName = '';

  bool _completeStatus = false;

  DateTime _taskDeadline;

  DateTime _creationDate = DateTime.now();

  TitleColorChanger _colorChanger;

  Color _taskColor = Color(0xffffffff);

  Task(String userTaskName, DateTime userTaskDeadline,
      Stream<DateTime> deadlineClockIn,
      [bool userCompleteStatus = false]) {
    _taskName = userTaskName;

    _completeStatus = userCompleteStatus;

    _taskDeadline = userTaskDeadline;

    _colorChanger = TitleColorChanger(_creationDate, userTaskDeadline);

    deadlineClockIn.listen((updatedTime) {
      if (updatedTime != null)
        _taskColor = _colorChanger.getTitleColor(updatedTime);
    });
  }

  String get getTaskName => _taskName;

  bool get getTaskCompleteStatus => _completeStatus;

  DateTime get getTaskDeadline => _taskDeadline;

  Color get getTitleColor => _taskColor;

  String getTaskSubtitle(DateTime userDateTime) {
    DateTime tempCurrentDate = DateTime.now();

    if (userDateTime.isBefore(tempCurrentDate))
      return "Due Today";
    else if (userDateTime.isBefore(tempCurrentDate.add(new Duration(days: 1))))
      return "Due Tomorrow";
    else
      return "Due: ${userDateTime.month}/${userDateTime.day}/${userDateTime.year}";
  }

  changeStatus() {
    _completeStatus = !_completeStatus;
  }
}

class TaskList {
  List<Task> _tasks = [];

  List<Task> get getTaskList => _tasks;

  TaskList();

  TaskList.fromList(this._tasks);

  addTask(Task userTask) {
    _tasks.add(userTask);
  }
}

class TaskDataReturnType {
  String taskName;

  DateTime taskDeadline;

  TaskDataReturnType(this.taskName, this.taskDeadline);
}
