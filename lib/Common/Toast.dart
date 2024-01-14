import 'package:flutter/material.dart';

class ToastWidget extends StatelessWidget {
  final String message;

  const ToastWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Text(message),
      ),
    );
  }
}

class ToastService {
  static void showToast(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: ToastWidget(message: message),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
