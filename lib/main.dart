import 'package:flutter/material.dart';
import 'package:flutter_1/AppPages/ChangePasswordForm.dart';
import 'package:flutter_1/AppPages/EditTaskPage.dart';
import 'package:flutter_1/AppPages/HomePage.dart';
import 'package:flutter_1/AppPages/NewTaskPage.dart';
import 'package:flutter_1/Models/TaskList.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AppPages/AccountPage.dart';
import 'AppPages/LoginPage.dart';
import 'AppPages/SignUpPage.dart';
import 'AppPages/StartTaskPage.dart';

Future<void> main() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var session = prefs.getBool("session");
  debugPrint(session.toString());

  final GoRouter router = GoRouter(
    initialLocation: session == true ? '/home' : '/',
    navigatorKey: GlobalKey<NavigatorState>(),
    routes: [
      GoRoute(
          name: 'login',
          path: '/',
          builder: (BuildContext context, GoRouterState state) {
            return const LoginPage();
          }
      ),
      GoRoute(
          name: 'signup',
          path: '/signup',
          builder: (BuildContext context, GoRouterState state) {
            return const SignUpPage();
          }
      ),
      GoRoute(
          name: 'account',
          path: '/account',
          builder: (BuildContext context, GoRouterState state) {
            return const AccountPage();
          }
      ),
      GoRoute(
          name: 'changepwd',
          path: '/account/password',
          builder: (BuildContext context, GoRouterState state) {
            return const ChangePasswordPage();
          }
      ),
      GoRoute(
          name: 'home',
          path: '/home',
          builder: (BuildContext context, GoRouterState state) {
            return const HomePage();
          }
      ),
      GoRoute(
          name: 'newTask',
          path: '/newtask',
          builder: (BuildContext context, GoRouterState state) {
            return const NewTaskPage();
          }
      ),
      GoRoute(
          name: 'editTask',
          path: '/editTask',
          builder: (BuildContext context, GoRouterState state) {
            return const EditTaskPage();
          }
      ),
      GoRoute(
          name: 'startTask',
          path: '/startTask',
          builder: (BuildContext context, GoRouterState state) {
            return StartTaskPage();
          }
      ),
    ],
  );
  
  runApp(
    ChangeNotifierProvider<TasklistProvider>(
        create: (context) => TasklistProvider(Tasklist(tasklist: [])),
        child:  MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: router,
          title: 'Stock Trading App',
          theme: ThemeData.dark(),
          darkTheme: ThemeData.dark(),
        )
    )
  );
}