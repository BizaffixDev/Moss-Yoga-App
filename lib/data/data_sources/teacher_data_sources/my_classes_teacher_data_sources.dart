
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:moss_yoga/data/data_sources/user_local_data_source.dart';
import 'package:moss_yoga/data/models/my_class_teacher_request_model.dart';
import 'package:moss_yoga/data/models/my_classes_teacher_response_model.dart';

import '../../network/end_points.dart';
import '../../network/rest_api_client.dart';



abstract class MyClassesTeacherDataSource {


  Future<MyClassesTeacherResponse> myClassesData({required MyClassTeacherRequest myClassTeacherRequest});
  Future<String> cancelBooking({required String bookingCode});


}


class MyClassesTeacherDataSourceImpl implements MyClassesTeacherDataSource {

  MyClassesTeacherDataSourceImpl()
      : _restClient = GetIt.instance<ApiService>(),
        _userLocalDataSource = GetIt.instance<UserLocalDataSource>();

  final ApiService _restClient;
  final UserLocalDataSource _userLocalDataSource;


  @override
  Future<MyClassesTeacherResponse> myClassesData ({required MyClassTeacherRequest myClassTeacherRequest}) async {
    // try{


    final result =
    await _restClient.post(Endpoints.myClassesTeacher,
      myClassTeacherRequest,
    );

    debugPrint('This is the result $result');

    debugPrint('Student My Classes Request====== $myClassTeacherRequest');
    debugPrint('Date ========  ${myClassTeacherRequest.date}');
    if (result.data == null) {
      throw Exception('Empty response');
    }
    final response = MyClassesTeacherResponse.fromJson(result.data);
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
  Future<String> cancelBooking({required String bookingCode}) async{
    dynamic data =
    {

    };

    try {
      // Call the patch method with the URL and data
      final result = await _restClient.patch(
        '${Endpoints.cancelBooking}?bookingCode=$bookingCode',
        data,
      );

      // Print the raw response (optional, for debugging)
      print('This is the result of cancel Booking: $result');

      // Here, you can directly handle the 'result' string according to your business logic
      // For example, check if the booking was declined and return a corresponding message
      if (result.statusCode == 200) {
        return 'Booking declined';
      } else {
        // Handle other scenarios if needed
        return 'Booking cancellation successful'; // or any other appropriate message
      }
    } catch (e) {
      // Handle any errors that might occur during the request or processing
      print('Error occurred during cancelBooking: $e');
      return 'Error occurred during booking cancellation';
    }
  }

}
