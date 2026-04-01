// Home to the main client instance or the Dio instance
// Author: Luis Angel Beltran Sanchez
// Version: 1.0.0

import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/network/auth_interceptor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../constants/app_constants.dart';

class ApiClient {
  ApiClient._();

  static Dio? _instance;

  static Dio get instance {
    _instance ??= _createDio();
    return _instance!;
  }

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.apiUrl,
        connectTimeout: Duration(milliseconds: AppConstants.connectTimeout),
        receiveTimeout: Duration(milliseconds: AppConstants.receiveTimeout),
        contentType: 'application/json',
        responseType: ResponseType.json,
        headers: {
          'Accept':  'application/json',
        },
      ),
    );

    // This will only log in debug mode FYI
    assert(() {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
        ),
      );
      return true;
    }());

    // This is my auth interceptor that attaches JWT to all requests
    dio.interceptors.add(
      AuthInterceptor(const FlutterSecureStorage()),
    );

    return dio;
  }

}