import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_1/Models/TaskList.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../Models/Task.dart';
import 'package:http/http.dart' as http;

int editIndex = -1;
Task editTask = Task(title: "", desc: "", priority: "", deadline: "");

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {

  List<dynamic> tasklist = [];
  void getTasklist() async {
    final url = Uri.parse('http://localhost:3000/todo/tasklist/123');
    var res = await http.get(
      url,
      headers: <String, String>{'Content-Type': 'application/json'},
    );

    var data = json.decode(res.body);
    setState(() {
      tasklist = data['tasklist'];
    });
  }

  void removeTask(Task task) async {
    final url = Uri.parse('http://localhost:3000/todo/removetasklist/123');
    var res = await http.put(
      url,
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode({'task':[task.title, task.desc, task.priority, task.deadline]})
    );

    debugPrint(res.body.toString());
  }

  @override
  void initState(){
    getTasklist();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TasklistProvider tasklistProvider = context.watch<TasklistProvider>();
    Tasklist tasklistP = tasklistProvider.tasklist;
    return Scaffold(
      appBar: AppBar(
        title: const Text("To Do App"),
      ),
      body: ListView.builder(
        itemCount: tasklist.length,
        itemBuilder: (context, index){
          List<dynamic> taskData = tasklist[index];
          Task task = Task(title: taskData[0], desc: taskData[1], priority: taskData[2], deadline: taskData[3]);
          return Card(
            child: ListTile(
              title: Text(task.title),
              subtitle: Text(task.desc),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.play_circle),
                    onPressed: () {
                      context.go("/startTask");
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      editIndex=index;
                      editTask = task;
                      debugPrint(editIndex.toString());
                      context.go("/editTask");
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context){
                            return AlertDialog(
                              title: const Text("Are you sure"),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('No'),
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Close the dialog
                                  },
                                ),
                                TextButton(
                                  child: const Text('Yes'),
                                  onPressed: () {
                                    setState(() {
                                      removeTask(task);
                                      tasklist.removeAt(index);
                                    });
                                    Navigator.of(context).pop(); // Close the dialog
                                  },
                                ),
                              ],
                            );
                          }
                      );
                    },
                  ),
                ],
              ),
            )
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          context.go("/newtask");
        },
        tooltip: 'Add a Todo',
        child: const Icon(Icons.add),
      ),
    );
  }

}
