import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:toastification/toastification.dart';

import '../controllers/task_controller.dart';
import '../utils/constants.dart';
import '../widgets/widgets.dart';
import '../models/task.dart';

class AddOrUpdateTask extends StatefulWidget {
  const AddOrUpdateTask({super.key, this.task});

  // if task is given it will update the task otherwise it add a new task
  final Task? task;

  @override
  State<AddOrUpdateTask> createState() => _AddOrUpdateTaskState();
}

class _AddOrUpdateTaskState extends State<AddOrUpdateTask> {
  final taskController = Get.find<TaskController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Padding(
        padding: EdgeInsets.only(
          left: 30,
          right: 30,
          top: 20,

          // used to set padding at bottom as the size of keyboard
          bottom: MediaQuery.of(context).viewInsets.bottom + 12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.task == null ? "New Task" : "Update Task",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                IconButton(
                  onPressed: () {
                    // if user doesn't enter anything it will close the bottom sheet without asking
                    if (taskController.titleController.text.isNotEmpty) {
                      confirmDialog(
                        title: "Warning",
                        description:
                            "Are you sure? by confirming the changes you've made will not be saved",
                        type: PanaraDialogType.warning,
                        context: context,
                        onTapConfirm: () {
                          taskController.clearVariablesData();

                          // it close the confirm window
                          Get.back();

                          // it close the bottom sheet
                          Get.back();
                        },
                      );
                    } else {
                      Get.back();
                    }
                  },
                  color: Colors.red,
                  icon: const Icon(Iconsax.close_square),
                ),
              ],
            ),
            TextField(
              onChanged: (_) {
                // to update add or update task button state every time task name changes
                setState(() {});
              },
              controller: taskController.titleController,
              style: Theme.of(context).textTheme.titleSmall,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: "Task Name",
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
            TextField(
              controller: taskController.descriptionController,
              style: Theme.of(context).textTheme.labelMedium,
              maxLines: 2,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(left: 10),
                hintText: "description",
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
            SizedBox(
              height: 65,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    TaskField(
                      icon: Iconsax.calendar_2,
                      label: dateSort(taskController.date),
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) => const DatePicker(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    TaskField(
                      icon: Iconsax.flag,
                      foregroundColor: priorityColors.values
                          .elementAt(taskController.priority - 1),
                      label: "Priority ${taskController.priority}",
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) => const PriorityPicker(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    TaskField(
                      icon: Iconsax.document,
                      label: taskController.taskListName ??
                          taskController.taskListController.taskListsNames
                              .elementAt(0),
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) => const TaskListPicker(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: ElevatedButton(
                // disable the button if task name is empty
                onPressed: taskController.titleController.text.isNotEmpty
                    ? () {
                        if (widget.task == null) {
                          taskController.addTask();

                          showToast(
                            title: "Success",
                            description: "Task successfully added",
                            type: ToastificationType.success,
                            style: ToastificationStyle.flat,
                            context: context,
                          );
                        } else {
                          taskController.updateTask(task: widget.task!);

                          showToast(
                            title: "Success",
                            description: "Task successfully updated",
                            type: ToastificationType.success,
                            style: ToastificationStyle.flat,
                            context: context,
                          );
                        }

                        taskController.clearVariablesData();

                        Get.back();
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                child: const Icon(Iconsax.send_1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TaskField extends StatelessWidget {
  const TaskField({
    super.key,
    required this.label,
    required this.icon,
    this.foregroundColor,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color? foregroundColor;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey[800]!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: foregroundColor,
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .labelSmall!
                  .copyWith(color: foregroundColor),
            ),
          ],
        ),
      ),
    );
  }
}
