import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:flutter/material.dart';

import '../models/task.dart';
import 'widgets.dart';
import '../utils/constants.dart';
import '../controllers/task_controller.dart';

class TaskW extends StatelessWidget {
  const TaskW({
    super.key,
    required this.task,
  });

  final Task task;

  @override
  Widget build(BuildContext context) {
    final taskController = Get.find<TaskController>();

    Color priorityColor = priorityColors.values.elementAt(task.priority - 1);

    return Dismissible(
      key: UniqueKey(),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          confirmDialog(
            title: "Warning",
            description:
                "Are you sure? by confirming this task will delete permanently",
            type: PanaraDialogType.warning,
            context: context,
            onTapConfirm: () {
              taskController.deleteTask(
                task: task,
                taskListName: task.taskListTile,
              );

              Get.back();
            },
          );
        } else if (direction == DismissDirection.startToEnd) {
          taskController.updateTaskState(
            task: task,
            isCompleted: !task.isCompleted,
          );
        }
        return false;
      },
      background: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Row(
          children: [
            Expanded(
              child: Container(
                color: Colors.green,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Icon(Iconsax.tick_square),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Icon(Iconsax.trash),
              ),
            ),
          ],
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          taskController.titleController.text = task.title;
          taskController.descriptionController.text = task.description;
          taskController.date = dateFromString(task.date);
          taskController.priority = task.priority;
          taskController.taskListName = task.taskListTile;

          showCustomBottomSheet(
            widget: AddOrUpdateTask(task: task),
            context: context,
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Transform.scale(
                  scale: 1.8,
                  child: Checkbox(
                    shape: const CircleBorder(),
                    activeColor: priorityColor,
                    side: BorderSide(
                      color: priorityColor,
                      width: 2,
                    ),
                    value: task.isCompleted,
                    onChanged: (newBool) {
                      taskController.updateTaskState(
                        task: task,
                        isCompleted: newBool!,
                      );
                    },
                  ),
                ),
                title: Text(
                  task.title,
                  style: task.isCompleted
                      ? Theme.of(context).textTheme.titleSmall!.copyWith(
                            decoration: TextDecoration.lineThrough,
                          )
                      : Theme.of(context).textTheme.titleSmall,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: task.description.isNotEmpty
                    ? Text(
                        task.description,
                        maxLines: 2,
                        style: task.isCompleted
                            ? Theme.of(context).textTheme.labelMedium!.copyWith(
                                  color: Colors.grey[400],
                                  decoration: TextDecoration.lineThrough,
                                )
                            : Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(color: Colors.grey[400]),
                        overflow: TextOverflow.ellipsis,
                      )
                    : null,
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          const Icon(
                            Iconsax.calendar_2,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            dateSort(dateFromString(task.date)),
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Icon(
                            Iconsax.document,
                          ),
                          const SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              task.taskListTile,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
