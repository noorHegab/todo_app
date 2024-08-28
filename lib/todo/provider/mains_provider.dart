import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/auth/pages/login_screen.dart';
import 'package:todo/components/components.dart';
import 'package:todo/models/tasks_model.dart';
import 'package:todo/models/user_model.dart';
import 'package:todo/modules/setting_screen.dart';
import 'package:todo/modules/taskk_screen.dart';
import 'package:todo/service/firebase_functions.dart';

class MainProvider extends ChangeNotifier {
  int selectedIndex = 0;
  DateTime selectedTime = DateTime.now();
  DateTime selectedTimeTask = DateTime.now();
  TimeOfDay timeOfDay = TimeOfDay.now();
  List<Widget> screens = [TaskScreen(), SettingScreen()];
  List<String> title = ["Tasks", "Settings"];
  UserModel? user;
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  void setIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  void setDate(DateTime time) {
    selectedTime = time;
    notifyListeners();
  }

  void setTime(TimeOfDay time) {
    timeOfDay = time;
    notifyListeners();
  }

  void setTimeTask(DateTime time) {
    selectedTimeTask = time;
    notifyListeners();
  }

  Future<void> addTask() async {
    // إعداد نموذج المهمة
    TaskModel task = TaskModel(
      id: '',
      title: titleController.text,
      date: DateUtils.dateOnly(selectedTimeTask).millisecondsSinceEpoch,
      desc: descController.text,
      time: "${timeOfDay.hour}:${timeOfDay.minute}",
      isDone: false,
      userId: FirebaseAuth.instance.currentUser?.uid ?? "",
    );

    // إضافة المهمة إلى Firestore
    await FireBaseFunctions.addTask(task);

    // إعداد إشعار مجدول بناءً على تاريخ ووقت المهمة
    DateTime scheduledNotificationDateTime = DateTime(
      selectedTimeTask.year,
      selectedTimeTask.month,
      selectedTimeTask.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );

    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey: 'firebase_channel',
        title: task.title,
        body: task.desc,
      ),
      schedule: NotificationCalendar.fromDate(
        date: scheduledNotificationDateTime,
        preciseAlarm: true,
      ),
    );

    titleController.clear();
    descController.clear();
  }

  Stream<List<TaskModel?>> getTask() {
    return FireBaseFunctions.getTask(
            DateUtils.dateOnly(selectedTime).millisecondsSinceEpoch)
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  void deleteTask(String id) {
    FireBaseFunctions.deleteTask(id);
  }

  void setDone(TaskModel model) {
    FireBaseFunctions.setDone(model);
  }

  void updateTask(TaskModel updatedTask) {
    FireBaseFunctions.updateTask(updatedTask);
  }

  void getUser() async {
    user = await FireBaseFunctions.getUser();
    notifyListeners();
  }

  void logout(BuildContext context) async {
    await FireBaseFunctions.logout();
    navigateAndFinish(context, LoginScreen());
  }
}
