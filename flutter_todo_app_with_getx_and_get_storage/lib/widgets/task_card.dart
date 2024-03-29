import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/task.dart';
import '../widgets/widgets.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.tasks,
    this.title,
    this.date,
  });

  final List<Task> tasks;
  final String? title;
  final DateTime? date;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            (title != null || date != null)
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: title),
                          TextSpan(
                            text: title != null && date != null ? " - " : null,
                          ),
                          TextSpan(
                            text: date != null
                                ? DateFormat("LLLL d").format(date!)
                                : null,
                          ),
                        ],
                      ),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  )
                : const SizedBox.shrink(),
            Expanded(
              child: ListView.separated(
                itemCount: tasks.length,
                separatorBuilder: (context, index) =>
                    Divider(color: Theme.of(context).primaryColor),
                itemBuilder: (context, index) {
                  Task task = tasks[index];
                  return TaskW(
                    task: task,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
