import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorBox extends StatelessWidget{

  String error;
  ErrorBox({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Color.fromRGBO(Colors.red.red, Colors.red.green, Colors.red.blue, 0.1),
        border: Border.all(color: Colors.red, ),
        borderRadius: const BorderRadius.all(Radius.circular(2.0))
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(CupertinoIcons.exclamationmark_triangle, size: 17, color: Colors.redAccent,),
          const Padding(padding: EdgeInsets.all(5)),
          Text(error, style: const TextStyle(color: Colors.redAccent),)
        ],
      ),
    );
  }

}