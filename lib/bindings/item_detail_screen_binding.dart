import 'package:aidar_zakaz/controllers/item_detail_controller.dart';
import 'package:get/get.dart';

class ItemDetailScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ItemDetailController>(() => ItemDetailController());
  }
}
