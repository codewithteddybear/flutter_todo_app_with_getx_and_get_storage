import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iconsax/iconsax.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:toastification/toastification.dart';

import 'widgets.dart';
import '../controllers/task_list_controller.dart';
import '../utils/constants.dart';
import '../models/task_list.dart';

class AddOrUpdateTaskList extends StatefulWidget {
  const AddOrUpdateTaskList({super.key, this.taskList});

  final TaskList? taskList;

  @override
  State<AddOrUpdateTaskList> createState() => _AddOrUpdateTaskListState();
}

class _AddOrUpdateTaskListState extends State<AddOrUpdateTaskList> {
  @override
  Widget build(BuildContext context) {
    final taskListController = Get.find<TaskListController>();

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Padding(
        padding: EdgeInsets.only(
          left: 30,
          right: 30,
          top: 20,
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
                  widget.taskList == null
                      ? "New Task List"
                      : "Update Task List",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                IconButton(
                  onPressed: () {
                    // if user doesn't enter anything it will close the bottom sheet without asking
                    if (taskListController.titleController.text.isNotEmpty) {
                      confirmDialog(
                        title: "Warning",
                        description:
                            "Are you sure? by confirming the changes you've made will not be saved",
                        type: PanaraDialogType.warning,
                        context: context,
                        onTapConfirm: () {
                          taskListController.clearVariablesData();

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
              onChanged: (_) => setState(() {}),
              controller: taskListController.titleController,
              style: Theme.of(context).textTheme.titleSmall,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: "Task List Name",
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
            SizedBox(
              height: 70,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: taskListColors.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 10),
                  itemBuilder: (context, index) => Obx(
                    () => _ColorButton(
                      color: taskListColors[index],
                      isSelected:
                          taskListController.selectedColorIndex.value == index,
                      onTap: () =>
                          taskListController.selectedColorIndex.value = index,
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: ElevatedButton(
                onPressed: taskListController.titleController.text != ""
                    ? () {
                        if (widget.taskList == null) {
                          if (!taskListController.checkTaskListDuplication()) {
                            taskListController.addTaskList();

                            showToast(
                              title: "Success",
                              description: "Task list successfully added",
                              type: ToastificationType.success,
                              style: ToastificationStyle.flat,
                              context: context,
                            );
                          } else {
                            showToast(
                              title: "Error",
                              description: "This task list already exist",
                              type: ToastificationType.error,
                              style: ToastificationStyle.fillColored,
                              context: context,
                            );
                          }
                        } else {
                          taskListController.updateTaskListDetails(
                            taskList: widget.taskList!,
                          );

                          showToast(
                            title: "Success",
                            description: "Task successfully updated",
                            type: ToastificationType.success,
                            style: ToastificationStyle.flat,
                            context: context,
                          );
                        }

                        taskListController.clearVariablesData();

                        Get.back();
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                child: const Icon(Iconsax.send_1),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _ColorButton extends StatelessWidget {
  const _ColorButton({
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  final String color;
  final bool isSelected;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isSelected ? 55 : 40,
        height: isSelected ? 55 : 40,
        decoration: BoxDecoration(
          color: HexColor(color),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
