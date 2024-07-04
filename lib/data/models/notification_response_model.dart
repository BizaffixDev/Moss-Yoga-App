// To parse this JSON data, do
//
//     final notificationResponse = notificationResponseFromJson(jsonString);

import 'dart:convert';

NotificationResponse notificationResponseFromJson(String str) => NotificationResponse.fromJson(json.decode(str));

String notificationResponseToJson(NotificationResponse data) => json.encode(data.toJson());

class NotificationResponse {
  int count;
  Response response;

  NotificationResponse({
    required this.count,
    required this.response,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) => NotificationResponse(
    count: json["count"],
    response: Response.fromJson(json["response"]),
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "response": response.toJson(),
  };
}

class Response {
  List<NotificationData> today;
  List<NotificationData> yesterday;
  List<NotificationData> older;

  Response({
    required this.today,
    required this.yesterday,
    required this.older,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    today: List<NotificationData>.from(json["Today"].map((x) => NotificationData.fromJson(x))),
    yesterday: List<NotificationData>.from(json["Yesterday"].map((x) => NotificationData.fromJson(x))),
    older: List<NotificationData>.from(json["Older"].map((x) => NotificationData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Today": List<dynamic>.from(today.map((x) => x.toJson())),
    "Yesterday": List<dynamic>.from(yesterday.map((x) => x.toJson())),
    "Older": List<dynamic>.from(older.map((x) => x.toJson())),
  };
}

class NotificationData {
  int notificationId;
  String notificationType;
  String notificationName;
  String notificationDetail;
  String notificationPicture;
  String notificationMessage;
  bool isDeleted;
  bool isRead;
  String userType;
  int userId;
  String notificationTime;
  String notificationDay;

  NotificationData({
    required this.notificationId,
    required this.notificationType,
    required this.notificationName,
    required this.notificationDetail,
    required this.notificationPicture,
    required this.notificationMessage,
    required this.isDeleted,
    required this.isRead,
    required this.userType,
    required this.userId,
    required this.notificationTime,
    required this.notificationDay,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) => NotificationData(
    notificationId: json["notificationId"],
    notificationType: json["notificationType"],
    notificationName: json["notificationName"],
    notificationDetail: json["notificationDetail"],
    notificationPicture: json["notificationPicture"],
    notificationMessage: json["notificationMessage"],
    isDeleted: json["isDeleted"],
    isRead: json["isRead"],
    userType: json["userType"],
    userId: json["userId"],
    notificationTime: json["notificationTime"],
    notificationDay: json["notificationDay"],
  );

  Map<String, dynamic> toJson() => {
    "notificationId": notificationId,
    "notificationType": notificationType,
    "notificationName": notificationName,
    "notificationDetail": notificationDetail,
    "notificationPicture": notificationPicture,
    "notificationMessage": notificationMessage,
    "isDeleted": isDeleted,
    "isRead": isRead,
    "userType": userType,
    "userId": userId,
    "notificationTime": notificationTime,
    "notificationDay": notificationDay,
  };
}
