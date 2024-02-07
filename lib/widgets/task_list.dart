import 'package:flutter/material.dart';
import '../models/task.dart'; // Asegúrate de importar la clase Task

class TaskList extends StatelessWidget {
  final List<Task> tasks;
  final Function(Task, bool) onTaskStatusChanged;
  final Function(Task) onTaskTapped;
  final Function(Task) onTaskAdded;
  
  TaskList({
    required this.tasks,
    required this.onTaskStatusChanged,
    required this.onTaskTapped,
    required this.onTaskAdded,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return _buildTaskItem(context, tasks[index]);
        },
      ),
    );
  }

  Widget _buildTaskItem(BuildContext context, Task task) {
    return ListTile(
      title: Text(task.title),
      trailing: Checkbox(
        value: task.isCompleted,
        onChanged: (value) {
          // Llama a la función de callback al cambiar el estado de la tarea
          onTaskStatusChanged(task, value ?? false);
        },
      ),
      onTap: () {
        // Llama a la función de callback al tocar la tarea
        onTaskTapped(task);
      },
    );
  }
}

