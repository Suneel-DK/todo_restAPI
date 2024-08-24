import 'package:flutter/material.dart';
import 'package:todo_app/screens/addtask.dart';
import 'package:todo_app/screens/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home:const HomePage(),
      routes: {
        'addTask':(context)=> const AppTask()
      },
    );
  }
}
