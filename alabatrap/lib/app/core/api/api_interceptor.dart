import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../data/services/storage_manager.dart';
import '../../routes/app_pages.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final accessToken = await Storage.get('access_token');
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    } else {
      Get.offAllNamed(Routes.AUTH);
    }
    options.headers['Content-Type'] ??= 'application/json';

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // refreshAccessToken();
    }
    super.onError(err, handler);
  }
}
