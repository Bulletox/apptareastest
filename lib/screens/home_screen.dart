import 'package:flutter/material.dart';
import '../models/task.dart';
import '../widgets/task_list.dart';
import 'package:apptareastest/screens/task_form_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> tasks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mis Tareas',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TaskList(
              onTaskAdded: _addTask,
              tasks: tasks,
              onTaskStatusChanged: _onTaskStatusChanged,
              onTaskTapped: _onTaskTapped,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // _navigateToTaskForm(context);
        },
        tooltip: 'Agregar Tarea',
        child: Icon(Icons.add),
      ),
    );
  }

  void _onTaskStatusChanged(Task task, bool newValue) {
    // Implementa la lógica para marcar/desmarcar una tarea como completada
    setState(() {
      task.isCompleted = newValue;
    });
  }

  void _onTaskTapped(Task task) {
    // Implementa la lógica para ver o editar una tarea cuando se toque en ella
    // Puedes navegar a otra pantalla para ver/editar detalles.
    print('Tarea tocada: ${task.title}');
  }

    void _addTask(Task newTask) {
    setState(() {
      tasks.add(newTask);
    });
  }

  void _navigateToTaskForm(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskFormScreen(onTaskAdded: _addTask)),
    );
}
}