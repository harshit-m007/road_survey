import 'package:flutter/material.dart';
import 'pages/home.dart';
import 'pages/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key); // Constructor with named 'key' parameter

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Road Athena',
      initialRoute: '/',  // Default route (LoginPage)
      routes: {
        '/': (context) =>  LoginPage(), // Login screen route
        '/home': (context) => HomePage(), // Home screen route
      },
    );
  }
}
