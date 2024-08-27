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

  void addTask() {
    TaskModel task = TaskModel(
      id: '',
      title: titleController.text,
      date: DateUtils.dateOnly(selectedTimeTask).millisecondsSinceEpoch,
      desc: descController.text,
      time: "${timeOfDay.hour}:${timeOfDay.minute}",
      isDone: false,
      userId: FirebaseAuth.instance.currentUser?.uid ?? "",
    );

    FireBaseFunctions.addTask(task);

    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch,
        channelKey: 'basic_channel',
        title: task.title,
        body: task.desc,
      ),
      schedule: NotificationCalendar(
        year: DateTime.fromMillisecondsSinceEpoch(task.date).year,
        month: DateTime.fromMillisecondsSinceEpoch(task.date).month,
        day: DateTime.fromMillisecondsSinceEpoch(task.date).day,
        hour: int.parse(task.time.split(":")[0]),
        minute: int.parse(task.time.split(":")[1]),
        second: 0,
        millisecond: 0,
        preciseAlarm: true,
      ),
    );
    titleController.clear();
    descController.clear();
    // notifyListeners();
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

  // جلب بيانات المستخدم
  void getUser() async {
    user = await FireBaseFunctions.getUser();
    notifyListeners();
  }

  void logout(BuildContext context) async {
    await FireBaseFunctions.logout();
    navigateAndFinish(context, LoginScreen());
  }
}
