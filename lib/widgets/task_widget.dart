import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/tasks_model.dart';
import 'package:todo/todo/provider/mains_provider.dart';
import 'package:todo/todo/provider/theme_provider.dart';

class TaskWidget extends StatelessWidget {
  final TaskModel task;

  TaskWidget({
    required this.task,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return Consumer<MainProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Slidable(
            key: ValueKey(task.id),
            startActionPane: ActionPane(
              motion: const ScrollMotion(),
              dismissible: DismissiblePane(onDismissed: () {
                provider.deleteTask(task.id);
              }),
              children: [
                SlidableAction(
                  borderRadius: BorderRadius.circular(10),
                  onPressed: (context) {
                    provider.deleteTask(task.id);
                  },
                  backgroundColor: const Color(0xFFFE4A49),
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete'.tr(),
                ),
                SlidableAction(
                  borderRadius: BorderRadius.circular(10),
                  onPressed: (context) {
                    _showEditDialog(context, provider, themeNotifier);
                  },
                  backgroundColor: const Color(0xFF21B7CA),
                  foregroundColor: Colors.white,
                  icon: Icons.edit,
                  label: 'Edit'.tr(),
                ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.all(15),
              height: 120,
              decoration: BoxDecoration(
                color: themeNotifier.isDarkMode
                    ? const Color(0xff141A2E)
                    : Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 60,
                    decoration: BoxDecoration(
                        color: task.isDone ? Colors.green : Colors.blue,
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: task.isDone ? Colors.green : Colors.blue),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        task.desc,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          const Icon(Icons.timelapse),
                          const SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            task.time,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      )
                    ],
                  ),
                  const Spacer(),
                  task.isDone
                      ? InkWell(
                          onTap: () {
                            provider.setDone(task);
                          },
                          child: Text(
                            "Done..!".tr(),
                            style: TextStyle(
                                color: Colors.green,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            provider.setDone(task);
                          },
                          child: Container(
                            width: 50,
                            height: 30,
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(8)),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                            ),
                          ),
                        )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, MainProvider provider,
      ThemeNotifier themeNotifier) {
    TextEditingController titleController =
        TextEditingController(text: task.title);
    TextEditingController descController =
        TextEditingController(text: task.desc);
    TextEditingController timeController =
        TextEditingController(text: task.time);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor:
              themeNotifier.isDarkMode ? const Color(0xff141A2E) : Colors.white,
          title: Text(
            "Edit Task",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: "Title",
                  helperStyle: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              TextField(
                controller: descController,
                decoration: InputDecoration(
                  hintText: "Description",
                  helperStyle: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              TextField(
                controller: timeController,
                decoration: InputDecoration(
                  hintText: "Time",
                  helperStyle: Theme.of(context).textTheme.headlineSmall,
                ),
                onTap: () async {
                  final selectedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (selectedTime != null) {
                    timeController.text = selectedTime.format(context);
                  }
                },
              ),
              // Add any other fields you want to edit
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                TaskModel updatedTask = TaskModel(
                  date: task.date,
                  id: task.id,
                  title: titleController.text,
                  desc: descController.text,
                  time: timeController.text,
                  isDone: task.isDone,
                  userId: task.userId,
                );
                provider.updateTask(updatedTask);
                Navigator.of(context).pop();
              },
              child: const Text("Save"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
}
