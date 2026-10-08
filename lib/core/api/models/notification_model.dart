class NotificationModel {
  String? guid;
  String? title;
  String? message;
  String? type;
  bool? isRead;
  String? createdDt;
  String? readDt;

  NotificationModel({
    this.guid,
    this.title,
    this.message,
    this.type,
    this.isRead,
    this.createdDt,
    this.readDt,
  });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    guid = json['guid'];
    title = json['title'];
    message = json['message'];
    type = json['type'];
    isRead = json['is_read'];
    createdDt = json['created_dt'];
    readDt = json['read_dt'];
  }
}
