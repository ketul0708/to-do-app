import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_1/AppPages/HomePage.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Models/Task.dart';

class StartTaskPage extends StatefulWidget {
  const StartTaskPage({super.key});

  @override
  StartTaskPageState createState() => StartTaskPageState();
}

class StartTaskPageState extends State<StartTaskPage> {
  bool isRunning = false;
  DateTime? startTime;
  DateTime? stopTime;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), _updateElapsedTime);
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Future<void> _startTask(String id) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? username = sharedPreferences.getString('userId');
    String apiUrl = 'http://localhost:3000/todo/start/$username';

    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'task': [id],
        'startTime': DateTime.now().toString()
      }),
    );
    debugPrint(response.body.toString());
    if (response.statusCode == 200) {
      debugPrint('Task started successfully');
    } else {
      debugPrint('Failed to Start. Error: ${response.statusCode}');
    }
  }

  Future<void> _endTask(String id) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? username = sharedPreferences.getString('userId');
    String apiUrl = 'http://localhost:3000/todo/end/$username';

    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'task': [id],
        'endTime': DateTime.now().toString()
      }),
    );
    debugPrint(response.body.toString());
    if (response.statusCode == 200) {
      debugPrint('Task ended successfully');
    } else {
      debugPrint('Failed to end. Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Timer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Time Elapsed:',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              _calculateElapsedTime(),
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  if (isRunning) {
                    stopTime = DateTime.now();
                    _endTask(startTask.id);
                    context.go("/home");
                  } else {
                    startTime = DateTime.now();
                    _startTask(startTask.id);
                  }
                  isRunning = !isRunning;
                });
              },
              icon: Icon(isRunning ? Icons.stop : Icons.play_arrow),
              label: Text(isRunning ? 'Stop' : 'Start'),
            ),
          ],
        ),
      ),
    );
  }

  void _updateElapsedTime(Timer timer) {
    setState(() {});
  }

  String _calculateElapsedTime() {
    if (startTime == null) {
      return '00:00:00';
    }

    DateTime endTime = stopTime ?? DateTime.now();
    Duration duration = endTime.difference(startTime!);

    String twoDigits(int n) => n.toString().padLeft(2, '0');

    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));

    return '$hours:$minutes:$seconds';
  }
}