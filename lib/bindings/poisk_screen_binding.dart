import 'package:aidar_zakaz/controllers/poisk_controller.dart';
import 'package:get/get.dart';

class PoiskScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PoiskController>(() => PoiskController());
  }
}
