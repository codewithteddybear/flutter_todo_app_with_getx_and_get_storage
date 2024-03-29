import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

import '../controllers/task_list_controller.dart';
import '../models/task_list.dart';
import 'widgets.dart';

class TaskListDetails extends StatelessWidget {
  const TaskListDetails({super.key, required this.taskList});

  final TaskList taskList;

  @override
  Widget build(BuildContext context) {
    final taskListController = Get.find<TaskListController>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _DetailsButton(
            icon: Iconsax.edit,
            text: "Edit",
            onPressed: () async {
              await showCustomBottomSheet(
                widget: AddOrUpdateTaskList(taskList: taskList),
                context: context,
              );
              Get.back();
            },
          ),
          _DetailsButton(
            icon: Iconsax.trash,
            text: "Delete",
            onPressed: () => confirmDialog(
              title: "Warning",
              description:
                  "Are you sure? by confirming your task list and all tasks inside it will delete permanently",
              onTapConfirm: () {
                taskListController.deleteTaskList(taskList: taskList);
                Get.back();
              },
              type: PanaraDialogType.warning,
              context: context,
            ).then(
              (_) => Get.back(),
            ),
            background: Colors.red,
          ),
        ],
      ),
    );
  }
}

class _DetailsButton extends StatelessWidget {
  const _DetailsButton({
    required this.onPressed,
    required this.text,
    required this.icon,
    this.background,
  });

  final Color? background;
  final IconData icon;
  final String text;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(text),
      style: OutlinedButton.styleFrom(
        foregroundColor: Theme.of(context).primaryColor,
        backgroundColor: background ?? Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
