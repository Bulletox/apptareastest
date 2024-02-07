import 'package:flutter/material.dart';
import '../models/task.dart';
import 'date_input_widget.dart';

class TaskItemWidget extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final VoidCallback onComplete;
  final VoidCallback onDelete;

  const TaskItemWidget({
    required this.task,
    required this.onTap,
    required this.onComplete,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      color: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(color: Color.fromARGB(255, 209, 163, 255)),
      ),
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        title: Text(
          task.name,
          style: TextStyle(
            color: task.isCompleted ? Colors.green : Color.fromARGB(255, 60, 28, 116),
            fontWeight: FontWeight.bold,
            fontFamily: 'San Francisco',
            decoration: task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.description,
              style: TextStyle(color: Color.fromARGB(255, 60, 28, 116)),
            ),
            Text(
              'Fecha de entrega: ${_formatDate(task.dueDate)}',
              style: TextStyle(color: Color.fromARGB(255, 60, 28, 116)),
            ),
            Text(
              'Días restantes: ${_calculateDaysRemaining(task.dueDate)}',
              style: TextStyle(color: Color.fromARGB(255, 60, 28, 116)),
            ),
          ],
        ),
        onTap: onTap,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.check, color: Colors.green),
              onPressed: onComplete,
            ),
            IconButton(
              icon: Icon(Icons.delete, color: const Color(0xFFCE93D8)),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  int _calculateDaysRemaining(DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(now).inDays;
    return difference;
  }
}
