import 'dart:core';

import 'package:dio/dio.dart';
import 'package:moss_yoga/data/network/error_handler_interceptor.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

// class ServiceConfig {
//   ServiceConfig(this.baseOptions);
//
//   final BaseOptions baseOptions;
//
//   Set<Interceptor> getInterceptors() {
//     final interceptors = <Interceptor>{}..addAll(
//       {
//         ErrorHandlerInterceptor(),
//         PrettyDioLogger(requestHeader: true, requestBody: true),
//       },
//     );
//
//     return interceptors;
//   }
// }
class ServiceConfig {
  Set<Interceptor> getInterceptors() {
    final interceptors = <Interceptor>{}..addAll(
      {
        ErrorHandlerInterceptor(),
        PrettyDioLogger(requestHeader: true, requestBody: true),
      },
    );

    return interceptors;
  }
}

