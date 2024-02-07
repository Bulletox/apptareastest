import 'package:flutter/material.dart';
import 'task.dart';
import 'date_input_widget.dart';

class AddTaskDialog extends StatefulWidget {
  final Function(String, String, DateTime) onAddTask;

  const AddTaskDialog({required this.onAddTask});

  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> with SingleTickerProviderStateMixin {
  TextEditingController _taskNameController = TextEditingController();
  TextEditingController _taskDescriptionController = TextEditingController();
  DateTime? _selectedDate;
  final _formKey = GlobalKey<FormState>();

  late AnimationController _animationController;
  late Animation<EdgeInsets> _paddingAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _paddingAnimation = EdgeInsetsTween(
      begin: EdgeInsets.zero,
      end: EdgeInsets.only(
        bottom: 50, // Este valor puede ajustarse según la altura del teclado
      ),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.fastOutSlowIn,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    _paddingAnimation = EdgeInsetsTween(
      begin: EdgeInsets.zero,
      end: EdgeInsets.only(
        bottom: mediaQuery.viewInsets.bottom + 20, // Ajuste según la altura del teclado
      ),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.fastOutSlowIn,
    ));

    return AnimatedBuilder(
      animation: _paddingAnimation,
      builder: (context, child) {
        return AnimatedPadding(
          padding: _paddingAnimation.value,
          duration: Duration(milliseconds: 300),
          child: AlertDialog(
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
          ),
        );
      },
    );
  }
}
