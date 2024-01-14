import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ChangePasswordForm.dart';

class AccountPage extends StatefulWidget{

  const AccountPage({super.key});

  @override
  AccountPageState createState() => AccountPageState();
}

class AccountPageState extends State<AccountPage> {
  String username = "";

  void _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('userId')!;
    });
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final multiplier = screenWidth > 600 ? 1.0 : 0.5;
    _getData();
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
              padding: const EdgeInsets.all(5),
              child: TextButton(
                onPressed: (){
                  context.go("/home");
                },
                child: const Text("Home"),
              )
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(100*multiplier),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Username: $username', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            // const SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: () {
            //     // Code to delete account
            //     // You can show a confirmation dialog before deleting
            //   },
            //   child: const Text('Delete Account'),
            // ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Navigate to ChangePasswordPage
                context.go('/account/password');
              },
              child: const Text('Change Password'),
            ),
          ],
        ),
      ),
    );
  }
}
