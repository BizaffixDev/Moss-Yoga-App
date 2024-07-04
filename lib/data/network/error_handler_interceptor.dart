import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:moss_yoga/common/resources/strings.dart';

class ErrorHandlerInterceptor extends Interceptor {
  // void onError(DioError err, ErrorInterceptorHandler handler) {
  //   debugPrint('ERRRORRR: ${err.message}');
  //   debugPrint('ERROR RESPONSE: ${err.response}');
  //   switch (err.type) {
  //     case DioErrorType.connectTimeout:
  //       throw TimeoutException(requestOptions: err.requestOptions);
  //     case DioErrorType.sendTimeout:
  //     case DioErrorType.receiveTimeout:
  //       throw TimeoutException(requestOptions: err.requestOptions);
  //     case DioErrorType.response:
  //       final statusCode = err.response?.statusCode ?? 0;
  //       if (statusCode > 500) {
  //         throw CommonException(requestOptions: err.requestOptions);
  //       } else if (err.response?.statusCode == 401 ||
  //           err.response?.statusCode == 403) {
  //         throw UnauthorizedException(requestOptions: err.requestOptions);
  //       }
  //
  //       // else if (err.response != null && err.response?.data != null) {
  //       //   final statusCode = err.response!.statusCode!;
  //       //   final data = err.response!.data;
  //       //   final errors = data?['errors'];
  //       //   if (errors != null) {
  //       //     final responseErrors =
  //       //     ResponseError.fromJsonArray(data['errors'] as List);
  //       //     throw BackendResponseError(
  //       //       requestOptions: err.requestOptions,
  //       //       statusCode: statusCode,
  //       //       responseErrors: responseErrors,
  //       //     );
  //       //   } else {
  //       //     throw CommonException(requestOptions: err.requestOptions);
  //       //   }
  //       // }
  //
  //       // else if(err.response?.statusCode == 400){
  //       //   final data = err.response!.data;
  //       //   final errors = data['errors'];
  //       //   if (errors != null) {
  //       //     final responseErrors = _parseResponseErrors(errors as Map<String, dynamic>);
  //       //     throw BackendResponseError(
  //       //       requestOptions: err.requestOptions!,
  //       //       statusCode: statusCode,
  //       //       responseErrors: responseErrors,
  //       //     );
  //       // }
  //
  //       else if (err.response != null && err.response?.data != null) {
  //         final statusCode = err.response!.statusCode!;
  //         final data = err.response!.data;
  //         final errors = data['errors'];
  //         if (errors != null) {
  //           final responseErrors = _parseResponseErrors(errors as Map<String, dynamic>);
  //           throw BackendResponseError(
  //             requestOptions: err.requestOptions!,
  //             statusCode: statusCode,
  //             responseErrors: responseErrors,
  //           );
  //         } else {
  //           throw CommonException(requestOptions: err.requestOptions!);
  //         }
  //       }
  //       else {
  //         throw CommonException(requestOptions: err.requestOptions);
  //       }
  //     case DioErrorType.cancel:
  //       break;
  //     case DioErrorType.other:
  //       throw NoInternetConnectionException(requestOptions: err.requestOptions);
  //   }
  //
  //   return handler.next(err);
  // }
  // List<ResponseError> _parseResponseErrors(Map<String, dynamic> errors) {
  //   return errors.entries.map((entry) {
  //     final field = entry.key;
  //     final messages = List<String>.from(entry.value);
  //     return ResponseError(
  //       field: field,
  //       messages: messages,
  //       requestOptions: RequestOptions(path: ''),
  //       type: DioErrorType.response,
  //     );
  //   }).toList();
  // }
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    debugPrint('ERRRORRR: ${err.message}');
    debugPrint('ERROR RESPONSE: ${err.response}');
    switch (err.type) {
      case DioErrorType.connectTimeout:
        throw TimeoutException(requestOptions: err.requestOptions);
      case DioErrorType.sendTimeout:
      case DioErrorType.receiveTimeout:
        throw TimeoutException(requestOptions: err.requestOptions);
      case DioErrorType.response:
        final statusCode = err.response?.statusCode ?? 0;
        if (statusCode > 500) {
          throw CommonException(requestOptions: err.requestOptions);
        } else if (err.response?.statusCode == 401 ||
            err.response?.statusCode == 403) {
          final data = err.response!.statusMessage;
          print("This is the unauthorized error data in interceptors $data");
          print(
              "This is the unauthorized error data in interceptors ${err.response?.statusMessage}");
          final errors = data;
          if (errors != null) {
            throw UnauthorizedException(
              requestOptions: err.requestOptions,
              errorText: errors.toString(),
            );
          } else {
            throw UnauthorizedException(
                requestOptions: err.requestOptions,
                errorText: errors.toString());
          }
        } else if (err.response?.statusCode == 400) {
          final data = err.response!.data;
          print('This is the data $data');
          final errors = data.toString();

          ///Removeed the array stuff since maybe he changed on BackEnd.
          // final errors = data['errors'];
          if (errors != null) {
            //   print('Going inside responseErrors');
            //   final responseErrors =
            //       _parseResponseErrors(errors as Map<String, dynamic>);
            throw BackendResponseError(
              requestOptions: err.requestOptions,
              statusCode: statusCode,
              responseErrors: [
                ResponseError(
                    requestOptions: err.requestOptions, messages: [errors])
              ],
            );
          } else {
            throw CommonException(requestOptions: err.requestOptions);
          }
        } else {
          throw CommonException(requestOptions: err.requestOptions);
        }
      case DioErrorType.cancel:
        break;
      case DioErrorType.other:
        throw NoInternetConnectionException(requestOptions: err.requestOptions);
    }
    return handler.next(err);
  }

  List<ResponseError> _parseResponseErrors(Map<String, dynamic> errors) {
    return errors.entries.map((entry) {
      final field = entry.key;
      final messages = List<String>.from(entry.value);
      return ResponseError(
        field: field,
        messages: messages,
        requestOptions: RequestOptions(path: ''),
        type: DioErrorType.response,
      );
    }).toList();
  }
}

