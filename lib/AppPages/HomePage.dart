import 'package:flutter/material.dart';
import 'package:flutter_1/Models/TaskList.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../Models/Task.dart';

int editIndex = -1;
Task editTask = Task(title: "", desc: "", priority: "", deadline: "");

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    TasklistProvider tasklistProvider = context.watch<TasklistProvider>();
    Tasklist tasklist = tasklistProvider.tasklist;
    return Scaffold(
      appBar: AppBar(
        title: const Text("To Do App"),
      ),
      body: ListView.builder(
        itemCount: tasklist.tasklist.length,
        itemBuilder: (context, index){
          Task task = tasklist.tasklist[index];
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
                      editTask = tasklist.tasklist[index];
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
                                      tasklist.tasklist.removeAt(index);
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
