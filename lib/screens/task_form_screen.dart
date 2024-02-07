import 'package:flutter/material.dart';
import '../models/task.dart'; // Asegúrate de importar la clase Task
import 'package:apptareastest/screens/home_screen.dart';

class TaskFormScreen extends StatefulWidget {
  final Function(Task) onTaskAdded;

  TaskFormScreen({required this.onTaskAdded});

  @override
  _TaskFormScreenState createState() => _TaskFormScreenState(onTaskAdded: onTaskAdded);
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  TextEditingController _titleController = TextEditingController();
  final Function(Task) onTaskAdded;
  _TaskFormScreenState({required this.onTaskAdded});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Tarea'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Título de la tarea',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _saveTask(context);
              },
              child: Text('Guardar Tarea'),
            ),
          ],
        ),
      ),
    );
  }

  // Método para guardar la tarea y cerrar la pantalla
  void _saveTask(BuildContext context) {
    String title = _titleController.text.trim();

    if (title.isNotEmpty) {
      Task newTask = Task(
        id: DateTime.now().toString(),
        title: title,
      );

      // Llama a la función de callback para agregar la tarea
      widget.onTaskAdded(newTask);

      Navigator.pop(context, newTask);
    } else {
      // Muestra un mensaje de error si el título está vacío
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('El título de la tarea no puede estar vacío.'),
        ),
      );
    }
  }
}
