import 'package:flutter/material.dart';
import 'screens/task_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color.fromARGB(255,165, 201, 202),  
        accentColor: Color.fromARGB(255,44, 51, 51), 
      ),
      home: TaskList(),
    );
  }
}
