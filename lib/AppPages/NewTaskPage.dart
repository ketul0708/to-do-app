import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_1/Common/DateAndTimePicker.dart';
import 'package:flutter_1/Common/ErrorBox.dart';
import 'package:flutter_1/Models/TaskList.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/Task.dart';
import 'package:http/http.dart' as http;

class NewTaskPage extends StatefulWidget{
  const NewTaskPage({super.key});

  @override
  NewTaskPageState createState() => NewTaskPageState();
}

class NewTaskPageState extends State<NewTaskPage>{
  final TextEditingController _titleTextController = TextEditingController();
  final TextEditingController _descTextController = TextEditingController();
  String title = "";
  String desc = "";
  String selectedPriority = '';
  String selectedDate = "";
  Widget errorBox = Container();

  bool validateForm(){
    if(title.isEmpty || desc.isEmpty || selectedPriority.isEmpty){
      return false;
    }
    else{
      return true;
    }
  }

  Future<void> addTask(Task task) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? username = sharedPreferences.getString('userId');
    String apiUrl = 'http://localhost:3000/todo/tasklist/$username';

    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'task':[task.id, task.title, task.desc, task.priority, task.deadline, task.completed, task.start, task.end]
      }),
    );

    if (response.statusCode == 200) {
      debugPrint('Item added successfully');
    } else {
      debugPrint('Failed to add item. Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context){
    TasklistProvider tasklistProvider = context.watch<TasklistProvider>();
    Tasklist tasklist = tasklistProvider.tasklist;
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Task"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              width: 300,
              padding: const EdgeInsets.fromLTRB(50, 50, 20, 0),
              child: errorBox
          ),
          Container(
            width: 300,
            padding: const EdgeInsets.fromLTRB(50, 10, 20, 0),
            child: const Text("Title")
          ),
          Container(
            width: 300,
            padding: const EdgeInsets.fromLTRB(50, 0, 20, 20),
            child: TextField(
              controller: _titleTextController,
              maxLength: 25,
              decoration: const InputDecoration(
                counterText: ""
              ),
              autofocus: false,
              onChanged: (String value){
                setState(() {
                  title=value;
                });
              },
            ),
          ),
          Container(
            width: 300,
            padding: const EdgeInsets.fromLTRB(50, 20, 20, 0),
            child: const Text("Description")
          ),
          Container(
            width: 300,
            padding: const EdgeInsets.fromLTRB(50, 0, 20, 20),
            child: TextField(
              inputFormatters: [LengthLimitingTextInputFormatter(300)],
              controller: _descTextController,
              maxLength: 125,
              maxLines: 5,
              decoration: const InputDecoration(
                counterText: ""
              ),
              autofocus: false,
              onChanged: (String value){
                setState(() {
                  desc=value;
                });
              },
            ),
          ),
          Container(
              width: 300,
              padding: const EdgeInsets.fromLTRB(50, 20, 20, 20),
              child: const Text("Priority")
          ),
          Container(
            width: 300,
            padding: const EdgeInsets.fromLTRB(50, 0, 20, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Radio(
                      value: "Low",
                      groupValue: selectedPriority,
                      onChanged: (String? value) {
                        setState(() {
                          selectedPriority = value!;
                        });
                      },
                    ),
                    const Text("Low", style: TextStyle(color: Colors.green),),
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      value: "Medium",
                      groupValue: selectedPriority,
                      onChanged: (String? value) {
                        setState(() {
                          selectedPriority = value!;
                        });
                      },
                    ),
                    const Text("Medium", style: TextStyle(color: Colors.yellow),),
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      value: "High",
                      groupValue: selectedPriority,
                      onChanged: (String? value) {
                        setState(() {
                          selectedPriority = value!;
                        });
                      },
                    ),
                    const Text("High", style: TextStyle(color: Colors.red),),
                  ],
                )
              ],
            )
          ),
          Container(
              width: 300,
              padding: const EdgeInsets.fromLTRB(50, 0, 20, 20),
              child: DateAndTimePicker(
                initialDate: "YYYY-MM-DD",
                title: 'Deadline',
                onDataSubmission: (String date) {
                  setState(() {
                    selectedDate = date;
                  });
                },
              )
          ),
          Container(
              width: 300,
              padding: const EdgeInsets.fromLTRB(50, 0, 20, 20),
              child: ElevatedButton(
                onPressed: () {
                  String id = randomAlphaNumeric(6);
                  if(validateForm()){
                    tasklist.tasklist.add(
                        Task(
                          id: id,
                          title: _titleTextController.text,
                          desc: _descTextController.text,
                          priority: selectedPriority,
                          deadline: selectedDate,
                          completed: "False",
                          start: "",
                          end: ""
                        )
                    );
                    tasklistProvider.setTasklist(tasklist);
                    addTask(Task(
                        id: id,
                        title: _titleTextController.text,
                        desc: _descTextController.text,
                        priority: selectedPriority,
                        deadline: selectedDate,
                        completed: "False",
                        start: "",
                        end: ""
                      )
                    );
                    context.go("/home");
                  }
                  else{
                    setState(() {
                      errorBox = ErrorBox(error: "Fill all the fields");
                    });
                  }
                },
                child: const Text("Save"),
              )
          ),
        ],
      ),
    );
  }

  Widget buildRadioButton(String priority, Color color) {
    return Row(
      children: [
        Radio(
          value: priority,
          groupValue: selectedPriority,
          onChanged: (String? value) {
            setState(() {
              selectedPriority = value!;
            });
          },
        ),
        Text(priority, style: TextStyle(color: color),),
      ],
    );
  }
}

