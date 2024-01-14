import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jumping_dot/jumping_dot.dart';

import '../Common/ErrorBox.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SignUpForm(),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  SignUpFormState createState() => SignUpFormState();
}

class SignUpFormState extends State<SignUpForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  Widget errorBox = Container();
  bool _signedUp = false;
  Widget subChild = const Text("Sign Up");

  void _signUp() async {
    setState(() {
      subChild = JumpingDots(
        color: Colors.white,
        radius: 5,
        numberOfDots: 3,
      );
    });
    // Perform sign-up logic here
    String email = _emailController.text;
    String password = _passwordController.text;

    final url = Uri.parse("http://localhost:3000/todo/signup");
    var res = await http.post(
      url,
      headers: <String, String>{'Content-Type': 'application/json'},
      body: json.encode({'userId': email, 'password': password})
    );
    debugPrint(res.body);
    if(res.statusCode != 200){
      setState(() {
        errorBox=ErrorBox(error: "Some error occurred, statusCode: ${res.statusCode}");
        subChild = const Text("Sign Up");
      });
      return;
    }
    else{
      if(res.body.toString()=='unavailable'){
        setState(() {
          errorBox=ErrorBox(error: "Username not available");
          subChild = const Text("Sign Up");
        });
      }
      else{
        context.go('/');
      }
    }
    setState(() {
      _signedUp=true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Create new Account", style: TextStyle(fontSize: 20),),
          const SizedBox(height: 16.0),
          errorBox,
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Username',
            ),
            onTap: (){
              setState(() {
                errorBox=Container();
              });
            },
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: 'Password',
            ),
            onTap: (){
              setState(() {
                errorBox=Container();
              });
            },
            obscureText: true,
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _confirmPasswordController,
            decoration: const InputDecoration(
              labelText: 'Confirm Password',
            ),
            obscureText: true,
            onTap: (){
              setState(() {
                errorBox=Container();
              });
            },
          ),
          const SizedBox(height: 24.0),
          ElevatedButton(
            onPressed: (){
              if(_emailController.text.isEmpty){
                setState(() {
                  errorBox = ErrorBox(error: "Enter valid username");
                });
              }
              else if(_passwordController.text != _confirmPasswordController.text){
                setState(() {
                  errorBox = ErrorBox(error: "Password do not match");
                });
              }
              else{
                _signUp();
              }
            },
            child: subChild,
          ),
          const SizedBox(height: 16.0),
          TextButton(
              onPressed: (){
                context.go("/");
              },
              child: const Text("Already have an account? Sign in")),
        ],
      ),
    );
  }
}