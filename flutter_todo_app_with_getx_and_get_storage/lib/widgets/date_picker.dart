import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

import '../controllers/task_controller.dart';
import '../utils/constants.dart';

class DatePicker extends StatelessWidget {
  const DatePicker({super.key});

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
          children: [
            _DateButton(
              text: "No Due",
              onPressed: () {
                taskController.date = null;
                Get.back();
              },
            ),
            _DateButton(
              text: "Today",
              onPressed: () {
                taskController.date = today;
                Get.back();
              },
            ),
            _DateButton(
              text: "Tomorrow",
              onPressed: () {
                taskController.date = tomorrow;
                Get.back();
              },
            ),
            _DateButton(
              text: "Other Days",
              onPressed: () async {
                _showDatePicker(context).then(
                  (value) {
                    if (value != null) {
                      taskController.date = datePrettier(value);
                      Get.back();
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<DateTime?> _showDatePicker(BuildContext context) async {
    return showOmniDateTimePicker(
      context: context,
      type: OmniDateTimePickerType.date,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 3652),
      ),
      borderRadius: BorderRadius.circular(10),
      constraints: const BoxConstraints(
        maxWidth: 350,
        maxHeight: 650,
      ),
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1.drive(
            Tween(
              begin: 0,
              end: 1,
            ),
          ),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
      selectableDayPredicate: (dateTime) {
        return true;
      },
    );
  }
}

class _DateButton extends StatelessWidget {
  const _DateButton({
    required this.text,
    required this.onPressed,
  });

  final String text;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          foregroundColor: Theme.of(context).primaryColor,
          backgroundColor: Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          )),
      child: Text(text),
    );
  }
}
