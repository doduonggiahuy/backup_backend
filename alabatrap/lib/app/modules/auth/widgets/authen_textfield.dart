import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/app_colors.dart';
import '../controllers/auth_controller.dart';

class AuthenTextField extends GetWidget<AuthController> {
  final Widget prefixIcon;
  final Widget? suffixIcon;
  final String hintText;
  final TextInputType? keyboardType;
  final TextEditingController? textController;
  final Function? onChange;
  final Function? validator;
  AuthenTextField(
      {super.key,
      required this.prefixIcon,
      required this.hintText,
      this.textController,
      this.onChange,
      this.keyboardType,
      this.suffixIcon,
      this.validator});

  late final RxBool isPasswordType =
      (keyboardType == TextInputType.visiblePassword).obs;
  final RxBool passwordVisible = false.obs;

  void togglePasswordVisible() {
    passwordVisible.value = !passwordVisible.value;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => TextFormField(
          controller: textController,
          onChanged: (value) {
            onChange != null ? onChange!(value) : null;
          },
          validator: (value) {
            return validator != null ? validator!(value) : null;
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          keyboardType: keyboardType,
          cursorColor: Theme.of(context).colorScheme.shadow,
          obscureText: isPasswordType.value ? !passwordVisible.value : false,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(16),
            border: OutlineInputBorder(
              borderSide: const BorderSide(width: 1, color: AppColor.lightGrey),
              borderRadius: BorderRadius.circular(50),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1, color: AppColor.blue),
              borderRadius: BorderRadius.circular(50),
            ),
            hintText: hintText,
            prefixIcon: prefixIcon,
            suffixIcon: isPasswordType.value
                ? IconButton(
                    style: ButtonStyle(
                        overlayColor:
                            WidgetStateProperty.all(AppColor.transparent)),
                    onPressed: () {
                      togglePasswordVisible();
                    },
                    icon: Icon(!passwordVisible.value
                        ? Icons.visibility_off
                        : Icons.visibility))
                : suffixIcon,
          ),
        ));
  }
}
