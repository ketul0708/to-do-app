import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StartTaskPage extends StatefulWidget {
  @override
  _StartTaskPageState createState() => _StartTaskPageState();
}

class _StartTaskPageState extends State<StartTaskPage> {
  bool isRunning = false;
  DateTime? startTime;
  DateTime? stopTime;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), _updateElapsedTime);
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Timer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Time Elapsed:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              _calculateElapsedTime(),
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  if (isRunning) {
                    stopTime = DateTime.now();
                  } else {
                    startTime = DateTime.now();
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