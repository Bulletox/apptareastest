import 'package:flutter/material.dart';
import 'widgets/task_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 235, 221, 249), // Naranja Medio
        accentColor: Color.fromARGB(255, 209, 163, 255), // Naranja Claro
      ),
      home: TaskList(),
    );
  }
}
