class Task {
  final int id;
  final int userId;
  final String title;
  final String date;
  final String time;
  String? status = Status.inProgress.name;
  final String description;

  Task(
      {required this.id,
      required this.userId,
      required this.title,
      required this.date,
      required this.time,
      this.status,
      required this.description});
}

enum Status {
  open,
  inProgress,
  completed,
}
