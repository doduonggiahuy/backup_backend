import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:giahuylearning/app/common/core/api/api_func.dart';
import 'package:giahuylearning/app/modules/signin/views/signin_view.dart';

import '../controllers/landing_controller.dart';

class LandingView extends GetView<LandingController> with Func {
  LandingView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Hero(tag: 'landing', child: Image.asset('assets/task.jpg')),
          const Text(
            'Organize your tasks',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'List and organize your tasks to help your stay productive',
              textAlign: TextAlign.center,
            ),
          ),
          ElevatedButton(
              onPressed: () async {
                await getLoginStatus(context);
              },
              style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(15)),
              child: const Icon(CupertinoIcons.forward))
        ],
      )),
    );
  }
}
