import 'package:get/get.dart';

class DashboardController extends GetxController {
  var itemCount = 0.obs;
  var tabIndex = 0.obs;
  @override
  void onInit() {
    super.onInit();
    itemCount.value = 12;
  }

  void changeIndex(int index) {
    tabIndex.value = index;
  }

  void addItem() {
    itemCount++;
  }

  void removeItem() {
    if (itemCount > 0) {
      itemCount--;
    }
  }
}
