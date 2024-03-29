import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../models/task.dart';
import '../models/task_list.dart';
import '../utils/constants.dart';

class TaskListController extends GetxController {
  @override
  void onInit() async {
    // if the app is run for the first time it automatically creates a task list named Inbox
    await _box.writeIfNull(
      taskListKey,
      [
        taskListEncode(
          TaskList.create(
            title: "Inbox",
            color: taskListColors[0],
            isInbox: true,
          ),
        ),
      ],
    );

    // just in case
    _taskLists.clear();

    // fetches the task lists when app runs
    await _getTaskListsFromStorage();

    super.onInit();
  }

  // task list variables
  final selectedColorIndex = 0.obs;
  TextEditingController titleController = TextEditingController();

  final isDragged = false.obs;

  final _taskLists = <TaskList>[];

  final GetStorage _box = GetStorage();

  // return all the task lists
  List<TaskList> get taskLists => _taskLists;

  // return all task lists names
  List<String> get taskListsNames => taskLists.map((e) => e.title).toList();

  Task taskDecode(String encodedTask) {
    // parses the json to Task instance
    return Task.fromJson(jsonDecode(encodedTask.toString()));
  }

  String taskEncode(Task task) {
    // parses Task instance to json
    return jsonEncode(task.toJson());
  }

  TaskList taskListDecode(String encodedTaskList) {
    // parses the json to TaskList instance
    return TaskList.fromJson(jsonDecode(encodedTaskList.toString()));
  }

  String taskListEncode(TaskList taskList) {
    // parses TaskList instance to json
    return jsonEncode(taskList.toJson());
  }

  Future<void> _getTaskListsFromStorage() async {
    await jsonDecode(_box.read(taskListKey).toString()).forEach(
      (e) {
        TaskList taskList = TaskList.fromJson(e);

        // decode tasks in task lists before adding them to TaskLists variable
        List<Task> tasks = [];

        for (final encodedTask in taskList.tasks) {
          Task task = taskDecode(encodedTask);

          tasks.add(task);
        }

        taskList.tasks = tasks;

        _taskLists.add(taskList);
      },
    );
  }

  List<Task> getTasksByDay({
    required DateTime day,
    bool showOverDues = false,
    bool? completed,
  }) {
    List<Task> tasks = [];
    List<Task> allTasks = getAllTaskListsTasks(completed: completed);

    for (final Task taskElement in allTasks) {
      if (taskElement.date != null &&
          dateFromString(taskElement.date)!.compareTo(day) ==
              (showOverDues ? -1 : 0)) {
        tasks.add(taskElement);
      }
    }

    return tasks;
  }

  List<Task> getAllTaskListsTasks({bool? completed}) {
    List<Task> tasks = [];

    // gets all the tasks lists from all the existing task lists
    List<List<dynamic>> taskListsTasks = taskLists.map((e) => e.tasks).toList();

    for (final element in taskListsTasks) {
      for (final task in element) {
        if (completed == null) {
          tasks.add(task);
        } else if (completed) {
          if (task.isCompleted) {
            tasks.add(task);
          }
        } else {
          if (!task.isCompleted) {
            tasks.add(task);
          }
        }
      }
    }

    return tasks;
  }

  List<Task> getTasksFromTaskList({
    required String taskListName,
    bool? completed,
  }) {
    List<Task> tasks = [];
    TaskList taskList = getTaskListInstance(taskListName: taskListName);

    for (final task in taskList.tasks) {
      if (completed == null) {
        tasks.add(task);
      } else if (completed) {
        if (task.isCompleted) {
          tasks.add(task);
        }
      } else {
        if (!task.isCompleted) {
          tasks.add(task);
        }
      }
    }

    return tasks;
  }

  double getTaskListPercent({required TaskList taskList}) {
    return taskList.tasks.isEmpty
        ? 0.0
        : (((100 / taskList.tasks.length) *
                getTasksFromTaskList(
                        taskListName: taskList.title, completed: true)
                    .length) /
            100);
  }

  TaskList getTaskListInstance({required String taskListName}) {
    late TaskList taskList;

    for (final TaskList taskListElement in _taskLists) {
      if (taskListElement.title == taskListName) {
        taskList = taskListElement;
      }
    }
    return taskList;
  }

