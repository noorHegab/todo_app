import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/todo/provider/mains_provider.dart';
import 'package:todo/todo/provider/theme_provider.dart';

class AddTaskWidget extends StatelessWidget {
  const AddTaskWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return Consumer<MainProvider>(
      builder: (context, provider, child) {
        return Container(
          color: themeNotifier.isDarkMode ? Color(0xff141A2E) : Colors.grey,
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const Text("Add Task"),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: provider.titleController,
                decoration: InputDecoration(
                    hintText: "Title",
                    hintStyle: Theme.of(context).textTheme.bodyLarge,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            BorderSide(color: Colors.blue.withOpacity(0.5))),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Colors.blue))),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: provider.descController,
                decoration: InputDecoration(
                    hintText: "Description",
                    hintStyle: Theme.of(context).textTheme.bodyLarge,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            BorderSide(color: Colors.blue.withOpacity(0.5))),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Colors.blue))),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Select Date",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                  onTap: () {
                    showDatePicker(
                            context: context,
                            firstDate: DateTime.now(),
                            initialDate: provider.selectedTimeTask,
                            lastDate:
                                DateTime.now().add(const Duration(days: 365)))
                        .then((value) {
                      provider.setTimeTask(value!);
                    });
                  },
                  child: Text(
                      provider.selectedTimeTask.toString().substring(0, 10))),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Select Time",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                  onTap: () {
                    showTimePicker(
                            context: context, initialTime: provider.timeOfDay)
                        .then((value) {
                      provider.setTime(value!);
                    });
                  },
                  child: Text(
                      "${provider.timeOfDay.hour} : ${provider.timeOfDay.minute}")),
              const Spacer(),
              ElevatedButton(
                  onPressed: () {
                    provider.addTask();
                    Navigator.pop(context);
                  },
                  child: const Text("Add Task"))
            ],
          ),
        );
      },
    );
  }
}