class TimeoutException extends DioError {
  TimeoutException({required super.requestOptions});

  @override
  String toString() {
    return Strings.timeoutError;
  }
}

class ConflictException extends DioError {
  ConflictException({required super.requestOptions});

  @override
  String toString() {
    return Strings.conflictError;
  }
}

class CommonException extends DioError {
  CommonException({required super.requestOptions});

  @override
  String toString() {
    return Strings.commonError;
  }
}

class UnauthorizedException extends DioError {
  UnauthorizedException({
    required this.errorText,
    required super.requestOptions,
  });

  String errorText;

  @override
  String toString() {
    // return Strings.unauthorizedError;
    return errorText;
  }
}

class AutoInvestmentDisabled implements Exception {
  AutoInvestmentDisabled(this.cause);

  String cause;
}

class NoInternetConnectionException extends DioError {
  NoInternetConnectionException({required super.requestOptions});

  @override
  String toString() {
    return Strings.noInternetConnectionError;
  }
}

class PermissionNotAllowed implements Exception {
  PermissionNotAllowed(this.cause);

  String cause;
}

// class BackendResponseError extends DioError {
//   BackendResponseError({
//     required super.requestOptions,
//     required int statusCode,
//     required List<ResponseError> responseErrors,
//   })  : _statusCode = statusCode,
//         _responseErrors = responseErrors;
//
//   final int _statusCode;
//   final List<ResponseError> _responseErrors;
//
//   int get statusCode => _statusCode;
//   List<ResponseError> get responseErrors => _responseErrors;
//
//   @override
//   String toString() {
//     return _responseErrors.isNotEmpty
//         ? _responseErrors.first.subtitle
//         : Strings.commonError;
//   }
// }
class BackendResponseError extends DioError {
  final int statusCode;
  final List<ResponseError> responseErrors;

  BackendResponseError({
    required RequestOptions requestOptions,
    required this.statusCode,
    required this.responseErrors,
  }) : super(
          requestOptions: requestOptions,
          response: null,
          type: DioErrorType.response,
        );

  //
  // @override
  // String toString() {
  //   return responseErrors.isNotEmpty
  //       ? responseErrors.first.message ?? Strings.commonError
  //       : Strings.commonError;
  // }
  @override
  String toString() {
    return responseErrors.isNotEmpty
        ? responseErrors.map((error) => error.message).join(", ") ??
            Strings.commonError
        : Strings.commonError;
  }
}

class ResponseError extends DioError {
  final String? field;
  final List<String>? messages;

  ResponseError({
    this.field,
    this.messages,
    Response? response,
    required RequestOptions requestOptions,
    DioErrorType type = DioErrorType.response,
  }) : super(
          response: response,
          requestOptions: requestOptions,
          type: type,
        );

  factory ResponseError.fromJson(Map<String, dynamic> json) {
    return ResponseError(
      field: json['field'],
      messages:
          json['messages'] != null ? List<String>.from(json['messages']) : null,
      response: null,
      requestOptions: RequestOptions(path: ''),
      type: DioErrorType.response,
    );
  }
}
