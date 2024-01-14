import 'package:flutter/cupertino.dart';

class Tasklist{
  List<dynamic> tasklist;

  Tasklist({required this.tasklist});
}

class TasklistProvider extends ChangeNotifier{
  Tasklist _taskList;
  TasklistProvider(this._taskList);

  Tasklist get tasklist => _taskList;

  void setTasklist(Tasklist tasklist){
    _taskList = tasklist;
    notifyListeners();
  }
}