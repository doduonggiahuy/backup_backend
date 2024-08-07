import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

// ignore: constant_identifier_names
enum Method { POST, GET, DELETE, PATCH }

class HttpServices {
  Dio? _dio;
  Future<HttpServices> init(BaseOptions options) async {
    _dio = Dio(options);
    return this;
  }

  request(
      {required String endpoint,
      required Method method,
      Map<String, dynamic>? params,
      Map<String, dynamic>? queryParams}) async {
    Response response;

    try {
      if (method == Method.GET) {
        response = await _dio!.get(endpoint,
            queryParameters: queryParams, data: json.encode(params));
      } else if (method == Method.POST) {
        response = await _dio!.post(endpoint, data: json.encode(params));
      } else if (method == Method.DELETE) {
        response = await _dio!.delete(endpoint);
      } else {
        response = await _dio!.patch(endpoint, data: json.encode(params));
      }
      return response;
    } on DioException catch (e) {
      return e;
    }
  }

  Future<dynamic> requestFile(
      {required String endpoint, required FormData formData}) async {
    Response response;

    try {
      response = await _dio!.post(endpoint, data: formData);
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("Something went wrong");
      }
    } catch (e) {
      debugPrint('$e');
      throw Exception("Something went wrong");
    }
  }
}
