import 'package:flutter/material.dart';

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

class Task {
  String name;
  String description;
  DateTime dueDate;
  bool isCompleted;

  Task(this.name, this.description, this.dueDate, {this.isCompleted = false});
}

class TaskList extends StatefulWidget {
  const TaskList({Key? key}) : super(key: key);

  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  List<Task> tasks = [];
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lista de Tareas',
          style: TextStyle(
            fontFamily: 'SanFrancisco',
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return TaskItemWidget(
            task: tasks[index],
            onTap: () => _showTaskDescription(tasks[index]),
            onComplete: () => _completeTask(index),
            onDelete: () => _removeTask(index),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: Icon(Icons.add),
        shape: CircleBorder(),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: Colors.blue,
        child: IconTheme(
          data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                tooltip: 'Buscar',
                icon: const Icon(Icons.search),
                onPressed: () {},
              ),
              IconButton(
                tooltip: 'Favorito',
                icon: const Icon(Icons.favorite),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addTaskToList(String taskName, String taskDescription, DateTime dueDate) {
    setState(() {
      tasks.add(Task(taskName, taskDescription, dueDate));
      tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    });
  }

  void _removeTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  void _completeTask(int index) {
    setState(() {
      tasks[index].isCompleted = true;
    });
    _showTaskDescription(tasks[index]);
  }

  void _addTask() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddTaskDialog(
          onAddTask: _addTaskToList,
        );
      },
    );
  }

  void _showTaskDescription(Task task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TaskDescriptionDialog(task: task);
      },
    );
  }
}

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

class AddTaskDialog extends StatefulWidget {
  final Function(String, String, DateTime) onAddTask;

  const AddTaskDialog({required this.onAddTask});

  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  TextEditingController _taskNameController = TextEditingController();
  TextEditingController _taskDescriptionController = TextEditingController();
  DateTime? _selectedDate;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nueva Tarea'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _taskNameController,
                autofocus: true,
                decoration: const InputDecoration(labelText: 'Nombre de la tarea'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un nombre de tarea';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _taskDescriptionController,
                decoration: const InputDecoration(labelText: 'Descripción de la tarea'),
              ),
              DateInputWidget(
                selectedDate: _selectedDate,
                onSelectDate: (date) {
                  setState(() {
                    _selectedDate = date;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onAddTask(
                _taskNameController.text,
                _taskDescriptionController.text,
                _selectedDate ?? DateTime.now(),
              );
              _taskNameController.clear();
              _taskDescriptionController.clear();
              Navigator.of(context).pop();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFCE93D8),
          ),
          child: const Text('Guardar Tarea'),
        ),
      ],
    );
  }
}


class TaskDescriptionDialog extends StatelessWidget {
  final Task task;

  const TaskDescriptionDialog({required this.task});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                task.name,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('Descripción: ${task.description}'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('Fecha de entrega: ${_formatDate(task.dueDate)}'),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
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

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }
}

class DateInputWidget extends StatelessWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime?> onSelectDate;

  const DateInputWidget({
    required this.selectedDate,
    required this.onSelectDate,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2101),
        );

        if (pickedDate != null) {
          onSelectDate(pickedDate);
        }
      },
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Fecha de entrega',
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              selectedDate != null ? _formatDate(selectedDate!) : 'Seleccione la fecha',
              style: const TextStyle(color: Color.fromARGB(255, 60, 28, 116), fontWeight: FontWeight.bold),
            ),
            const Icon(Icons.calendar_today, color: Colors.black87),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }
}
