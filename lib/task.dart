class Task {
  String name;
  String description;
  DateTime dueDate;
  bool isCompleted;

  Task(this.name, this.description, this.dueDate, {this.isCompleted = false});
}
