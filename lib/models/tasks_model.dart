class TaskModel {
  String id;
  String title;
  int date;
  String desc;
  String time;
  bool isDone;
  String userId;

  TaskModel({
    this.id = '',
    required this.title,
    required this.date,
    required this.desc,
    required this.time,
    required this.isDone,
    required this.userId,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      date: json['date'] ?? 0,
      desc: json['desc'] ?? '',
      time: json['time'] ?? '',
      isDone: json['isDone'] ?? false,
      userId: json['userId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'desc': desc,
      'time': time,
      'isDone': isDone,
      'userId': userId,
    };
  }
}
