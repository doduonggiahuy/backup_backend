import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:giahuylearning/app/modules/signup/views/signup_view.dart';
import 'package:sizer/sizer.dart';

import '../controllers/signin_controller.dart';

class SigninView extends GetView<SigninController> {
  const SigninView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: controller.formKey,
              child: Column(
                children: [
                  Hero(tag: 'landing', child: Image.asset('assets/task.jpg')),
                  TextFormField(
                    controller: controller.usernameController,
                    decoration:
                        const InputDecoration(hintText: 'Enter username'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter username';
                      } else {
                        return null;
                      }
                    },
                  ),
                  TextFormField(
                    controller: controller.passwordController,
                    decoration: InputDecoration(
                        hintText: 'Enter password',
                        suffix: IconButton(
                            onPressed: () {}, icon: const Icon(Icons.clear))),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      } else {
                        return null;
                      }
                    },
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: 45.w,
                      child: CheckboxListTile(
                        value: controller.remember.value,
                        onChanged: (bool? value) {
                          controller.remember.value = value!;
                        },
                        title: const Text('Remember me'),
                        contentPadding: const EdgeInsets.all(0),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 100.w,
                    child: ElevatedButton(
                        style: const ButtonStyle(
                          padding: WidgetStatePropertyAll<EdgeInsets>(
                            EdgeInsets.all(10),
                          ),
                          backgroundColor:
                              WidgetStatePropertyAll<Color>(Color(0xFF3535ce)),
                        ),
                        onPressed: () {},
                        child: const Text(
                          'Sign in',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        )),
                  ),
                  const Spacer(),
                  OutlinedButton(
                    onPressed: () {
                      Get.to(() => const SignupView(),
                          transition: Transition.rightToLeftWithFade);
                    },
                    child: const Text('Dont have an account? Sign up'),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
