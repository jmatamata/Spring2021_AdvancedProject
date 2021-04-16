import 'package:flutter/material.dart';

class ChecklistPage extends StatefulWidget {
  @override
  _ChecklistState createState() => _ChecklistState();
}

class _ChecklistState extends State<ChecklistPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: StreamBuilder(
          stream: checklistBloc.taskListStream
              .where((taskList) => taskList != null),
          builder: (context, snapshot) {
            List<Task> tempTaskList =
                (snapshot.hasData && snapshot.data.getTaskList != null)
                    ? snapshot.data.getTaskList
                    : <Task>[];

            return (0 < tempTaskList.length)
                ? ListView.builder(
                    itemCount: tempTaskList.length,
                    itemBuilder: (context, index) {
                      Task tempTask = tempTaskList[index];

                      return CheckboxListTile(
                        title: StreamBuilder(
                          stream: taskDeadlineClock.clockStream
                              .where((time) => time != null),
                          builder: (context, updatedTime) {
                            return DecoratedBox(
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(8.0),
                                color: tempTask.getTitleColor,
                              ),
                              position: DecorationPosition.background,
                              child: Padding(
                                padding:
                                    EdgeInsets.fromLTRB(6.0, 8.0, 6.0, 8.0),
                                child: Text(
                                  tempTask.getTaskName,
                                  style: TextStyle(
                                    backgroundColor: tempTask.getTitleColor,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        subtitle: Padding(
                          padding: EdgeInsets.fromLTRB(6.0, 4.0, 0.0, 0.0),
                          child: Text(
                            tempTask.getTaskSubtitle(tempTask.getTaskDeadline),
                          ),
                        ),
                        value: tempTask.getTaskCompleteStatus,
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: Colors.green,
                        checkColor: Colors.white,
                        isThreeLine: true,
                        contentPadding: EdgeInsets.fromLTRB(0.0, 6.0, 0.0, 6.0),
                        onChanged: (bool newValue) {
                          tempTask.changeStatus();
                          checklistBloc.taskSink.add(tempTask);
                        },
                        secondary: MaterialButton(
                          child: Text("Delete"),
                          color: Color(_deleteButtonColor),
                          splashColor: Colors.red,
                          onPressed: () {
                            if (0 < tempTaskList.length) {
                              tempTaskList.removeAt(index);
                              checklistBloc.taskSink.add(null);
                            }
                          },
                        ),
                      );
                    },
                  )
                : Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                    child: Text(
                      "Enter Task for Checklist using the '+' Button",
                      textAlign: TextAlign.center,
                      textScaleFactor: 1.3,
                    ),
                  );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          createAlertDialog(context).then((taskData) {
            if (taskData != null) {
              if (taskData.taskName == null)
                checklistBloc.taskSink.add(null);
              else if (taskData.taskDeadline == null)
                checklistBloc.taskSink.add(Task(taskData.taskName,
                    DateTime.now(), taskDeadlineClock.clockStream));
              else
                checklistBloc.taskSink.add(Task(taskData.taskName,
                    taskData.taskDeadline, taskDeadlineClock.clockStream));
            }
          });
        },
      ),
    );
  }
}
