import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

void showToastNotification(
    {required String title, required ToastificationType type}) {
  toastification.show(
    title: Text(title),
    alignment: Alignment.topRight,
    autoCloseDuration: const Duration(seconds: 3),
    type: type,
    style: ToastificationStyle.flat,
    margin: const EdgeInsets.only(top: 32, right: 16, left: 60),
  );
}
