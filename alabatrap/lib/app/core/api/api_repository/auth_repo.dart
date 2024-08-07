import 'package:alabatrap/app/core/util/extensions/optional_x.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';

import '../../../data/models/user.dart';
import '../../../data/services/current_user.dart';
import '../../../data/services/storage_manager.dart';
import '../../../routes/app_pages.dart';
import '../../util/func/toastication.dart';
import '../api_client.dart';
import '../api_method.dart';
import '../api_path.dart';

class AuthApi {
  AuthApi._();

  static Future<void> signup(
      String username, String email, String password, String phone) async {
    Map data = {
      'email': email,
      'password_hash': password,
      'username': username,
      'phone': phone
    };
    var response =
        await ApiClient().request(ApiPath.signup, ApiMethod.post, data: data);
    if (response?.statusCode == 200) {
      // await login(email, password);
      debugPrint(response?.data);
      debugPrint('Registered successfully');
    } else {
      showToastNotification(
          title: "Đăng ký thất bài, vui lòng thử lại",
          type: ToastificationType.error);
    }
  }

  static Future<void> login(String email, String password) async {
    Map data = {'email': email, 'password': password};
    var response =
        await ApiClient().request(ApiPath.login, ApiMethod.post, data: data);
    if (response?.statusCode == 200) {
      User user = User.fromJson(response?.data['data']['user']);
      await Storage.set('user_data', user.toJson().toString());
      await Storage.set('access_token', response?.data['data']['tokens']);
      await CurrentUser().init();
      // var token = await PushNotifications.getToken();
      // if (token != null) {
      //   await updateDeviceToken(CurrentUser().id ?? "", token);
      // }
      if (user.isNotNull) {
        Get.offAllNamed(Routes.DASHBOARD);
        showToastNotification(
            title: "Chào mừng bạn đến với Mia Milkshare",
            type: ToastificationType.success);
      }
    } else {
      showToastNotification(
          title: "Đăng nhập thất bài, vui lòng thử lại",
          type: ToastificationType.error);
    }
  }

  static Future<void> loginByGG(Map<String, dynamic> data) async {
    var response = await ApiClient()
        .request(ApiPath.loginByGG, ApiMethod.post, data: data);
    if (response?.statusCode == 200) {
      User user = User.fromJson(response?.data['data']['user']);
      await Storage.set('user_data', user.toJson().toString());
      await Storage.set('access_token', response?.data['data']['tokens']);
      await CurrentUser().init();
      // var token = await PushNotifications.getToken();
      // if (token != null) {
      //   await updateDeviceToken(CurrentUser().id ?? "", token);
      // }
      if (user.isNotNull) {
        Get.offAllNamed(Routes.DASHBOARD);
        showToastNotification(
            title: "Chào mừng bạn đến với Mia Milkshare",
            type: ToastificationType.success);
      }
    } else {
      showToastNotification(
          title: "Đăng nhập thất bài, vui lòng thử lại",
          type: ToastificationType.error);
    }
  }

  static Future<void> loginByFB(Map<String, dynamic> data) async {
    var response = await ApiClient()
        .request(ApiPath.loginByFB, ApiMethod.post, data: data);
    if (response?.statusCode == 200) {
      User user = User.fromJson(response?.data['data']['user']);
      await Storage.set('user_data', user.toJson().toString());
      await Storage.set('access_token', response?.data['data']['tokens']);
      await CurrentUser().init();
      // var token = await PushNotifications.getToken();
      // if (token != null) {
      //   await updateDeviceToken(CurrentUser().id ?? "", token);
      // }
      if (user.isNotNull) {
        Get.offAllNamed(Routes.DASHBOARD);
        showToastNotification(
            title: "Chào mừng bạn đến với Mia Milkshare",
            type: ToastificationType.success);
      }
    } else {
      showToastNotification(
          title: "Đăng nhập thất bài, vui lòng thử lại",
          type: ToastificationType.error);
    }
  }

  static Future<void> updateDeviceToken(String userId, String token) async {
    Map data = {'device_key': token};
    await ApiClient()
        .request("${ApiPath.users}$userId", ApiMethod.put, data: data);
  }

  static Future<void> getResetPasswordCode(String email) async {
    Map data = {'email': email};
    var response = await ApiClient()
        .request(ApiPath.forgotPassword, ApiMethod.post, data: data);
    if (response?.statusCode == 200) {
      showToastNotification(
          title: "Vui lòng kiểm tra email", type: ToastificationType.success);
    } else {
      showToastNotification(
          title: "Vui lòng thử lại!", type: ToastificationType.error);
    }
  }

  static Future<bool> checkResetPasswordCode(String email, String code) async {
    Map data = {'email': email, 'code': code};
    var response = await ApiClient()
        .request(ApiPath.checkCode, ApiMethod.post, data: data);
    if (response?.statusCode == 200) {
      showToastNotification(
          title: response?.data['message'], type: ToastificationType.success);
      return true;
    } else {
      showToastNotification(
          title: response?.data['message'], type: ToastificationType.error);
      return false;
    }
  }

  static Future<bool> resetPassword(String email, String password) async {
    Map data = {'email': email, 'password': password};
    var response = await ApiClient()
        .request(ApiPath.resetPassword, ApiMethod.post, data: data);
    if (response?.statusCode == 200) {
      showToastNotification(
          title: "Đổi mật khẩu thành công", type: ToastificationType.success);
      return true;
    } else {
      showToastNotification(
          title: "Đổi mật khẩu thất bại!", type: ToastificationType.error);
      return false;
    }
  }
}
