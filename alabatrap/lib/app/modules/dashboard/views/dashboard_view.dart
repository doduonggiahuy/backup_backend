import 'package:alabatrap/app/modules/chat/views/chat_view.dart';
import 'package:alabatrap/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:alabatrap/app/modules/home/controllers/home_controller.dart';
import 'package:alabatrap/app/modules/home/views/home_view.dart';
import 'package:alabatrap/app/modules/planing/views/planing_view.dart';
import 'package:alabatrap/app/modules/settings/views/settings_view.dart';
import 'package:boxicons/boxicons.dart';
import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:sizer/sizer.dart';

import '../../../common/app_colors.dart';
import '../widgets/left_drawer.dart';

class DashboardView extends GetView<DashboardController> {
  DashboardView({super.key});

  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
          toolbarHeight: 10.h,
          leadingWidth: 56.sp,
          centerTitle: true,
          // backgroundColor: AppColor.white,
          title: Image.asset(
            'assets/images/logo.png',
            width: 15.h,
          ),
          leading: Builder(
            builder: (context) {
              return Padding(
                padding: EdgeInsets.all(2.sp),
                child: IconButton(
                  icon: CircleAvatar(
                    radius: 20.sp,
                    backgroundColor: AppColor.greyButton,
                    child: Icon(
                      Boxicons.bx_menu_alt_left,
                      color: AppColor.black,
                      size: 24.sp,
                    ),
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
              );
            },
          ),
          actions: <Widget>[
            Builder(
              builder: (context) {
                return Padding(
                  padding: EdgeInsets.all(2.sp),
                  child: Stack(children: [
                    IconButton(
                      icon: CircleAvatar(
                        radius: 20.sp,
                        backgroundColor: AppColor.greyButton,
                        child: Icon(
                          Boxicons.bxl_shopify,
                          color: AppColor.black,
                          size: 24.sp,
                        ),
                      ),
                      onPressed: () {
                        Scaffold.of(context).openEndDrawer();
                      },
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Obx(() {
                        return Container(
                          padding: EdgeInsets.all(3.sp),
                          decoration: BoxDecoration(
                              border: Border.all(color: AppColor.white),
                              color: AppColor.red,
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                            child: Text(
                              controller.itemCount.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 7.sp,
                              ),
                            ),
                          ),
                        );
                      }),
                    )
                  ]),
                );
              },
            )
          ]),
      key: scaffoldKey,
      drawer: const LeftDrawer(),
      endDrawer: const LeftDrawer(),
      body: Obx(() {
        return CupertinoPageScaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.white,
          child: IndexedStack(
            index: controller.tabIndex.value,
            children: <Widget>[
              HomeView(),
              const ChatView(),
              const PlaningView(),
              const SettingsView()
            ],
          ),
        );
      }),
      bottomNavigationBar: Obx(() {
        return CrystalNavigationBar(
          margin: const EdgeInsets.all(0),
          currentIndex: controller.tabIndex.value,
          // indicatorColor: Colors.white,
          unselectedItemColor: Colors.white,
          backgroundColor: Colors.black.withOpacity(0.3),
          // outlineBorderColor: Colors.black.withOpacity(0.1),
          onTap: (index) {
            controller.changeIndex(index);
          },
          items: [
            /// Home
            CrystalNavigationBarItem(
              icon: IconlyBold.home,
              unselectedIcon: IconlyLight.home,
              selectedColor: AppColor.green,
            ),

            /// Favourite
            CrystalNavigationBarItem(
              icon: IconlyBold.activity,
              unselectedIcon: IconlyLight.activity,
              selectedColor: AppColor.green,
            ),

            /// Add
            CrystalNavigationBarItem(
              icon: IconlyBold.plus,
              unselectedIcon: IconlyLight.plus,
              selectedColor: AppColor.green,
            ),

            /// Search
            CrystalNavigationBarItem(
                icon: IconlyBold.search,
                unselectedIcon: IconlyLight.search,
                selectedColor: AppColor.green),

            /// Profile
          ],
        );
      }),
    );
  }
}
