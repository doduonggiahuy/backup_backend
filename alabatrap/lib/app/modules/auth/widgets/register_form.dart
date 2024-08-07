import 'package:alabatrap/app/common/app_colors.dart';
import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import 'authen_button.dart';
import 'authen_textfield.dart';

class RegisterForm extends GetWidget<AuthController> {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          child: Column(
            children: [
              AuthenTextField(
                  textController: controller.nameSignupCtrl,
                  onChange: controller.changeNameSignup,
                  validator: controller.validateUsername,
                  hintText: 'Tên tài khoản',
                  prefixIcon:
                      const Icon(Boxicons.bxs_user, color: AppColor.black)),
              const SizedBox(height: 16),
              AuthenTextField(
                  textController: controller.emailSignupCtrl,
                  onChange: controller.changeEmailSignup,
                  validator: controller.validateEmail,
                  hintText: 'E-mail ID',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon:
                      const Icon(Icons.email_outlined, color: AppColor.black)),
              const SizedBox(height: 16),
              AuthenTextField(
                  textController: controller.passwordSignupCtrl,
                  onChange: controller.changePasswordSignup,
                  validator: controller.validatePassword,
                  hintText: 'Mật khẩu',
                  keyboardType: TextInputType.visiblePassword,
                  prefixIcon:
                      const Icon(Icons.lock_outline, color: AppColor.black)),
              const SizedBox(height: 16),
              AuthenTextField(
                textController: controller.phoneSignupCtrl,
                onChange: controller.changePhoneSignup,
                validator: controller.validatePhone,
                hintText: 'Số điện thoại',
                keyboardType: TextInputType.phone,
                prefixIcon: const Icon(Icons.phone, color: AppColor.black),
              ),
              const SizedBox(height: 24),
              Obx(() => AuthenButton(
                    text: 'Đăng ký',
                    isLoading: controller.isLoading.value,
                    onPressed: () {
                      controller.isLoading.value = true;
                      controller.signup();
                    },
                  )),
            ],
          ),
        ));
  }
}
