import 'package:flutter/material.dart';

import '../../../common/app_colors.dart';

class AuthenButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final bool isLoading;
  const AuthenButton(
      {super.key,
      required this.text,
      required this.onPressed,
      this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          splashFactory: NoSplash.splashFactory,
          backgroundColor: WidgetStateProperty.all(
              isLoading ? AppColor.grey : AppColor.green),
          padding: WidgetStateProperty.all(const EdgeInsets.all(16)),
        ),
        child: Text(text,
            style: const TextStyle(fontSize: 16, color: AppColor.white)),
      ),
    );
  }
}
