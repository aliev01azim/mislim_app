import 'package:aidar_zakaz/controllers/category_detail_controller.dart';
import 'package:get/get.dart';

class CategoryDetailScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CategoryDetailController>(() => CategoryDetailController());
  }
}
