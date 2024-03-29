import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/task_controller.dart';

class TaskListPicker extends StatelessWidget {
  const TaskListPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final taskController = Get.find<TaskController>();

    return Dialog(
      surfaceTintColor: Theme.of(context).primaryColorDark,
      backgroundColor: Theme.of(context).primaryColorDark,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: taskController.taskListController.taskListsNames
                    .map(
                      (element) => _TaskListItem(
                        name: element,
                        onPressed: () {
                          taskController.taskListName = element;
                          Get.back();
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskListItem extends StatelessWidget {
  const _TaskListItem({
    required this.name,
    required this.onPressed,
  });

  final String name;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(name),
    );
  }
}
