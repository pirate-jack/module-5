import 'package:flutter/material.dart';
import 'package:module_5/database/db_helper.dart';
import 'package:module_5/model/task_model.dart';

class TaskAdd extends StatefulWidget {
  Task? task;

  TaskAdd({this.task});

  @override
  State<TaskAdd> createState() => _TaskAddState();
}

class _TaskAddState extends State<TaskAdd> {
  String selectpriority = "Average";
  final _descriptionController = TextEditingController();
  final _nameController = TextEditingController();
  Dbhelper dbhelper = Dbhelper();
  String taskStatus = 'false';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Task'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                        hintText: 'Name',
                        labelText: 'Name'),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                        hintText: 'Description',
                        labelText: 'Description'),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Card(
                    elevation: 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text('Select Your Task Priority'),
                        RadioListTile(
                          value: "High",
                          groupValue: selectpriority,
                          onChanged: handelvalue,
                          title: Text('High'),
                        ),
                        RadioListTile(
                          value: "Average",
                          groupValue: selectpriority,
                          onChanged: handelvalue,
                          title: Text('Average'),
                        ),
                        RadioListTile(
                          value: "Low",
                          groupValue: selectpriority,
                          onChanged: handelvalue,
                          title: Text('Low'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: FilledButton(
                      onPressed: () {
                        String name = _nameController.text.trim();
                        String description = _descriptionController.text.trim();
                        print('''
                     name : $name
                     description : $description
                     selectchoice : $selectpriority
                      ''');
                        Task task = Task(
                            id: widget.task != null ? widget.task!.id : null,
                            name: name,
                            description: description,
                            createAt: widget.task != null
                                ? widget.task!.createAt
                                : DateTime.now().millisecondsSinceEpoch,
                            priority: selectpriority,
                            complete: taskStatus);
                        addTask(task, context);
                      },
                      child: Text('Submit'),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  void handelvalue(String? value) {
    setState(() {
      selectpriority = value!;
    });
  }

  Future<void> addTask(Task task, BuildContext context) async {
    print(task.toMap());
    int result = await dbhelper.insertRecord(task);
    if (result != -1) {
      task.id = result;
      print('Task Add');
      Navigator.pop(context, task);
    } else {
      print('error');
      Navigator.pop(context, null);
    }
  }
}
