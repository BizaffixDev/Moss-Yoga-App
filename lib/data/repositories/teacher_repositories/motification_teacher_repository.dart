import 'package:moss_yoga/data/data_sources/teacher_data_sources/notification_teacher_data_source.dart';

import '../../models/notification_response_model.dart';




abstract class NotificationTeacherRepository {
  Future<NotificationResponse> getNotifications(
      {required int userId, });
}

class NotificationTeacherRepositoryImpl extends NotificationTeacherRepository {
  NotificationTeacherRepositoryImpl(this.notificationTeacherDataSource);

  final NotificationTeacherDataSource notificationTeacherDataSource;

  @override
  Future<NotificationResponse> getNotifications({required int userId}) {
    return notificationTeacherDataSource.getNotifications(userId: userId);
  }

}
