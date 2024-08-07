import 'package:get/get.dart';

import '../../signup/controllers/signup_controller.dart';
import '../controllers/signin_controller.dart';

class SigninBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SigninController>(
      () => SigninController(),
    );
    // Get.lazyPut<SignupController>(
    //   () => SignupController(),
    // );
  }
}
