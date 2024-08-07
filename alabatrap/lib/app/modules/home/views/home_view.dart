import 'package:alabatrap/app/common/app_colors.dart';
import 'package:alabatrap/app/data/models/shoes.dart';
import 'package:alabatrap/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:boxicons/boxicons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  final DashboardController dashboardController = Get.find();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => controller.fetchShoes(),
      child: Scaffold(
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.sp),
            width: 100.w,
            height: 100.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Center(
                  child: Container(
                    width: 80.w,
                    margin: EdgeInsets.only(top: 1.h, left: 5.w, right: 5.w),
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                          color: const Color(0xff1D1617).withOpacity(0.11),
                          blurRadius: 10,
                          spreadRadius: 0.0)
                    ]),
                    child: TextField(
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.all(15),
                          hintText: 'Search Brands, Colors, etc.',
                          hintStyle: TextStyle(
                              color: const Color(0xffDDDADA), fontSize: 9.sp),
                          prefixIcon: const Padding(
                            padding: EdgeInsets.all(12),
                            child:
                                Icon(Boxicons.bx_search, color: Colors.black),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none)),
                    ),
                  ),
                ),
                SizedBox(height: 3.h),
                Text('Products',
                    style: TextStyle(
                        fontSize: 12.sp, fontWeight: FontWeight.bold)),
                Expanded(
                  child: Obx(() {
                    if (controller.shoesList.isEmpty) {
                      return const Center(child: CupertinoActivityIndicator());
                    } else {
                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        scrollDirection: Axis.vertical,
                        itemCount: controller.shoesList.length,
                        itemBuilder: (context, index) {
                          final shoes = controller.shoesList[index];
                          return IetmListShoesHome(shoes: shoes);
                        },
                      );
                    }
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class IetmListShoesHome extends StatelessWidget {
  const IetmListShoesHome({
    super.key,
    required this.shoes,
  });

  final Shoes shoes;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Container(
        padding: EdgeInsets.all(2.w),
        margin: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                  color: const Color(0xff1D1617).withOpacity(0.1),
                  blurRadius: 1,
                  spreadRadius: 1.0)
            ]),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Center(
                  child: Stack(children: [
                Image.network(shoes.image, width: 45.w, height: 45.w),
                Positioned(
                  right: 0,
                  child: Icon(
                    Boxicons.bx_heart,
                    size: 16.sp,
                  ),
                ),
              ])),
              SizedBox(
                width: 65.w,
                child: Text(
                  shoes.name,
                  style: TextStyle(fontSize: 15.sp),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              shoes.rating.rate != 0
                  ? Text(
                      'Available',
                      style: TextStyle(fontSize: 10.sp),
                    )
                  : Text(
                      ' Not Available',
                      style: TextStyle(fontSize: 10.sp, color: AppColor.red),
                    ),
              Text(
                '\$${shoes.price.toStringAsFixed(0)}',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }
}
