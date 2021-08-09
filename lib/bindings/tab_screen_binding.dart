import 'package:aidar_zakaz/controllers/tab_controller.dart';
import 'package:get/get.dart';

class HomeScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TabScreenController>(() => TabScreenController());
  }
}
