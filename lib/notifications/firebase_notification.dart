import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:todo/models/tasks_model.dart';

class NotificationService {
  static Future<void> initializeNotifications() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (message.notification != null) {
        await createNotification(
          title: message.notification!.title ?? "No Title",
          body: message.notification!.body ?? "No Body",
          task: null,
        );
      }
    });
  }

  static Future<void> createNotification({
    required String title,
    required String body,
    TaskModel? task,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey: 'firebase_channel',
        title: title,
        body: body,
      ),
      schedule: task != null
          ? NotificationCalendar(
              year: DateTime.fromMillisecondsSinceEpoch(task.date).year,
              month: DateTime.fromMillisecondsSinceEpoch(task.date).month,
              day: DateTime.fromMillisecondsSinceEpoch(task.date).day,
              hour: int.parse(task.time.split(":")[0]),
              minute: int.parse(task.time.split(":")[1]),
              second: 0,
              millisecond: 0,
              preciseAlarm: true,
            )
          : null,
    );
  }

  static Future<void> handleNotification(RemoteMessage message) async {
    await createNotification(
      title: message.notification?.title ?? "No Title",
      body: message.notification?.body ?? "No Body",
      task: null,
    );
  }
}
