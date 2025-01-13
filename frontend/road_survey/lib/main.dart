import 'package:flutter/material.dart';
// import 'pages/home.dart';
// import 'pages/login.dart';
import 'pages/project_details.dart';
import 'pages/road_details.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Road Athena',
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          
          case '/':
            return MaterialPageRoute(builder: (_) => ProjectDetailsPage());
          case '/roadDetails':
            if (settings.arguments is String) {
              final selectedRoad = settings.arguments as String;
              return MaterialPageRoute(
                builder: (_) => RoadDetailsPage(selectedRoad: selectedRoad),
              );
            }
            return MaterialPageRoute(
              builder: (_) => const Scaffold(
                body: Center(
                  child: Text('Invalid or missing argument for RoadDetailsPage'),
                ),
              ),
            );
          default:
            return MaterialPageRoute(
              builder: (_) => const Scaffold(
                body: Center(child: Text('Page not found')),
              ),
            );
        }
      },
    );
  }
}