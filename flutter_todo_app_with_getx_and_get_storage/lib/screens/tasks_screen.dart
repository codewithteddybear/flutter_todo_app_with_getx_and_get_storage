import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../controllers/task_controller.dart';
import '../models/task.dart';
import '../models/task_list.dart';
import '../widgets/widgets.dart';

bool? _showCompleted = false;

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  @override
  Widget build(BuildContext context) {
    final taskController = Get.find<TaskController>();

    TaskList? taskList = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          taskList != null ? taskList.title : "All Tasks",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_2),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // if show completed is false it turns it to null or vice versa
              // because if the completed option in getTasksByDay function set as null it will returns all tasks in selected day
              _showCompleted = _showCompleted == null ? false : null;
              setState(() {});
            },
            color: _showCompleted == null ? Colors.green : Colors.white,
            icon: const Icon(Iconsax.tick_circle),
            tooltip: "Show completed tasks",
          )
        ],
      ),
      floatingActionButton: CustomFloatingActionButton(
        tooltip: "Add Task",
        onPressed: () {
          // used to select the name of task list user is in for adding a new task
          if (taskList != null) {
            taskController.taskListName = taskList.title;
          }

          showCustomBottomSheet(
            widget: const AddOrUpdateTask(),
            context: context,
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: GetBuilder<TaskController>(
          init: taskController,
          builder: (controller) {
            List<Task> tasks = taskList == null
                ? controller.taskListController
                    .getAllTaskListsTasks(completed: _showCompleted)
                : controller.taskListController.getTasksFromTaskList(
                    taskListName: taskList.title,
                    completed: _showCompleted,
                  );

            return Column(
              children: [
                TaskCard(tasks: tasks),
              ],
            );
          },
        ),
      ),
    );
  }
}
