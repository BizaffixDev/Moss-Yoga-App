import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:moss_yoga/common/resources/urls.dart';
import 'package:moss_yoga/data/data_sources/user_local_data_source.dart';
import 'package:moss_yoga/data/models/login_response_model.dart';

class ApiService {
  static ApiService? _instance;

  factory ApiService({Dio? dio}) {
    _instance ??= ApiService._internal(dio: dio);
    return _instance!;
  }

  ApiService._internal({Dio? dio})
      : _dio = dio ?? Dio(),
        _userLocalDataSource = GetIt.instance<UserLocalDataSource>();

  final Dio _dio;
  final UserLocalDataSource _userLocalDataSource;
  final String baseUrl = Urls.baseUrlDev;

  Future<Response> get(String url,
      {Options? options,
      bool? isLogin,
      required Map<String, dynamic> queryParameters}) async {
    // try {
    if (isLogin == true) {
      var headers = {'accept': '*/*', 'Content-Type': 'application/json'};
      options?.receiveTimeout = 5 * 1000;
      final response = await _dio.get(
        baseUrl + url,
        queryParameters: queryParameters,
        options: options ??
            Options(
              receiveTimeout: 5 * 10000,
              headers: headers,
            ),
      );
      return response;
    } else {
      final userModel = await _userLocalDataSource.getUser();
      print('inside get api sending this option $options');
      var headersWithToken = {
        'accept': '*/*',
        'Authorization': 'Bearer ${userModel?.token}',
        // 'Content-Type': 'application/json',
      };
      final response = await _dio.get(baseUrl + url,
          queryParameters: queryParameters,
          options: options ??
              Options(
                sendTimeout: 10 * 1000,
                headers: headersWithToken,
              ));
      return response;
    }

    // }
    // } on DioError catch (e) {
    //   throw Exception(
    //       'Error: ${e.response?.statusCode} ${e.response?.statusMessage}');
    // }
  }

  Future<Response> post(String url, dynamic data,
      {bool isSignUporLogin = false, Options? options}) async {
    if (isSignUporLogin == true) {
      var headersWithoutToken = {
        'accept': '*/*',
        'Content-Type': 'application/json',
        // 'Authorization': 'Bearer ${userModel!.token}'
      };
      final response = await _dio.post(
        baseUrl + url,
        data: data,
        options: options ??
            Options(
              headers: headersWithoutToken,
            ),
      );

      return response;
    } else {
      final LoginResponseModel? userModel =
          await _userLocalDataSource.getUser();
      var headersWithToken = {
        'accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${userModel!.token}'
      };

      final response = await _dio.post(
        baseUrl + url,
        data: data,
        options: options ??
            Options(
              headers: headersWithToken,
            ),
      );
      return response;
    }
  }

  Future<Response> patch(String url, dynamic data, {Options? options}) async {
    final userModel = await _userLocalDataSource.getUser();

    var headersWithToken = {
      'accept': '*/*',
      'Authorization': 'Bearer ${userModel?.token}'
    };
    // try {
    final response = await _dio.patch(
      baseUrl + url,
      data: data,
      options: options ??
          Options(
            headers: headersWithToken,
          ),
    );
    return response;
    // }
    // on DioError catch (e) {
    //   throw Exception(
    //       'Error: ${e.response?.statusCode} ${e.response?.statusMessage}');
    // }
  }

  Future<Response> put(String url, dynamic data, {Options? options}) async {
    final userModel = await _userLocalDataSource.getUser();

    var headersWithToken = {
      'accept': '*/*',
      'Authorization': 'Bearer ${userModel?.token}'
    };
    try {
      final response = await _dio.put(
        baseUrl + url,
        data: data,
        options: options ??
            Options(
              headers: headersWithToken,
            ),
      );
      return response;
    } on DioError catch (e) {
      throw Exception(
          'Error: ${e.response?.statusCode} ${e.response?.statusMessage}');
    }
  }

  Future<Response> delete(String url,
      {Options? options, required Map<String, dynamic> queryParameters}) async {
    final userModel = await _userLocalDataSource.getUser();

    var headersWithToken = {
      'accept': '*/*',
      'Authorization': 'Bearer ${userModel?.token}'
    };

    try {
      final response = await _dio.delete(
        baseUrl + url,
        queryParameters: queryParameters,
        options: options ??
            Options(
              headers: headersWithToken,
            ),
      );
      return response;
    } on DioError catch (e) {
      throw Exception(
          'Error: ${e.response?.statusCode} ${e.response?.statusMessage}');
    }
  }
}
