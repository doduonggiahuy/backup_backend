import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  final count = 0.obs;
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  void increment() => count.value++;
  final formKey = GlobalKey<FormState>();
}
