import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../controllers/task_controller.dart';
import '../models/task.dart';
import '../utils/constants.dart';
import '../widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskController = Get.find<TaskController>();

    final List<CustomNavigationBarItem> navigationBarItems = [
      CustomNavigationBarItem(
        icon: Iconsax.copy_success,
        onPressed: () => Get.toNamed("/tasksScreen"),
        tooltip: "Tasks",
      ),
      CustomNavigationBarItem(
        icon: Iconsax.document,
        onPressed: () => Get.toNamed("/taskListsScreen"),
        tooltip: "Task lists",
      ),
      CustomNavigationBarItem(
        icon: Iconsax.calendar_1,
        onPressed: () => Get.toNamed("/calendarScreen"),
        tooltip: "Calendar",
      ),
      CustomNavigationBarItem(
        icon: Iconsax.setting_2,
        onPressed: () {},
        tooltip: "Settings",
      ),
    ];
    return Scaffold(
      floatingActionButton: CustomFloatingActionButton(
        tooltip: "Add Task",
        onPressed: () => showCustomBottomSheet(
          widget: const AddOrUpdateTask(),
          context: context,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomNavigationBar(
        items: navigationBarItems,
      ),
      body: SafeArea(
        child: GetBuilder<TaskController>(
          init: taskController,
          builder: (controller) {
            List<Task> overDueTasks =
                controller.taskListController.getTasksByDay(
              day: today,
              showOverDues: true,
              completed: false,
            );
            List<Task> todayTasks = controller.taskListController.getTasksByDay(
              day: today,
              completed: false,
            );

            return Column(
              children: [
                overDueTasks.isNotEmpty
                    ? TaskCard(title: "Overdue", tasks: overDueTasks)
                    : const SizedBox.shrink(),
                overDueTasks.isNotEmpty
                    ? const SizedBox(height: 20)
                    : const SizedBox.shrink(),
                TaskCard(title: "Today", date: today, tasks: todayTasks),
              ],
            );
          },
        ),
      ),
    );
  }
}
