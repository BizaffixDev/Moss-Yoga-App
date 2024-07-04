
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:moss_yoga/data/data_sources/user_local_data_source.dart';
import 'package:moss_yoga/data/models/reschedule_teacher_details_reponse.dart';

import '../models/accept_reject_student_request_response.dart';
import '../models/my_class_student_request_model.dart';
import '../models/my_classes_student_response_model.dart';
import '../models/reschedule_session_response_model.dart';
import '../models/reshedule_session_request_model.dart';
import '../models/teacher_detail_schedule_response.dart';
import '../network/end_points.dart';
import '../network/rest_api_client.dart';

abstract class MyClassesStudentDataSource {


  Future<MyClassesStudentResponse> myClassesData({required MyClassStudentRequest myClassStudentRequest});
  Future<AcceptRejectStudentRequestResponse> cancelBooking({required String bookingCode});
  // Future<RescheduleSessionResponse> rescheduleSession({required RescheduleSessionRequest rescheduleSessionRequest});
  Future<RescheduleSessionResponse> rescheduleSession(
      {required RescheduleSessionRequest rescheduleSessionRequest});

  Future<TeacherDetailScheduleResponse> getRescheduleTeacherDetails(
      {required String bookingId});

}


class MyClassesStudentDataSourceImpl implements MyClassesStudentDataSource {

  MyClassesStudentDataSourceImpl()
      : _restClient = GetIt.instance<ApiService>(),
        _userLocalDataSource = GetIt.instance<UserLocalDataSource>();

  final ApiService _restClient;
  final UserLocalDataSource _userLocalDataSource;





  @override
  Future<MyClassesStudentResponse> myClassesData ({required MyClassStudentRequest myClassStudentRequest}) async {
    // try{


    final result =
    await _restClient.post(Endpoints.myClassesStudent,
      myClassStudentRequest,
    );

    debugPrint('This is the result $result');

    debugPrint('Student My Classes Request====== $myClassStudentRequest');
    debugPrint('Date ========  ${myClassStudentRequest.date}');
    if (result.data == null) {
      throw Exception('Empty response');
    }
    final response = MyClassesStudentResponse.fromJson(result.data);
    debugPrint('This is the UPCOMING ===== ${response.upcoming}');
    debugPrint('This is the response $response');
    return response;
    // }catch (e){
    //   debugPrint("This is the caught e ${e.toString()}");
    //   debugPrint(e);
    //   rethrow;
    // }
  }

  @override
  Future<AcceptRejectStudentRequestResponse> cancelBooking({required String bookingCode}) async{
    dynamic data =
    {

    };
    final result = await _restClient.patch(
      '${Endpoints.cancelBooking}?bookingCode=$bookingCode',
      data,

    );
    print('This is the result of reject student request by teacher $result');
    final response =
    acceptRejectStudentRequestResponseFromJson(json.encode(result.data));
    print('This is the response of decoded List $response');
    return response;
  }

  @override
  Future<RescheduleSessionResponse> rescheduleSession(
      {required RescheduleSessionRequest rescheduleSessionRequest}) async {
    final result = await _restClient.post(
      Endpoints.rescheduleBooking,
      rescheduleSessionRequest,
    );

    debugPrint('This is the result $result');
    debugPrint('Student My Classes Request====== $rescheduleSessionRequest');
    if (result.data == null) {
      throw Exception('Empty response');
    }
    final response = RescheduleSessionResponse.fromJson(result.data);
    debugPrint('This is the response $response');
    return response;
  }

  @override
  Future<TeacherDetailScheduleResponse> getRescheduleTeacherDetails({required String bookingId}) async{
    final result = await _restClient.get(
      Endpoints.rescheduleTeacherDetails,
      queryParameters: {
          "bookingId" : bookingId,
      }
    );

    debugPrint('This is the result $result');
    if (result.data == null) {
      throw Exception('Empty response');
    }
    final response = TeacherDetailScheduleResponse.fromJson(result.data);
    debugPrint('This is the response $response');
    return response;
  }


}
