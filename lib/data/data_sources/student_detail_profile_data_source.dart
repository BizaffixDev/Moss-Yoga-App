// import 'package:dio/dio.dart';
// import 'package:get_it/get_it.dart';
// import 'package:moss_yoga/data/models/student_detail_response_model.dart';
//
// import '../models/student_detail_request_model.dart';
// import '../network/end_points.dart';
// import '../network/rest_api_client.dart';
//
// abstract class StudentDetailProfileDataSource {
//   Future<StudentDetailResponse> submitStudentDetails({required StudentDetailRequest studentDetailRequest});
// }
//
// class StudentDetailProfileDataSourceImpl
//     implements StudentDetailProfileDataSource {
//   StudentDetailProfileDataSourceImpl()
//       : _restClient = GetIt.instance<ApiService>();
//
//   final ApiService _restClient;
//
//   @override
//   Future<StudentDetailResponse> submitStudentDetails({required StudentDetailRequest studentDetailRequest}) async {
//     try {
//       var headers = {'accept': '*/*'};
//
//       dynamic data = StudentDetailRequest(
//
//         userId: 1,
//         userIntentions: "",
//         userLevel: "",
//         userChronicalCondition: [],
//         userPhysicalCondition: [],
//         genderId: 0,
//         phoneNum: "",
//         occupation: "occupation",
//         country: "country",
//         city: "city",
//         dob: "dob",
//         placeOfBirth: "placeOfBirth",
//         chronicalOthers: "chronicalOthers",
//         physicalOthers: "physicalOthers",
//       );
//
//       final result = _restClient.post(Endpoints.saveStudentProileData,
//           studentDetailRequestToJson(data),
//           options: Options(
//             headers: headers,
//           ));
//
//
//
//       return data;
//
//       // await _restClient.get(
//       //   Endpoints.saveStudentProileData, queryParameters: {}, options: Options(
//       //   headers: headers,
//       // ),);
//     } catch (e) {
//       rethrow;
//     }
//   }
// }
