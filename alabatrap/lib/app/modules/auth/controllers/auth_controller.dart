import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';

import '../../../core/api/api_repository/auth_repo.dart';
import '../../../core/util/func/toastication.dart';

class AuthController extends GetxController {
  final TextEditingController emailLoginCtrl = TextEditingController();
  final TextEditingController passwordLoginCtrl = TextEditingController();
  final TextEditingController emailSignupCtrl = TextEditingController();
  final TextEditingController passwordSignupCtrl = TextEditingController();
  final TextEditingController nameSignupCtrl = TextEditingController();
  final TextEditingController phoneSignupCtrl = TextEditingController();
  final TextEditingController emailForgotCtrl = TextEditingController();
  final TextEditingController codeForgotCtrl = TextEditingController();
  final TextEditingController newPasswordCtrl = TextEditingController();
  final TextEditingController rePasswordCtrl = TextEditingController();
  final RxString emailLogin = ''.obs;
  final RxString passwordLogin = ''.obs;
  final RxString emailSignup = ''.obs;
  final RxString passwordSignup = ''.obs;
  final RxString nameSignup = ''.obs;
  final RxString phoneSignup = ''.obs;
  final RxString emailForgot = ''.obs;
  final RxString codeForgot = ''.obs;
  final RxString newPassword = ''.obs;
  final RxString rePassword = ''.obs;
  final RxBool isSavePw = false.obs;
  final RxInt countDown = 0.obs;
  final RxBool isDisableSend = true.obs;
  final RxBool isLoading = false.obs;

  void isChangePw() {
    isSavePw.value = !isSavePw.value;
  }

  void changeEmailLogin(String value) {
    emailLogin.value = value;
  }

  void changePasswordLogin(String value) {
    passwordLogin.value = value;
  }

  void changeEmailSignup(String value) {
    emailSignup.value = value;
  }

  void changePasswordSignup(String value) {
    passwordSignup.value = value;
  }

  void changeNameSignup(String value) {
    nameSignup.value = value;
  }

  void changePhoneSignup(String value) {
    phoneSignup.value = value;
  }

  void changeEmailForgot(String value) {
    emailForgot.value = value;
    if (validateEmail(emailForgot.value) == null && countDown.value == 0) {
      isDisableSend.value = false;
    } else {
      isDisableSend.value = true;
    }
  }

  void changeCodeForgot(String value) {
    codeForgot.value = value;
  }

  void changeNewPassword(String value) {
    newPassword.value = value;
  }

  void changeRePassword(String value) {
    rePassword.value = value;
  }

  void runCountDown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (countDown.value != 0) {
        countDown.value--;
        runCountDown();
      } else {
        isDisableSend.value = false;
      }
    });
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập email!';
    }
    final regex = RegExp(r'\S+@\S+\.\S+');
    if (value.isNotEmpty && !regex.hasMatch(value)) {
      return 'Email không hợp lệ!';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mật khẩu!';
    }
    if (value.length < 8) {
      return "Tối thiểu 8 ký tự!";
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return "Mật khẩu phải có chữ số!";
    }
    return null;
  }

  String? validateRePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mật khẩu!';
    }
    if (value.length < 8) {
      return "Tối thiểu 8 ký tự!";
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return "Mật khẩu phải có chữ số!";
    }
    return null;
  }

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập tên người dùng!';
    }
    if (value.length < 3) {
      return 'Tên người dùng phải có ít nhất 3 ký tự!';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập số điện thoại!';
    }
    final regex = RegExp(r'^\+?[0-9]{10,15}$');
    if (value.isNotEmpty && !regex.hasMatch(value)) {
      return 'Số điện thoại không hợp lệ!';
    }
    return null;
  }

  String? validateCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mã code!';
    }
    final regex = RegExp(r'^\+?[0-9]{6}$');
    if (value.isNotEmpty && !regex.hasMatch(value)) {
      return 'Mã code không hợp lệ!';
    }
    return null;
  }

  Future<void> signup() async {
    String email = emailSignup.value;
    String password = passwordSignup.value;
    String username = nameSignup.value;
    String phone = phoneSignup.value;
    if (validateEmail(email) == null &&
        validatePassword(password) == null &&
        validateUsername(username) == null &&
        validatePhone(phone) == null) {
      await AuthApi.signup(username, email, password, phone);
    }
    isLoading.value = false;
  }

  Future<void> login() async {
    String email = emailLogin.value;
    String password = passwordLogin.value;
    if (validateEmail(email) == null && validatePassword(password) == null) {
      await AuthApi.login(email, password);
    }
    isLoading.value = false;
  }

  Future<void> forgotPassword() async {
    String email = emailForgot.value;
    if (validateEmail(email) == null) {
      await AuthApi.getResetPasswordCode(email.trim());
    }
  }

  Future<bool> checkResetPasswordCode() async {
    String email = emailForgot.value;
    String code = codeForgot.value;
    if (validateEmail(email) == null && validateCode(code) == null) {
      return await AuthApi.checkResetPasswordCode(email, code);
    }
    return false;
  }

  Future<void> resetPassword() async {
    String email = emailForgot.value;
    String password = newPassword.value;
    String repassword = rePassword.value;
    if (repassword != password) {
      showToastNotification(
          title: "Mật khẩu không trùng khớp", type: ToastificationType.warning);
      return;
    }
    if (validateEmail(email) == null && validatePassword(password) == null) {
      bool result = await AuthApi.resetPassword(email, password);
      if (result) {
        Get.back();
        Get.back();
        emailForgot.value = '';
        codeForgot.value = '';
        newPassword.value = '';
        rePassword.value = '';
        emailForgotCtrl.clear();
        codeForgotCtrl.clear();
        newPasswordCtrl.clear();
        rePasswordCtrl.clear();
      }
    }
  }
}
