import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/app_colors.dart';
import '../../../data/services/firebase_service.dart';
import '../controllers/auth_controller.dart';
import 'authen_button.dart';
import 'authen_textfield.dart';
import 'forgot_password_sheet.dart';

class LoginForm extends GetWidget<AuthController> {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          child: Column(
            children: [
              AuthenTextField(
                textController: controller.emailLoginCtrl,
                onChange: controller.changeEmailLogin,
                validator: controller.validateEmail,
                hintText: 'E-mail ID',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(
                  Icons.email_outlined,
                  color: AppColor.black,
                ),
              ),
              const SizedBox(height: 16),
              AuthenTextField(
                textController: controller.passwordLoginCtrl,
                onChange: controller.changePasswordLogin,
                validator: controller.validatePassword,
                hintText: 'Mật khẩu',
                keyboardType: TextInputType.visiblePassword,
                prefixIcon: const Icon(
                  Icons.lock_outline,
                  color: AppColor.black,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: Obx(() => Checkbox(
                              activeColor: AppColor.green,
                              value: controller.isSavePw.value,
                              onChanged: (value) {
                                controller.isChangePw();
                              },
                            )),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                          onTap: () {
                            controller.isChangePw();
                          },
                          child: const Text('Lưu mật khẩu'))
                    ],
                  ),
                  TextButton(
                      style: ButtonStyle(
                          overlayColor:
                              WidgetStateProperty.all(Colors.transparent)),
                      onPressed: () {
                        showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (context) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: const ForgotPasswordSheet(),
                              );
                            });
                      },
                      child: const Text(
                        'Quên mật khẩu?',
                        style: TextStyle(color: AppColor.black),
                      ))
                ],
              ),
              const SizedBox(height: 16),
              Obx(() => AuthenButton(
                    text: 'Đăng nhập',
                    isLoading: controller.isLoading.value,
                    onPressed: () {
                      controller.isLoading.value = true;
                      controller.login();
                    },
                  )),
              Container(
                  margin: const EdgeInsets.all(24),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: const Text(
                    '  Hoặc đăng nhập với  ',
                    style: TextStyle(color: AppColor.black, fontSize: 14),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(),
                  ElevatedButton(
                      onPressed: () {
                        controller.isLoading.value = true;
                        FirebaseServices().signInWithGoogle();
                      },
                      style: ButtonStyle(
                          // backgroundColor: WidgetStateProperty.all(
                          //     Theme.of(context).colorScheme.primary),
                          padding: WidgetStateProperty.all(
                              const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 16)),
                          side: WidgetStateProperty.all(
                            BorderSide(
                                width: 1,
                                color: AppColor.darkGrey.withOpacity(.5)),
                          )),
                      child: Row(
                        children: [
                          const Image(
                              image:
                                  AssetImage('assets/icons/google_brand.png'),
                              width: 20,
                              height: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Google',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.shadow),
                          )
                        ],
                      )),
                  ElevatedButton(
                      onPressed: () {
                        controller.isLoading.value = true;
                        FirebaseServices().signInWithFacebook();
                      },
                      style: ButtonStyle(
                          // backgroundColor: WidgetStateProperty.all(
                          //     Theme.of(context).colorScheme.primary),
                          side: WidgetStateProperty.all(
                            BorderSide(
                                width: 1,
                                color: AppColor.darkGrey.withOpacity(.5)),
                          ),
                          padding: WidgetStateProperty.all(
                              const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 16))),
                      child: Row(
                        children: [
                          const Image(
                              image:
                                  AssetImage('assets/icons/facebook_brand.png'),
                              width: 20,
                              height: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Facebook',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.shadow),
                          )
                        ],
                      )),
                  const SizedBox(),
                ],
              )
            ],
          ),
        ));
  }
}
