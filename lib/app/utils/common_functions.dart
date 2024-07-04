import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moss_yoga/presentation/providers/app_providers.dart';

class CommonFunctions {
  static bool isTeacherPlatform(dynamic ref) {
    final current = ref.watch(currentPlatformProvider);
    if (current == CurrentPlatform.Teacher) {
      return true;
    }
    return false;
  }

  static String termsCondUrl(dynamic ref) {
    final current = ref.read(currentPlatformProvider);
    if (current == CurrentPlatform.Student) {
      return 'student';
    }
    return 'teacher';
  }

  static String dateFormation(String value) {
    final formattedDate = DateFormat.yMd('en_US');
    final _ = formattedDate.parse(value).toString();
    return _;
  }

  static double deviceHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double deviceWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static bool isSmallDevice(BuildContext context) {
    bool isSmall = MediaQuery.of(context).size.width <= 350;
    print(
        'Width: ${MediaQuery.of(context).size.width}, Is small device: $isSmall');
    print(
        'Height: ${MediaQuery.of(context).size.height}');
    return isSmall;
  }

  bool validatePassword(String value) {
    if (value.length >= 5) {
      return true;
    } else {
      return false;
    }
  }

  bool validateEmail(String email) {
    return email.contains('@') &&
        email.contains('.com') &&
        RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(email);
  }

  static Future<bool> checkInternetConnectivity() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        debugPrint('connected');
        return true;
      }
    } on SocketException catch (_) {
      debugPrint('not connected');
      return false;
    }
    return false;
  }

  static String calculatedValues(String a, String b) {
    double a0 = double.parse(a);
    double b0 = double.parse(b);
    num total = (a0 * b0) / 100;
    double __ = double.parse(total.toStringAsFixed(2));
    return __.toString();
  }



  static String convertTimeTo24HourFormat(String time) {
    List<String> parts = time.split(' ');
    List<String> timeParts = parts[0].split(':');

    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);

    if (parts[1].toLowerCase() == 'pm' && hour < 12) {
      hour += 12;
    } else if (parts[1].toLowerCase() == 'am' && hour == 12) {
      hour = 0;
    }

    String hourString = hour.toString().padLeft(2, '0');
    String minuteString = minute.toString().padLeft(2, '0');

    return '$hourString:$minuteString';
  }


  static String convertTo12HourFormat(String time24hr) {
    if (time24hr.isEmpty) {
      return '';
    }

    List<String> parts = time24hr.split(':');
    if (parts.length != 2) { // Change this line to check for 2 parts
      return ''; // Invalid time format
    }

    int hour = int.tryParse(parts[0]) ?? 0;
    int minute = int.tryParse(parts[1]) ?? 0;

    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
      return ''; // Invalid time format
    }

    String period = (hour >= 12) ? 'PM' : 'AM';

    if (hour == 0) {
      hour = 12; // Midnight
    } else if (hour > 12) {
      hour -= 12;
    }

    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }

//  static int getNotificationsCount(WidgetRef ref) {
// final profile = ref.watch(userProfileProvider);
// final notifications = profile.total_unread_notifications;
// return notifications;
// }
}