  void saveChanges() async {
    await _box.write(
      taskListKey,
      _taskLists.map(
        (taskList) {
          // Encode tasks in task lists before saving them in the database
          List<String> tasks = [];
          taskList.tasks.forEach(
            (task) {
              tasks.add(taskEncode(task));
            },
          );

          return taskListEncode(taskList.copyWith(tasks: tasks));
        },
      ).toList(),
    );

    update();
  }

  // checks duplication base on titles
  bool checkTaskListDuplication([TaskList? taskList]) {
    bool isDuplicated = false;

    for (final TaskList taskListElement in _taskLists) {
      if (taskList == null) {
        if (taskListElement.title.toLowerCase() ==
            titleController.text.toLowerCase()) {
          isDuplicated = true;
        }
      } else {
        if (taskListElement.title.toLowerCase() ==
            taskList.title.toLowerCase()) {
          isDuplicated = true;
        }
      }
    }

    return isDuplicated;
  }

  void clearVariablesData() {
    titleController.clear();
    selectedColorIndex.value = 0;
  }

  void addTaskList() {
    TaskList taskList = TaskList.create(
      title: titleController.text,
      color: taskListColors[selectedColorIndex.value],
    );

    if (!checkTaskListDuplication(taskList)) {
      _taskLists.add(taskList);

      saveChanges();
    }
  }

  void updateTaskList({
    required TaskList taskList,
    required TaskList modifiedTaskList,
  }) {
    // get its index in the taskLists variable
    int taskListIndex = _taskLists.indexOf(taskList);

    // remove the old task list
    _taskLists.removeAt(taskListIndex);

    taskList = modifiedTaskList;

    // inset the new one to its previous place
    _taskLists.insert(taskListIndex, taskList);

    saveChanges();
  }

  void updateTaskListDetails({required TaskList taskList}) {
    List<Task> newTasks = [];

    // change all tasks taskListTitle field
    for (final Task task in getTasksFromTaskList(
      taskListName: taskList.title,
    )) {
      task.taskListTile = titleController.text;

      newTasks.add(task);
    }

    TaskList modifiedTaskList = taskList.copyWith(
      title: titleController.text,
      color: taskListColors[selectedColorIndex.value],
      tasks: newTasks,
    );

    updateTaskList(taskList: taskList, modifiedTaskList: modifiedTaskList);
  }

  void updateTaskListTasks({
    required String taskListName,
    required Task task,
    required bool exist,
    Task? newTask,
  }) {
    // get task list instance by selected task list name
    TaskList taskList = getTaskListInstance(taskListName: taskListName);

    if (newTask != null && newTask.taskListTile != task.taskListTile) {
      // in this case the task task list has been changed so we add it to new task list tasks
      TaskList newTaskList =
          getTaskListInstance(taskListName: newTask.taskListTile);

      TaskList modifiedNewTaskList = newTaskList.copyWith();
      modifiedNewTaskList.tasks.add(newTask);
    }

    TaskList modifiedTaskList = taskList.copyWith();

    if (exist) {
      List<Task> newTasks = [];

      // iterate all the tasks in task list and change the state of modified task or update modified task details
      for (final Task taskElement
          in getTasksFromTaskList(taskListName: taskList.title)) {
        if (taskElement.id == task.id) {
          if (newTask == null) {
            // in this case task state has been changed so we add the task to newTasks variable
            newTasks.add(task);
          } else if (newTask.taskListTile != task.taskListTile) {
            // in this case the task task list has been changed so we do nothing to remove it from the previous task list
          } else {
            // is this case task details has been updated so we add new task to newTasks variable
            newTasks.add(newTask);
          }
        } else {
          // it adds other tasks to newTasks variable
          newTasks.add(taskElement);
        }
      }

      // set the new tasks to task list
      modifiedTaskList.tasks = newTasks;
    } else {
      // add the new task to task lists tasks
      modifiedTaskList.tasks.add(task);
    }

    updateTaskList(taskList: taskList, modifiedTaskList: modifiedTaskList);
  }

  void deleteTaskList({required TaskList taskList}) {
    _taskLists.removeWhere((element) => element.title == taskList.title);

    saveChanges();
  }
}
