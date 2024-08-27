import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/tasks_model.dart';
import 'package:todo/todo/provider/mains_provider.dart';
import 'package:todo/todo/provider/theme_provider.dart';
import 'package:todo/widgets/task_widget.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return Consumer<MainProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: const Alignment(0, 2.5),
              children: [
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          const SizedBox(width: 50),
                          Text(
                            "Hi, ${provider.user?.name.toUpperCase() ?? ""}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                EasyInfiniteDateTimeLine(
                  locale: themeNotifier.toggleLocal(),
                  firstDate: DateTime.now().subtract(const Duration(days: 365)),
                  focusDate: provider.selectedTime,
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                  activeColor: Colors.blue,
                  selectionMode: const SelectionMode.autoCenter(),
                  dayProps: EasyDayProps(
                    borderColor: Colors.blue,
                    activeDayStyle: DayStyle(
                      dayNumStyle: TextStyle(
                          color: themeNotifier.isDarkMode
                              ? Colors.white
                              : Colors.black),
                      dayStrStyle: TextStyle(
                          color: themeNotifier.isDarkMode
                              ? Colors.white
                              : Colors.black),
                      monthStrStyle: TextStyle(
                          color: themeNotifier.isDarkMode
                              ? Colors.white
                              : Colors.black),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    disabledDayStyle: DayStyle(
                      dayNumStyle: TextStyle(
                          color: themeNotifier.isDarkMode
                              ? Colors.white
                              : Colors.black),
                      dayStrStyle: TextStyle(
                          color: themeNotifier.isDarkMode
                              ? Colors.white
                              : Colors.black),
                      monthStrStyle: TextStyle(
                          color: themeNotifier.isDarkMode
                              ? Colors.white
                              : Colors.black),
                      decoration: BoxDecoration(
                        color: themeNotifier.isDarkMode
                            ? Colors.black
                            : Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    todayStyle: DayStyle(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.blue.withOpacity(0.8),
                      ),
                    ),
                    inactiveDayStyle: DayStyle(
                      dayNumStyle: TextStyle(
                          color: themeNotifier.isDarkMode
                              ? Colors.white
                              : Colors.black),
                      dayStrStyle: TextStyle(
                          color: themeNotifier.isDarkMode
                              ? Colors.white
                              : Colors.black),
                      monthStrStyle: TextStyle(
                          color: themeNotifier.isDarkMode
                              ? Colors.white
                              : Colors.black),
                      decoration: BoxDecoration(
                        color: themeNotifier.isDarkMode
                            ? Colors.black
                            : Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  showTimelineHeader: false,
                  onDateChange: provider.setDate,
                ),
              ],
            ),
            const SizedBox(height: 60),
            StreamBuilder<List<TaskModel?>>(
              stream: provider.getTask(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  print(snapshot.error);
                  return const Center(
                    child: Text("An error occurred."),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text("No tasks available."),
                  );
                } else {
                  List<TaskModel?> tasks = snapshot.data!;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        return TaskWidget(task: tasks[index]!);
                      },
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
