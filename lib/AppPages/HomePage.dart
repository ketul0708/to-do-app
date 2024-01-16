import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_1/Models/TaskList.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/Task.dart';
import 'package:http/http.dart' as http;

int editIndex = -1;
Task editTask = Task(id: "" ,title: "", desc: "", priority: "", deadline: "", completed: "", start: "", end: "");
Task startTask = Task(id: "" ,title: "", desc: "", priority: "", deadline: "", completed: "", start: "", end: "");

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {

  List<dynamic> tasklist = [];
  void getTasklist() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? username = sharedPreferences.getString('userId');
    final url = Uri.parse('http://localhost:3000/todo/tasklist/$username');
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
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? username = sharedPreferences.getString('userId');
    final url = Uri.parse('http://localhost:3000/todo/removetasklist/$username');
    var res = await http.put(
      url,
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode({'task':[task.id, task.title, task.desc, task.priority, task.deadline, task.completed, task.start, task.end]})
    );

    debugPrint(res.body.toString());
  }

  Future<void> logOut() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("session", false);
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
        actions: [
          Container(
            padding: const EdgeInsets.all(10),
            child: TextButton(onPressed: (){
            logOut();
            context.go("/");
          }, child: const Text("Log Out", style: TextStyle(fontSize: 20),)),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: tasklist.length,
        itemBuilder: (context, index){
          List<dynamic> taskData = tasklist[index];
          Task task = Task(id: taskData[0], title: taskData[1], desc: taskData[2], priority: taskData[3], deadline: taskData[4], completed: taskData[5], start: taskData[6], end: taskData[7]);
          return Card(
            child: ListTile(
              title: Text(task.completed=="False" ? task.title : "${task.title} - Completed", style: TextStyle(fontSize: 18, color: task.priority=="High" ? Colors.red : (task.priority=="Medium" ? Colors.yellow : Colors.green)),),
              subtitle: Container(
                alignment: Alignment.centerLeft,
                width: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, 
                  children: [
                    Text(task.desc), 
                    const SizedBox(height: 5,),
                    Text("Due - ${task.deadline}")]),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.play_circle),
                    onPressed: () {
                      startTask = task;
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

