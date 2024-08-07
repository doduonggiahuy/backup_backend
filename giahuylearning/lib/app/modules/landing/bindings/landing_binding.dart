import 'package:get/get.dart';
import 'package:giahuylearning/app/modules/signin/controllers/signin_controller.dart';

import '../../signup/controllers/signup_controller.dart';
import '../controllers/landing_controller.dart';

class LandingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LandingController>(
      () => LandingController(),
    );
    Get.lazyPut<SigninController>(
      () => SigninController(),
    );
    Get.lazyPut<SignupController>(
      () => SignupController(),
    );
  }
}
