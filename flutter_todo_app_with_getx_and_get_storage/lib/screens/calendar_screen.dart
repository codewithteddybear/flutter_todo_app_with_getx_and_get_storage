import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:table_calendar/table_calendar.dart';

import '../controllers/task_controller.dart';
import '../models/task.dart';
import '../utils/constants.dart';
import '../widgets/widgets.dart';

CalendarFormat _calendarFormat = CalendarFormat.month;
DateTime _selectedDay = today;
bool? _showCompleted = false;

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  @override
  Widget build(BuildContext context) {
    final taskController = Get.find<TaskController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Calendar",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_2),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                // if show completed is false it turns it to null or vice versa
                // because if the completed option in getTasksByDay function set as null it will returns all tasks in selected day
                _showCompleted = _showCompleted == null ? false : null;
              });
            },
            color: _showCompleted == null ? Colors.green : Colors.white,
            icon: const Icon(Iconsax.tick_circle),
            tooltip: "Show completed tasks",
          )
        ],
      ),
      floatingActionButton: CustomFloatingActionButton(
        tooltip: "Add Task List",
        onPressed: () {
          // used to select the selected day for adding a new task
          taskController.date = _selectedDay;

          showCustomBottomSheet(
            widget: const AddOrUpdateTask(),
            context: context,
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        child: Column(
          children: [
            TableCalendar(
              firstDay: today,
              lastDay: DateTime.now().add(
                const Duration(days: 3652),
              ),
              focusedDay: _selectedDay,
              currentDay: _selectedDay,
              calendarFormat: _calendarFormat,
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarStyle: const CalendarStyle(
                disabledTextStyle: TextStyle(color: Colors.grey),
                outsideDaysVisible: false,
                weekendTextStyle: TextStyle(color: Colors.white),
              ),
              onDaySelected: (selectedDay, focusedDay) {
                _selectedDay = datePrettier(selectedDay);

                setState(() {});
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  _calendarFormat = format;
                  setState(() {});
                }
              },
            ),
            const SizedBox(height: 20),
            GetBuilder<TaskController>(
              init: taskController,
              builder: (controller) {
                List<Task> selectedDayTasks =
                    controller.taskListController.getTasksByDay(
                  day: _selectedDay,
                  completed: _showCompleted,
                );
                return TaskCard(
                  tasks: selectedDayTasks,
                  title: dateSort(_selectedDay),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
