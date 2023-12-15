class Task {
  int? id;
  String? title;
  String? note;
  String? date;
  String? startTime;
  String? endTime;
  int? isCompleted;
  int? color;
    String? repeat;

  Task({
    this.id,
    required this.title,
    required this.note,
    this.date,
    this.startTime,
    this.endTime,
    this.isCompleted,
    this.color,
    this.repeat,
  });
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'note': note,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'isCompleted': isCompleted,
      'color': color,
     // 'repeat': repeat,
    };
  }

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    note = json['note'];
    date = json['date'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    isCompleted = json['isCompleted'];
    color = json['color'];
  //  repeat = json['repeat'];
  }
}
