import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:toastification/toastification.dart';

import 'app/routes/app_pages.dart';

void main() {
  runApp(Sizer(builder: (context, orientation, deviceType) {
    return ToastificationWrapper(
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        title: "TaskList App",
        initialRoute: AppPages.initial,
        getPages: AppPages.routes,
      ),
    );
  }));
}
