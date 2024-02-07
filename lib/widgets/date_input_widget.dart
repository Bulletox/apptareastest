import 'package:flutter/material.dart';

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
            if (selectedDate != null)
              Text(
                _formatDate(selectedDate!),
                style: const TextStyle(color: Color.fromARGB(255, 60, 28, 116), fontWeight: FontWeight.bold),
              )
            else
              const Text(
                'Seleccione la fecha',
                style: TextStyle(color: Colors.grey),
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
