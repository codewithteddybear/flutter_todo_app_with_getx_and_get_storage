class TaskList {
  TaskList({
    required this.title,
    required this.color,
    required this.tasks,
    required this.isInbox,
  });

  String title;
  String color;
  List<dynamic> tasks;
  bool isInbox;

  factory TaskList.fromJson(Map<String, dynamic> json) => TaskList(
        title: json['title'],
        color: json['color'],
        tasks: json['remainingTasks'],
        isInbox: json['isInbox'],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        'color': color,
        'remainingTasks': tasks,
        'isInbox': isInbox
      };

  TaskList copyWith({
    String? title,
    String? color,
    List<dynamic>? tasks,
  }) =>
      TaskList(
        title: title ?? this.title,
        color: color ?? this.color,
        tasks: tasks ?? this.tasks,
        isInbox: isInbox,
      );

  factory TaskList.create({
    required String title,
    required String color,
    bool? isInbox,
  }) =>
      TaskList(
        title: title,
        color: color,
        tasks: <dynamic>[],
        isInbox: isInbox ?? false,
      );
}
