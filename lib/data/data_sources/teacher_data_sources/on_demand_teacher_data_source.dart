import 'dart:convert';
import 'package:get_it/get_it.dart';
import 'package:moss_yoga/data/models/accept_reject_student_request_response.dart';
import '../../models/student_request_to_teacher_response.dart';
import '../../network/end_points.dart';
import '../../network/rest_api_client.dart';
import '../user_local_data_source.dart';



abstract class OnDemandTeacherDataSource {


  Future<List<StudentRequestsToTeacherResponse>> getStudnentRequests({required String teacherId});


  Future<AcceptRejectStudentRequestResponse> acceptStudentRequest({required String bookingId});


  Future<AcceptRejectStudentRequestResponse> rejectStudentRequest({required String bookingId});




}

class OnDemandTeacherDataSourceImpl implements OnDemandTeacherDataSource {
  OnDemandTeacherDataSourceImpl()
      : _restClient = GetIt.instance<ApiService>(),
        _userLocalDataSource = GetIt.instance<UserLocalDataSource>();

  final ApiService _restClient;
  final UserLocalDataSource _userLocalDataSource;

  @override
  Future<List<StudentRequestsToTeacherResponse>>
  getStudnentRequests({required String teacherId}) async {
    final result = await _restClient.get(
      Endpoints.getBookingofStudents,
      queryParameters: {
        "Teacherid": teacherId,
      },
    );
    print('This is the result of Poses List $result');
    final response =
    studentRequestsToTeacherResponseFromJson(json.encode(result.data));
    print('This is the response of decoded List $response');
    return response;
  }

  @override
  Future<AcceptRejectStudentRequestResponse> acceptStudentRequest({required String bookingId}) async{

    dynamic data =
    {

    };
    final result = await _restClient.patch(
      '${Endpoints.acceptBooking}?bookingCode=$bookingId',
      data,

    );
    print('This is the result of accept student request by teacher $result');
    final response =
    acceptRejectStudentRequestResponseFromJson(json.encode(result.data));
    print('This is the response of decoded List $response');
    return response;
  }

  @override
  Future<AcceptRejectStudentRequestResponse> rejectStudentRequest({required String bookingId}) async{
    dynamic data =
    {

    };
    final result = await _restClient.patch(
      '${Endpoints.cancelBooking}?bookingCode=$bookingId',
      data,

    );
    print('This is the result of reject student request by teacher $result');
    final response =
    acceptRejectStudentRequestResponseFromJson(json.encode(result.data));
    print('This is the response of decoded List $response');
    return response;
  }






}
