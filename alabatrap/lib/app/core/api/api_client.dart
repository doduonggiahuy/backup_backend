import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'api_interceptor.dart';
import 'api_path.dart';

class ApiClient {
  final dio = Dio()..interceptors.add(ApiInterceptor());

  // Future<Response?> request(String path, String method,
  //     {Map<String, dynamic>? headers,
  //     dynamic data,
  //     Map<String, dynamic>? queryParameters}) async {
  //   try {
  //     final requestOption = RequestOptions(
  //         baseUrl: ApiPath.baseUrl,
  //         path: path,
  //         method: method,
  //         data: data,
  //         queryParameters: queryParameters,
  //         receiveTimeout: const Duration(seconds: 10),
  //         connectTimeout: const Duration(seconds: 10),
  //         receiveDataWhenStatusError: true);
  //     Response response = await dio.fetch(requestOption);
  //     return response;
  //   } on DioException catch (e) {
  //     debugPrint('DioException: ${e.message}');
  //     debugPrint('Request Path: ${e.requestOptions.path}');
  //     debugPrint('Request Data: ${e.requestOptions.data}');
  //     debugPrint('Request Headers: ${e.requestOptions.headers}');
  //     return e.response;
  //   } catch (e) {
  //     debugPrint(e.toString());
  //     return null;
  //   }
  // }

  Future<Response?> request(String path, String method,
      {Map<String, dynamic>? headers,
      dynamic data,
      Map<String, dynamic>? queryParameters,
      Options? options}) async {
    try {
      options = options?.copyWith(
            method: method,
            headers: headers,
            receiveTimeout: const Duration(seconds: 10),
            sendTimeout: const Duration(seconds: 10),
          ) ??
          Options(
            method: method,
            headers: headers,
            receiveTimeout: const Duration(seconds: 10),
            sendTimeout: const Duration(seconds: 30),
            responseType: ResponseType.json,
          );

      Response response = await dio.request(
        '${ApiPath.baseUrl}$path',
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      return response;
    } on DioException catch (e) {
      debugPrint('DioException: ${e.message}');
      debugPrint('Request Path: ${e.requestOptions.path}');
      debugPrint('Request Data: ${e.requestOptions.data}');
      debugPrint('Request Headers: ${e.requestOptions.headers}');
      return e.response;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
