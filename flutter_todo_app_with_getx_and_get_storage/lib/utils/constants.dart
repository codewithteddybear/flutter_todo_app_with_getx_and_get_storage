import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Box Names
const String taskListKey = "taskListBox";

// Task Lists Colors
List<String> taskListColors = [
  "#C9CC41",
  "#66CC41",
  "#41CCA7",
  "#4181CC",
  "#41A2CC",
  "#CC8441",
  "#9741CC",
  "#CC4173",
];

// Dates
final DateTime tempToday = DateTime.now();
final DateTime today = DateTime(tempToday.year, tempToday.month, tempToday.day);
final DateTime tomorrow = today.add(const Duration(days: 1));

final List<DateTime> weekDays = [
  tomorrow.add(const Duration(days: 1)),
  tomorrow.add(const Duration(days: 2)),
  tomorrow.add(const Duration(days: 3)),
  tomorrow.add(const Duration(days: 4)),
  tomorrow.add(const Duration(days: 5)),
];

String? dateToString(DateTime? date) {
  if (date == null) {
    return null;
  }
  return DateFormat("y-MM-dd").format(date);
}

DateTime? dateFromString(String? date) {
  if (date == null) {
    return null;
  }
  return DateTime.parse(date);
}

/// returns a clean DateTime instance by removing seconds , minutes and hours
/// It's used for comparing dates
DateTime datePrettier(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

// returns dates a beautiful format such as : Today , Saturday , Apr 20
String dateSort(DateTime? date) {
  if (date == null) {
    return "No Due";
  } else if (today.compareTo(date) == 0) {
    return "Today";
  } else if (tomorrow.compareTo(date) == 0) {
    return 'Tomorrow';
  }

  for (final day in weekDays) {
    if (day.compareTo(date) == 0) {
      return DateFormat.EEEE().format(day);
    }
  }

  return DateFormat.MMMd().format(date);
}

// Priorities Colors
Map<int, Color> priorityColors = {
  1: Colors.red,
  2: Colors.yellow,
  3: Colors.blue,
  4: Colors.white70,
};
