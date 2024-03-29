import 'package:uuid/uuid.dart';

class Task {
  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.priority,
    required this.taskListTile,
    required this.isCompleted,
  });

  String id;
  String title;
  String description;
  String? date;
  int priority;
  String taskListTile;
  bool isCompleted;

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        date: json['date'],
        priority: json['priority'],
        taskListTile: json['taskListTile'],
        isCompleted: json['isCompleted'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        'description': description,
        'date': date,
        'priority': priority,
        'taskListTile': taskListTile,
        'isCompleted': isCompleted
      };

  factory Task.create({
    required String title,
    required String description,
    required String? date,
    required int priority,
    required String taskListTile,
  }) =>
      Task(
        id: const Uuid().v1(),
        title: title,
        description: description,
        date: date,
        priority: priority,
        taskListTile: taskListTile,
        isCompleted: false,
      );
}
