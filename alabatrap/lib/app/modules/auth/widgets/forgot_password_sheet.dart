import 'package:alabatrap/app/modules/auth/widgets/authen_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../common/app_colors.dart';
import '../controllers/auth_controller.dart';
import 'authen_textfield.dart';
import 'change_password_sheet.dart';

class ForgotPasswordSheet extends GetWidget<AuthController> {
  const ForgotPasswordSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 400,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          )),
      child: Column(children: [
        Container(
          width: 20.w,
          height: 4,
          decoration: BoxDecoration(
            color: AppColor.grey,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Stack(
            children: [
              const Divider(height: 36),
              Align(
                alignment: Alignment.center,
                child: Container(
                    color: Theme.of(context).colorScheme.secondary,
                    child: Text(
                      '  Quên mật khẩu  ',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: Theme.of(context)
                              .colorScheme
                              .shadow
                              .withOpacity(0.8)),
                    )),
              )
            ],
          ),
        ),
        const SizedBox(height: 16),
        AuthenTextField(
          hintText: 'E-mail ID',
          textController: controller.emailForgotCtrl,
          onChange: controller.changeEmailForgot,
          validator: controller.validateEmail,
          keyboardType: TextInputType.emailAddress,
          prefixIcon: SvgPicture.asset(
            'assets/icons/email_icon.svg',
            fit: BoxFit.scaleDown,
          ),
          suffixIcon: TextButton(
              style: ButtonStyle(
                  overlayColor: WidgetStateProperty.all(Colors.transparent)),
              onPressed: () async {
                controller.countDown.value = 10;
                controller.runCountDown();
                controller.isDisableSend.value = true;
                await controller.forgotPassword();
              },
              child: Obx(() => Text(
                    '${controller.countDown.value != 0 ? '(${controller.countDown}s) ' : ''}Gửi',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: controller.isDisableSend.value
                            ? AppColor.grey
                            : AppColor.black),
                  ))),
        ),
        const SizedBox(height: 16),
        AuthenTextField(
          keyboardType: TextInputType.number,
          textController: controller.codeForgotCtrl,
          onChange: controller.changeCodeForgot,
          validator: controller.validateCode,
          hintText: 'Code',
          prefixIcon: SvgPicture.asset(
            'assets/icons/password_icon.svg',
            fit: BoxFit.scaleDown,
          ),
        ),
        const SizedBox(height: 24),
        AuthenButton(
          text: 'Khôi phục mật khẩu',
          onPressed: () async {
            bool result = await controller.checkResetPasswordCode();
            if (result) {
              showModalBottomSheet(
                  isScrollControlled: true,
                  // ignore: use_build_context_synchronously
                  context: context,
                  builder: (context) {
                    return Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: const ChangePasswordSheet(),
                    );
                  });
            } else {
              controller.codeForgotCtrl.clear();
              controller.codeForgot.value = '';
            }
          },
        ),
      ]),
    );
  }
}
