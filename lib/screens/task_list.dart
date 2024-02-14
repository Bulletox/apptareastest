import 'package:flutter/material.dart';
import '../models/task.dart';
import '../widgets/add_task_dialog.dart';
import '../widgets/task_description_dialog.dart';
import '../widgets/task_item_widget.dart';

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
        backgroundColor: Color.fromARGB(255,57, 91, 100),
        title: Text(
          'Lista de Tareas',
          style: TextStyle(
            fontFamily: 'SanFrancisco',
            fontStyle: FontStyle.normal,
            color: Color.fromARGB(255,231, 246, 242),
          ),
        ),
      ),
      body: Container(
        color: Color.fromARGB(255,44, 51, 51), // Cambia el color de fondo aquí
        child: ListView.builder(
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: Icon(Icons.add),
        shape: CircleBorder(),
        backgroundColor: Color.fromARGB(255,165, 201, 202),
      ),
      bottomNavigationBar: BottomAppBar(
        // shape: CircularNotchedRectangle(),
        color: Color.fromARGB(255,57, 91, 100),
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
    // _showTaskDescription(tasks[index]);
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
