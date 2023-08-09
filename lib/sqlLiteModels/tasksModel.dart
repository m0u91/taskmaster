

class TasksModel {
  int? id;
  String? name;
  String? des;
  String? images;
  String date;
  String create;
  int? done;
  int? notification;
  TasksModel({this.id, this.name, this.des, this.images,required this.date,required this.create, this.done,  this.notification});


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'des': des,
      'images': images,
      'date': date,
      'create': create,
      'done': done,
      'notification': notification,
    };
  }
}