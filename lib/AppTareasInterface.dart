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
  TextEditingController _taskNameController = TextEditingController();
  TextEditingController _taskDescriptionController = TextEditingController();
  TextEditingController _dueDateController = TextEditingController();
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Tareas'),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return Card(
            color: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: BorderSide(color: Color.fromARGB(255, 209, 163, 255)),
            ),
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              title: Text(
                tasks[index].name,
                style: TextStyle(
                  color: tasks[index].isCompleted ? Colors.green : Color.fromARGB(255, 60, 28, 116),fontWeight: FontWeight.bold,
                  decoration: tasks[index].isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tasks[index].description,
                    style: TextStyle(color: Color.fromARGB(255, 60, 28, 116)),
                  ),
                  Text(
                    'Fecha de entrega: ${_formatDate(tasks[index].dueDate)}',
                    style: TextStyle(color: Color.fromARGB(255, 60, 28, 116)),
                  ),
                  Text(
                    'Días restantes: ${_calculateDaysRemaining(tasks[index].dueDate)}',
                    style: TextStyle(color: Color.fromARGB(255, 60, 28, 116)),
                  ),
                ],
              ),
              onTap: () {
                _showTaskDescription(
                  tasks[index].name,
                  tasks[index].description,
                  _formatDate(tasks[index].dueDate),
                );
              },
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.check, color: Colors.green),
                    onPressed: () {
                      _completeTask(index);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: const Color(0xFFCE93D8)),
                    onPressed: () {
                      _removeTask(index);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addTask();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _dueDateController.text = _formatDate(_selectedDate!);
      });
    }
  }

  void _addTaskToList(
      String taskName, String taskDescription, DateTime dueDate) {
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
    _showTaskDescription(
      tasks[index].name,
      tasks[index].description,
      _formatDate(tasks[index].dueDate),
    );
  }

  void _addTask() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Nueva Tarea'),
              content: Column(
                children: [
                  TextField(
                    controller: _taskNameController,
                    autofocus: true,
                    decoration: const InputDecoration(
                        labelText: 'Nombre de la tarea'),
                  ),
                  TextField(
                    controller: _taskDescriptionController,
                    decoration: const InputDecoration(
                        labelText: 'Descripción de la tarea'),
                  ),
                  InkWell(
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                      );

                      if (pickedDate != null) {
                        setState(() {
                          _selectedDate = pickedDate;
                          _dueDateController.text = _formatDate(_selectedDate!);
                        });
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
                            _selectedDate != null
                                ? _formatDate(_selectedDate!)
                                : 'Seleccione la fecha',
                            style: const TextStyle(color: Color.fromARGB(255, 60, 28, 116), fontWeight: FontWeight.bold),
                          ),
                          const Icon(Icons.calendar_today, color: Colors.black87),
                        ],
                      ),
                    ),
                  ),
                ],
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
                    _addTaskToList(
                      _taskNameController.text,
                      _taskDescriptionController.text,
                      _selectedDate ?? DateTime.now(),
                    );
                    _taskNameController.clear();
                    _taskDescriptionController.clear();
                    _dueDateController.clear();
                    _selectedDate = null;
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFCE93D8),
                  ),
                  child: const Text('Guardar Tarea'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showTaskDescription(
      String taskName, String taskDescription, String dueDate) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    taskName,
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Descripción: $taskDescription'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Fecha de entrega: $dueDate'),
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
      },
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
