import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

import '../models/task_list.dart';
import '../controllers/task_list_controller.dart';
import '../widgets/widgets.dart';

class TaskListsScreen extends StatelessWidget {
  const TaskListsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskListController = Get.find<TaskListController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Task Lists",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_2),
          onPressed: () => Get.back(),
        ),
      ),
      floatingActionButton: DragTarget<TaskList>(
        builder: (context, candidateData, rejectedData) => Obx(
          () => FloatingActionButton(
            // TODO: make it circle in settings
            // shape: CircleBorder(),
            tooltip: taskListController.isDragged.value
                ? "Remove Task List"
                : "Add Task List",
            onPressed: () => showCustomBottomSheet(
              widget: const AddOrUpdateTaskList(),
              context: context,
            ),
            backgroundColor: taskListController.isDragged.value
                ? Colors.red
                : Theme.of(context).colorScheme.primary,
            child: Icon(
              taskListController.isDragged.value ? Iconsax.trash : Iconsax.add,
              size: 28,
              color: Colors.white,
            ),
          ),
        ),
        onAcceptWithDetails: (details) {
          if (!details.data.isInbox) {
            confirmDialog(
              title: "Warning",
              description:
                  "Are you sure? by confirming your task list and all tasks inside it will delete permanently",
              onTapConfirm: () {
                taskListController.deleteTaskList(taskList: details.data);
                Get.back();
              },
              type: PanaraDialogType.warning,
              context: context,
            );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: GetBuilder<TaskListController>(
          init: taskListController,
          builder: (controller) => GridView.count(
            physics: const BouncingScrollPhysics(),
            crossAxisCount: 2,
            children: [
              for (final taskList in controller.taskLists)
                !taskList.isInbox
                    ? Draggable(
                        onDragStarted: () =>
                            taskListController.isDragged.value = true,
                        onDragEnd: (_) =>
                            taskListController.isDragged.value = false,
                        data: taskList,
                        feedback: Opacity(
                          opacity: 0.8,
                          child: TaskListCard(taskList: taskList),
                        ),
                        child: TaskListCard(taskList: taskList),
                      )
                    : TaskListCard(taskList: taskList),
            ],
          ),
        ),
      ),
    );
  }
}
