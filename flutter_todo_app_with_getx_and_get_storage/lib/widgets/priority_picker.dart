import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../utils/constants.dart';
import '../controllers/task_controller.dart';

class PriorityPicker extends StatelessWidget {
  const PriorityPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final taskController = Get.find<TaskController>();

    return Dialog(
      surfaceTintColor: Theme.of(context).primaryColorDark,
      backgroundColor: Theme.of(context).primaryColorDark,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: priorityColors.entries
              .map(
                (element) => _PriorityButton(
                  priority: element.key,
                  onPressed: () {
                    taskController.priority = element.key;
                    Get.back();
                  },
                  color: element.value,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _PriorityButton extends StatelessWidget {
  const _PriorityButton({
    required this.priority,
    required this.color,
    required this.onPressed,
  });

  final int priority;
  final Color color;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Iconsax.flag),
      label: Text("Priority $priority"),
      style: ElevatedButton.styleFrom(
        foregroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
