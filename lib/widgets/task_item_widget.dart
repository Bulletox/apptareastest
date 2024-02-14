import 'package:flutter/material.dart';
import '../models/task.dart';
import 'date_input_widget.dart';

/// Widget que representa un elemento de tarea en la lista de tareas.
/// 
/// Este widget muestra la información de una tarea, incluyendo su nombre, descripción,
/// fecha de entrega y días restantes. También permite marcar la tarea como completada
/// y eliminarla de la lista.
class TaskItemWidget extends StatefulWidget {
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
  _TaskItemWidgetState createState() => _TaskItemWidgetState();
}

class _TaskItemWidgetState extends State<TaskItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      color: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(15.0), // Cambia el radio de la esquina aquí
        side: BorderSide(
          color: Color.fromARGB(255, 57, 91, 100),
          width: 1.0, // Cambia el ancho del borde aquí
        ),
      ),
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        title: Text(
          widget.task.name,
          style: TextStyle(
            color: widget.task.isCompleted
                ? Colors.green
                : Color.fromARGB(255,44, 51, 51),
            fontWeight: FontWeight.bold,
            fontFamily: 'SanFrancisco',
            decoration: widget.task.isCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.task.description,
              style: TextStyle(color: Color.fromARGB(255, 231, 246, 242)),
            ),
            Text(
              'Fecha de entrega: ${_formatDate(widget.task.dueDate)}',
              style: TextStyle(color: Color.fromARGB(255, 231, 246, 242)),
            ),
            Text(
              'Días restantes: ${_calculateDaysRemaining(widget.task.dueDate)}',
              style: TextStyle(color: Color.fromARGB(255, 231, 246, 242)),
            ),
          ],
        ),
        onTap: widget.onTap,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: widget.task.isCompleted,
              onChanged: (value) {
                setState(() {
                  widget.task.isCompleted = value!;
                });
                widget.onComplete();
              },
              activeColor: Colors.green,
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Color.fromARGB(255,44, 51, 51)),
              onPressed: widget.onDelete,
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
