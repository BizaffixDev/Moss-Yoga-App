// // To parse this JSON data, do
// //
// //     final upcomingClassesHomeReponse = upcomingClassesHomeReponseFromJson(jsonString);
//
// import 'dart:convert';
//
// UpcomingClassesHomeReponse upcomingClassesHomeReponseFromJson(String str) => UpcomingClassesHomeReponse.fromJson(json.decode(str));
//
// String upcomingClassesHomeReponseToJson(UpcomingClassesHomeReponse data) => json.encode(data.toJson());
//
// class UpcomingClassesHomeReponse {
//   int count;
//   List<UpcomingData> response;
//
//   UpcomingClassesHomeReponse({
//     required this.count,
//     required this.response,
//   });
//
//   factory UpcomingClassesHomeReponse.fromJson(Map<String, dynamic> json) => UpcomingClassesHomeReponse(
//     count: json["count"],
//     response: List<UpcomingData>.from(json["response"].map((x) => UpcomingData.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "count": count,
//     "response": List<dynamic>.from(response.map((x) => x.toJson())),
//   };
// }
//
// class UpcomingData {
//   String teacherEmail;
//   String teacherName;
//   int teacherId;
//   String tGender;
//   String tHeadline;
//   String tPic;
//   int tAge;
//   String bookingType;
//   int bookingStatus;
//   String statusType;
//   String bookingDate;
//   String bookingDay;
//   String bookingCode;
//
//   UpcomingData({
//     required this.teacherEmail,
//     required this.teacherName,
//     required this.teacherId,
//     required this.tGender,
//     required this.tHeadline,
//     required this.tPic,
//     required this.tAge,
//     required this.bookingType,
//     required this.bookingStatus,
//     required this.statusType,
//     required this.bookingDate,
//     required this.bookingDay,
//     required this.bookingCode,
//   });
//
//   factory UpcomingData.fromJson(Map<String, dynamic> json) => UpcomingData(
//     teacherEmail: json["teacherEmail"],
//     teacherName: json["teacherName"],
//     teacherId: json["teacherId"],
//     tGender: json["t_Gender"],
//     tHeadline: json["t_Headline"],
//     tPic: json["t_Pic"],
//     tAge: json["t_Age"],
//     bookingType: json["bookingType"],
//     bookingStatus: json["bookingStatus"],
//     statusType: json["statusType"],
//     bookingDate: json["bookingDate"],
//     bookingDay: json["bookingDay"],
//     bookingCode: json["bookingCode"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "teacherEmail": teacherEmail,
//     "teacherName": teacherName,
//     "teacherId": teacherId,
//     "t_Gender": tGender,
//     "t_Headline": tHeadline,
//     "t_Pic": tPic,
//     "t_Age": tAge,
//     "bookingType": bookingType,
//     "bookingStatus": bookingStatus,
//     "statusType": statusType,
//     "bookingDate": bookingDate,
//     "bookingDay": bookingDay,
//     "bookingCode": bookingCode,
//   };
// }
// To parse this JSON data, do
//
//     final upcomingClassesHomeReponse = upcomingClassesHomeReponseFromJson(jsonString);

import 'dart:convert';

UpcomingClassesHomeReponse upcomingClassesHomeReponseFromJson(String str) =>
    UpcomingClassesHomeReponse.fromJson(json.decode(str));

String upcomingClassesHomeReponseToJson(UpcomingClassesHomeReponse data) =>
    json.encode(data.toJson());

class UpcomingClassesHomeReponse {
  int count;
  List<UpcomingData> upcoming;

  UpcomingClassesHomeReponse({
    required this.count,
    required this.upcoming,
  });

  factory UpcomingClassesHomeReponse.fromJson(Map<String, dynamic> json) =>
      UpcomingClassesHomeReponse(
        count: json["count"],
        upcoming: List<UpcomingData>.from(
            json["upcoming"].map((x) => UpcomingData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "upcoming": List<dynamic>.from(upcoming.map((x) => x.toJson())),
      };
}

class UpcomingData {
  String teacherEmail;
  String teacherName;
  int teacherId;
  String tGender;
  String tHeadline;
  String tPic;
  int tAge;
  String teacherSchedulingDetailCode;
  String teacherSpeciality;
  String bookingType;
  int bookingStatus;
  String statusType;
  String bookingDate;
  String bookingDay;
  String bookingCode;
  int studentId;
  String price;
  String slotTime;
  String startTime;
  String endTime;
  String badgeName;
  String studentEmail;
  String studentName;
  bool joinButton;
  String timeleftInJoining;

  UpcomingData({
    required this.teacherEmail,
    required this.teacherName,
    required this.teacherId,
    required this.tGender,
    required this.tHeadline,
    required this.tPic,
    required this.tAge,
    required this.teacherSchedulingDetailCode,
    required this.teacherSpeciality,
    required this.bookingType,
    required this.bookingStatus,
    required this.statusType,
    required this.bookingDate,
    required this.bookingDay,
    required this.bookingCode,
    required this.studentId,
    required this.price,
    required this.slotTime,
    required this.startTime,
    required this.endTime,
    required this.badgeName,
    required this.studentEmail,
    required this.studentName,
    required this.joinButton,
    required this.timeleftInJoining,
  });

  factory UpcomingData.fromJson(Map<String, dynamic> json) => UpcomingData(
        teacherEmail: json["teacherEmail"],
        teacherName: json["teacherName"],
        teacherId: json["teacherId"],
        tGender: json["t_Gender"],
        tHeadline: json["t_Headline"],
        tPic: json["t_Pic"],
        tAge: json["t_Age"],
        teacherSchedulingDetailCode: json["teacherSchedulingDetailCode"],
        teacherSpeciality: json["teacherSpeciality"],
        bookingType: json["bookingType"],
        bookingStatus: json["bookingStatus"],
        statusType: json["statusType"],
        bookingDate: json["bookingDate"],
        bookingDay: json["bookingDay"],
        bookingCode: json["bookingCode"],
        studentId: json["studentId"],
        price: json["price"],
        slotTime: json["slotTime"],
        startTime: json["startTime"],
        endTime: json["endTime"],
        badgeName: json["badgeName"],
        studentEmail: json["studentEmail"],
        studentName: json["studentName"],
        joinButton: json["joinButton"],
        timeleftInJoining: json["timeleftInJoining"],
      );

  Map<String, dynamic> toJson() => {
        "teacherEmail": teacherEmail,
        "teacherName": teacherName,
        "teacherId": teacherId,
        "t_Gender": tGender,
        "t_Headline": tHeadline,
        "t_Pic": tPic,
        "t_Age": tAge,
        "teacherSchedulingDetailCode": teacherSchedulingDetailCode,
        "teacherSpeciality": teacherSpeciality,
        "bookingType": bookingType,
        "bookingStatus": bookingStatus,
        "statusType": statusType,
        "bookingDate": bookingDate,
        "bookingDay": bookingDay,
        "bookingCode": bookingCode,
        "studentId": studentId,
        "price": price,
        "slotTime": slotTime,
        "startTime": startTime,
        "endTime": endTime,
        "badgeName": badgeName,
        "studentEmail": studentEmail,
        "studentName": studentName,
        "joinButton": joinButton,
        "timeleftInJoining": timeleftInJoining,
      };
}
