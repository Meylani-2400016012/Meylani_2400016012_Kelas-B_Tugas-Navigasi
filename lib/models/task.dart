class Task {
  String title;
  String description;
  String deadline;
  String priority;
  bool isDone;

  Task({
    required this.title,
    required this.description,
    required this.deadline,
    required this.priority,
    this.isDone = false,
  });
}