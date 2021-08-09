import 'package:get/get.dart';

class TabScreenController extends GetxController {
  var selectedIndex = 0;
  void changePage(int value) {
    selectedIndex = value;
    update();
  }
}
