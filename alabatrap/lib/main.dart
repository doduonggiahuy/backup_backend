import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import 'app/routes/app_pages.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(DevicePreview(
      enabled: true,
      builder: (context) => Sizer(
            builder: (context, orientation, deviceType) => GetMaterialApp(
                theme: Get.theme,
                debugShowCheckedModeBanner: false,
                title: "Application",
                initialRoute: AppPages.INITIAL,
                getPages: AppPages.routes),
          )));
}
