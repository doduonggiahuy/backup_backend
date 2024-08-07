import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../common/app_colors.dart';
import '../controllers/auth_controller.dart';
import '../widgets/login_form.dart';
import '../widgets/register_form.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthenViewState();
}

class _AuthenViewState extends State<AuthView> with TickerProviderStateMixin {
  AuthController controller = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 2, vsync: this);
    return SafeArea(
      child: Scaffold(
          body: Stack(
        children: [
          SizedBox(
              width: 100.w,
              height: 100.h,
              child: const Image(
                image: AssetImage('assets/images/stockx_banner_vertical.png'),
                fit: BoxFit.cover,
              )),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.only(top: 24),
              height: 65.h,
              decoration: BoxDecoration(
                color: AppColor.lightGrey.withOpacity(0.6),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40)),
              ),
              child: Column(children: [
                IntrinsicWidth(
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                        color: AppColor.grey.withOpacity(.4),
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: AppColor.black,
                        )),
                    child: TabBar(
                        labelColor: AppColor.black,
                        unselectedLabelColor: AppColor.black,
                        splashFactory: NoSplash.splashFactory,
                        isScrollable: true,
                        tabAlignment: TabAlignment.start,
                        labelPadding:
                            const EdgeInsets.symmetric(horizontal: 32),
                        indicator: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(color: AppColor.darkGrey, blurRadius: 1)
                            ],
                            color: AppColor.green,
                            borderRadius: BorderRadius.circular(50)),
                        indicatorSize: TabBarIndicatorSize.tab,
                        controller: tabController,
                        dividerColor: Colors.transparent,
                        labelStyle: TextStyle(
                            fontSize: 11.sp, fontWeight: FontWeight.w500),
                        tabs: const [
                          Tab(text: 'Đăng Nhập'),
                          Tab(text: 'Đăng Ký'),
                        ]),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 16),
                    child: TabBarView(
                        controller: tabController,
                        children: const [LoginForm(), RegisterForm()]),
                  ),
                )
              ]),
            ),
          ),
        ],
      )),
    );
  }
}
