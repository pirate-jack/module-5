import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:module_5/database/db_helper.dart';
import 'package:module_5/model/task_model.dart';
import 'package:module_5/screen/task_add_screen.dart';

class TaskShow extends StatefulWidget {
  const TaskShow({super.key});

  @override
  State<TaskShow> createState() => _TaskShowState();
}

class _TaskShowState extends State<TaskShow> {
  List<Task> taskList = [];
  Dbhelper _dbhelper = Dbhelper();

  Future<void> _fetchData() async {
    var tempList = await _dbhelper.getAllData();
    setState(() {
      taskList = tempList;
    });
  }

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  Future<void> updateTaskStatus(Task task, BuildContext context) async {
    int result = await _dbhelper.updateRecord(task);
  }

  void removeTask(Task task, BuildContext context) {
    _dbhelper.deleteRecord(task).then((value) {
      if (value > 0) {
        setState(() {
          taskList.removeWhere((element) => element.id == task.id);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TO-DO_list'),
      ),
      body: GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: taskList.length,
        itemBuilder: (context, index) {
          Task task = taskList[index];
          return Card(
            color: cardColors(task),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        task.name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Colors.white),
                      ),
                      PopupMenuButton(
                        itemBuilder: (context) {
                          return <PopupMenuEntry<String>>[
                            PopupMenuItem(
                              child: Text('Complete'),
                              onTap: () {
                                setState(() {
                                  task.complete = 'true';
                                  updateTaskStatus(task, context);
                                });
                              },
                            ),
                            PopupMenuItem(
                              child: Text('Remove'),
                              onTap: () {
                                setState(() {
                                  removeTask(task, context);
                                });
                              },
                            )
                          ];
                        },
                      )
                    ],
                  ),
                  Text(
                    task.description,
                    style: TextStyle(color: Colors.white),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.bottomRight,
                      child: Text(DateFormat('dd-MM-yyyy',).format(
                          DateTime.fromMillisecondsSinceEpoch(
                              int.parse('${task.createAt}'))),style: TextStyle(color: Colors.white),),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Task? task = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskAdd(),
            ),
          );
          if (task != null) {
            setState(() {
              taskList.insert(0, task);
            });
          }
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.blue,
      ),
    );
  }

  cardColors(Task task) {
    if (task.complete == "true") {
      return Colors.grey;
    } else if (task.priority == 'High') {
      return Colors.green[400];
    } else if (task.priority == 'Low') {
      return Colors.red[300];
    } else if (task.priority == 'Average') {
      return Colors.blue[300];
    }
  }
}
