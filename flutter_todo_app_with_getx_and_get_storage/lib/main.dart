import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'controllers/task_controller.dart';
import 'controllers/task_list_controller.dart';
import 'screens/screens.dart';
import 'utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initializing the get storage
  await GetStorage.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: [
        GetPage(
          name: "/taskListsScreen",
          page: () => const TaskListsScreen(),
          transition: Transition.leftToRight,
          transitionDuration: const Duration(milliseconds: 450),
        ),
        GetPage(
          name: "/tasksScreen",
          page: () => const TasksScreen(),
          transition: Transition.upToDown,
          transitionDuration: const Duration(milliseconds: 300),
        ),
        GetPage(
          name: "/calendarScreen",
          page: () => const CalendarScreen(),
          transition: Transition.rightToLeft,
          transitionDuration: const Duration(milliseconds: 450),
        ),
      ],
      theme: AppTheme.darkTheme,
      initialBinding: BindingsBuilder(
        () {
          Get.lazyPut(() => TaskController());
          Get.lazyPut(() => TaskListController());
        },
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
