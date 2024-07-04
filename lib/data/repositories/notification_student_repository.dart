


import 'package:moss_yoga/data/data_sources/notification_student_data_souce.dart';

import '../models/notification_response_model.dart';

abstract class NotificationStudentRepository {

  Future<NotificationResponse> getNotifications(
      {required int userId, });

}

class NotificationStudentRepositoryImpl extends NotificationStudentRepository {
  NotificationStudentRepositoryImpl(this.notificationStudentDataSource);

  final NotificationStudentDataSource notificationStudentDataSource;

  @override
  Future<NotificationResponse> getNotifications({required int userId}) {
    return notificationStudentDataSource.getNotifications(userId: userId);
  }




}
