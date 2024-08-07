import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../common/app_colors.dart';
import '../controllers/auth_controller.dart';
import 'authen_button.dart';
import 'authen_textfield.dart';

class ChangePasswordSheet extends GetWidget<AuthController> {
  const ChangePasswordSheet({super.key});

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
                      '  Đổi mật khẩu  ',
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
          textController: controller.newPasswordCtrl,
          onChange: controller.changeNewPassword,
          validator: controller.validatePassword,
          hintText: 'Mật khẩu mới',
          prefixIcon: SvgPicture.asset(
            'assets/icons/password_icon.svg',
            fit: BoxFit.scaleDown,
          ),
        ),
        const SizedBox(height: 16),
        AuthenTextField(
          textController: controller.rePasswordCtrl,
          onChange: controller.changeRePassword,
          validator: controller.validateRePassword,
          hintText: 'Nhập lại mật khẩu',
          prefixIcon: SvgPicture.asset(
            'assets/icons/password_icon.svg',
            fit: BoxFit.scaleDown,
          ),
        ),
        const SizedBox(height: 24),
        AuthenButton(
          text: 'Đổi mật khẩu',
          onPressed: () {
            controller.resetPassword();
          },
        ),
      ]),
    );
  }
}
