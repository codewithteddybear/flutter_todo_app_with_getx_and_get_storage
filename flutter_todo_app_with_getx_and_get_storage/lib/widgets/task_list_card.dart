import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iconsax/iconsax.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../controllers/task_list_controller.dart';
import '../models/task_list.dart';
import '../utils/constants.dart';
import 'widgets.dart';

class TaskListCard extends StatelessWidget {
  const TaskListCard({
    super.key,
    required this.taskList,
  });

  final TaskList taskList;

  @override
  Widget build(BuildContext context) {
    final taskListController = Get.find<TaskListController>();

    int remainingTasks = taskListController
        .getTasksFromTaskList(
          taskListName: taskList.title,
          completed: false,
        )
        .length;

    int completedTasks = taskListController
        .getTasksFromTaskList(
          taskListName: taskList.title,
          completed: true,
        )
        .length;

    double percent = taskListController.getTaskListPercent(taskList: taskList);

    return SizedBox(
      width: (MediaQuery.of(context).size.width - 30) / 2,
      height: (MediaQuery.of(context).size.width - 30) / 2,
      child: Card(
        elevation: 4,
        surfaceTintColor: HexColor(taskList.color),
        shadowColor: HexColor(taskList.color).withOpacity(0.5),
        color: Theme.of(context).primaryColorDark,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () => Get.toNamed("/tasksScreen", arguments: taskList),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircularPercentIndicator(
                      // progressColor with gradient

                      // linearGradient: LinearGradient(
                      //   colors: [
                      //     HexColor(color).withOpacity(0.5),
                      //     HexColor(color)
                      //   ],
                      // ),

                      percent: percent,
                      radius: 28.0,
                      lineWidth: 2.0,
                      center: Text(
                        "${(percent * 100).toInt()}%",
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      progressColor: HexColor(taskList.color),
                      animation: true,
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        taskList.title,
                        style: Theme.of(context).textTheme.labelMedium,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Text(
                  "$remainingTasks Remaining",
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                Text(
                  "$completedTasks Completed",
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                // used to disable user access to default task list
                !taskList.isInbox
                    ? IconButton(
                        onPressed: () {
                          taskListController.titleController.text =
                              taskList.title;
                          taskListController.selectedColorIndex.value =
                              taskListColors.indexOf(taskList.color);

                          showModalBottomSheet(
                            isScrollControlled: true,
                            backgroundColor: Theme.of(context).primaryColorDark,
                            context: context,
                            builder: (context) => TaskListDetails(
                              taskList: taskList,
                            ),
                          );
                        },
                        icon: const Icon(Iconsax.more),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
