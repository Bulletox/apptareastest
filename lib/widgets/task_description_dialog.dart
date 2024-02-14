import 'package:flutter/material.dart';
import '../models/task.dart';

/// A dialog that displays the details of a task, including its name, description, and due date.
///
/// This dialog is used to show the details of a task in a modal dialog box.
/// It displays the task's name, description, and due date.
/// The user can close the dialog by tapping the "Cerrar" button.
class TaskDescriptionDialog extends StatelessWidget {
  final Task task;

  const TaskDescriptionDialog({required this.task});

  @override
  Widget build(BuildContext context) {
    // Build the dialog content
    return Dialog(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the task name
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                task.name,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            // Display the task description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('Descripción: ${task.description}'),
            ),
            // Display the task due date
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('Fecha de entrega: ${_formatDate(task.dueDate)}'),
            ),
            // Close button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      // Close the dialog
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cerrar'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Formats the given date as a string in the format "YYYY-MM-DD".
  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }
}
