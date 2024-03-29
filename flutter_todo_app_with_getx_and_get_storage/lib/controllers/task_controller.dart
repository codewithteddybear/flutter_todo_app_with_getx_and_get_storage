import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/task.dart';
import '../models/task_list.dart';
import '../utils/constants.dart';
import 'task_list_controller.dart';

class TaskController extends GetxController {
  @override
  void onReady() {
    // used to update screen after controllers are initialized
    update();

    super.onReady();
  }

  final taskListController = Get.find<TaskListController>();

  DateTime? date;
  int priority = 4;
  String? taskListName;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  void clearVariablesData() {
    titleController.clear();
    descriptionController.clear();
    date = null;
    priority = 4;
    taskListName = null;
  }

  void addTask() {
    // if user doesn't select a task list name it automatically set as Inbox
    taskListName =
        taskListName ?? taskListController.taskListsNames.elementAt(0);

    // creates a task base on the user entries
    final task = Task.create(
      title: titleController.text,
      date: dateToString(date),
      priority: priority,
      description: descriptionController.text,
      taskListTile: taskListName!,
    );

    // updates task list and save changes
    taskListController.updateTaskListTasks(
      taskListName: taskListName!,
      task: task,
      exist: false,
    );

    update();
  }

  void updateTask({required Task task}) {
    // updates the task
    // if user doesn't enter any new value they set as their previous
    Task newTask = Task.create(
      title: titleController.text,
      description: descriptionController.text,
      date: dateToString(date),
      priority: priority,
      taskListTile: taskListName!,
    );
    newTask.isCompleted = task.isCompleted;

    // updates task list and save changes
    taskListController.updateTaskListTasks(
      taskListName: task.taskListTile,
      task: task,
      exist: true,
      newTask: newTask,
    );

    update();
  }

  void deleteTask({required Task task, required String taskListName}) {
    // gets the task task list instance
    TaskList taskList =
        taskListController.getTaskListInstance(taskListName: taskListName);

    // makes a copy
    TaskList modifiedTaskList = taskList.copyWith();

    // removes the task from task list
    modifiedTaskList.tasks.remove(task);

    // updates task list and save changes
    taskListController.updateTaskList(
      taskList: taskList,
      modifiedTaskList: modifiedTaskList,
    );

    update();
  }

  void updateTaskState({required Task task, required bool isCompleted}) {
    // changes the task completed sate
    task.isCompleted = isCompleted;

    // updates task list and save changes
    taskListController.updateTaskListTasks(
      taskListName: task.taskListTile,
      task: task,
      exist: true,
    );

    update();
  }
}
