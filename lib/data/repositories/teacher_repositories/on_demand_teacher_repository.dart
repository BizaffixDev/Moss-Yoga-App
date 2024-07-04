import '../../data_sources/teacher_data_sources/on_demand_teacher_data_source.dart';
import '../../models/accept_reject_student_request_response.dart';
import '../../models/student_request_to_teacher_response.dart';


abstract class OnDemandTeacherRepository {
  Future<List<StudentRequestsToTeacherResponse>> getStudnentRequests({required String teacherId});

  Future<AcceptRejectStudentRequestResponse> acceptStudentRequest({required String bookingId});


  Future<AcceptRejectStudentRequestResponse> rejectStudentRequest({required String bookingId});

}

class OnDemandTeacherRepositoryImpl extends OnDemandTeacherRepository {
  OnDemandTeacherRepositoryImpl(this.onDemandTeacherDataSource);

  final OnDemandTeacherDataSource onDemandTeacherDataSource;

  @override
  Future<List<StudentRequestsToTeacherResponse>> getStudnentRequests({required String teacherId}) {
    return onDemandTeacherDataSource.getStudnentRequests(teacherId: teacherId);
  }

  @override
  Future<AcceptRejectStudentRequestResponse> acceptStudentRequest({required String bookingId}) {
    return onDemandTeacherDataSource.acceptStudentRequest(bookingId: bookingId);
  }

  @override
  Future<AcceptRejectStudentRequestResponse> rejectStudentRequest({required String bookingId}) {
    return onDemandTeacherDataSource.rejectStudentRequest(bookingId: bookingId);
  }


}
