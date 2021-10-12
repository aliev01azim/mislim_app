import 'package:aidar_zakaz/services/base_client.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import 'base_controller.dart';

class HomeScreenController extends GetxController with BaseController {
  final List _items = [];
  final List _shaheItems = [];

  List get items => _items;
  List get shahes => _shaheItems;

  @override
  void onClose() {
    Hive.box('recentlyPlayed').compact();
    Hive.box('recentlyPlayed').close();
    Hive.box('favorites').compact();
    Hive.box('favorites').close();
    super.onClose();
  }

  @override
  void onInit() {
    getCategories();
    getAuthors();
    super.onInit();
  }

  void getCategories() async {
    var response =
        await BaseClient().get('/api/v1/categories/').catchError(handleError);
    if (response == null) return;
    final List loadedCategories = [];
    for (var lec in response) {
      (lec as Map<String, dynamic>).addAll({'isFavorite': 'false'});
      loadedCategories.add(lec);
    }
    _items.assignAll(loadedCategories);
    update();
  }

  void getAuthors() async {
    var response =
        await BaseClient().get('/api/v1/authors/').catchError(handleError);
    if (response == null) return;
    final List _loadedShahes = [];
    for (var shahe in response) {
      (shahe as Map<String, dynamic>).addAll({'isFavorite': 'false'});
      _loadedShahes.add(shahe);
    }
    _shaheItems.assignAll(_loadedShahes);
    update();
  }
}
