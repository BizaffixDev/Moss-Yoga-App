import 'package:moss_yoga/data/data_sources/my_classes_student_data_source.dart';
import 'package:moss_yoga/data/models/my_classes_student_response_model.dart';

import '../models/accept_reject_student_request_response.dart';
import '../models/my_class_student_request_model.dart';
import '../models/reschedule_session_response_model.dart';
import '../models/reschedule_teacher_details_reponse.dart';
import '../models/reshedule_session_request_model.dart';
import '../models/teacher_detail_schedule_response.dart';

abstract class MyClassesStudentRepository{


  Future<MyClassesStudentResponse> myClassesData({required MyClassStudentRequest myClassStudentRequest});
  Future<AcceptRejectStudentRequestResponse> cancelBooking({required String bookingCode});
  Future<RescheduleSessionResponse> rescheduleSession({required RescheduleSessionRequest rescheduleSessionRequest});
  Future<TeacherDetailScheduleResponse> getRescheduleTeacherDetails(
      {required String bookingId});


}


class MyClassesStudentRepositoryImpl extends MyClassesStudentRepository {
  MyClassesStudentRepositoryImpl(this.myClassesStudentDataSource);

  final MyClassesStudentDataSource myClassesStudentDataSource;


  @override
  Future<MyClassesStudentResponse> myClassesData({required MyClassStudentRequest myClassStudentRequest}) {
   return myClassesStudentDataSource.myClassesData(myClassStudentRequest: myClassStudentRequest);
  }

  @override
  Future<AcceptRejectStudentRequestResponse> cancelBooking({required String bookingCode}) {
    return myClassesStudentDataSource.cancelBooking(bookingCode: bookingCode);
  }

  @override
  Future<RescheduleSessionResponse> rescheduleSession({required rescheduleSessionRequest}) {
    return myClassesStudentDataSource.rescheduleSession(rescheduleSessionRequest: rescheduleSessionRequest);
  }

  @override
  Future<TeacherDetailScheduleResponse> getRescheduleTeacherDetails({required String bookingId}) {
    return myClassesStudentDataSource.getRescheduleTeacherDetails(bookingId: bookingId);
  }




}