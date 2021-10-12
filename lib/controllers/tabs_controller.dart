import 'package:get/get.dart';

class TabsController extends GetxController {
// for main tabs
  var selectedIndex = 0;
  void changePage(int value) {
    selectedIndex = value;
    update();
  }

  // for library tabs
  var selectedIndex2 = 0;
  void changePage2(int value) {
    selectedIndex2 = value;
    update();
  }
}
