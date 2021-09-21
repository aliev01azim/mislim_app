import 'package:aidar_zakaz/models/category_model.dart';
import 'package:aidar_zakaz/models/lecture_model.dart';
import 'package:aidar_zakaz/models/shahe_model.dart';
import 'package:aidar_zakaz/services/base_client.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import 'base_controller.dart';

class HomeScreenController extends GetxController with BaseController {
// for tabs
  var selectedIndex = 0;
  void changePage(int value) {
    selectedIndex = value;
    update();
  }

  //
  late final Box<CategoryModel> _favoriteCategories =
      Hive.box<CategoryModel>('favorite_categories');
  late final Box<ShaheModel> _favoriteShahes =
      Hive.box<ShaheModel>('favorite_shahes');
  late final Box<CategoryModel> _categorieHistory =
      Hive.box<CategoryModel>('history_categories');
  late final Box<LectureModel> _favoriteLectures =
      Hive.box<LectureModel>('favorite_lectuers');

  final List<CategoryModel> _items = [];

  get items => _items;
  //
  final List<CategoryModel> _itemsPopular = [];
  get itemsPopular => _itemsPopular;
//
  final List<ShaheModel> _itemsShahe = [];
  get shahes => _itemsShahe;
//
  @override
  void onClose() {
    _favoriteCategories.compact();
    _favoriteCategories.close();
    _favoriteShahes.compact();
    _favoriteShahes.close();
    _categorieHistory.compact();
    _categorieHistory.close();
    _favoriteLectures.compact();
    _favoriteLectures.close();
    super.onClose();
  }

  @override
  void onInit() {
    getLocalData();
    getCategories();
    getAuthors();
    super.onInit();
  }

  void getCategories() async {
    var response =
        await BaseClient().get('/api/v1/categories/').catchError(handleError);
    if (response == null) return;
    final List<CategoryModel> loadedCategories = [];
    for (var lec in response) {
      loadedCategories.add(CategoryModel.fromJson(lec));
    }
    _items.assignAll(loadedCategories);
    update();
  }

  void getAuthors() async {
    var response =
        await BaseClient().get('/api/v1/authors/').catchError(handleError);
    if (response == null) return;
    final List<ShaheModel> _loadedShahes = [];
    for (var shahe in response) {
      _loadedShahes.add(ShaheModel.fromJson(shahe));
    }
    _itemsShahe.assignAll(_loadedShahes);
    update();
  }

  void getLocalData() async {
    // adapters
    Hive.registerAdapter(CategoryModelAdapter());
    Hive.registerAdapter(ShaheModelAdapter());
    Hive.registerAdapter(LectureModelAdapter());
    var _favBox = await Hive.openBox<CategoryModel>('favorite_categories');
    var _shaheBox = await Hive.openBox<ShaheModel>('favorite_shahes');
    var _historyBox = await Hive.openBox<CategoryModel>('history_categories');
    var _favLecturesBox = await Hive.openBox<LectureModel>('favorite_lectuers');
    _favCategories = _favBox.values.toList();
    _favShahes = _shaheBox.values.toList();
    _historyCategories = _historyBox.values.toList();
    _favLectures = _favLecturesBox.values.toList();
    _historyBox.clear();
    update();
  }

  List<LectureModel> _favLectures = [];
  get favLectures => _favLectures;
  void addFavoriteLecture(LectureModel item) async {
    item.isFavorite = !item.isFavorite!;
    if (item.isFavorite == true) {
      await _favoriteLectures.put(item.id, item);
    } else {
      await _favoriteLectures.delete(item.id);
    }
    _favLectures = _favoriteLectures.values.toList();
    update();
  }

  List<CategoryModel> _favCategories = [];
  get favCategories => _favCategories;

  void addFavoriteCategory(CategoryModel item) async {
    item.isFavorite = !item.isFavorite!;
    if (item.isFavorite == true) {
      await _favoriteCategories.put(item.id, item);
    } else {
      await _favoriteCategories.delete(item.id);
    }
    _favCategories = _favoriteCategories.values.toList();
    update();
  }

  List<ShaheModel> _favShahes = [];
  get favShahes => _favShahes;

  void addFavoriteShahes(ShaheModel item) async {
    item.isFavorite = !item.isFavorite!;
    if (item.isFavorite == true) {
      await _favoriteShahes.put(item.id, item);
    } else {
      await _favoriteShahes.delete(item.id);
    }
    _favShahes = _favoriteShahes.values.toList();
    update();
  }

  List<CategoryModel> _historyCategories = [];
  get historyCategories => _historyCategories;
  void addHistory(CategoryModel item) async {
    item.dateTime = DateTime.now().add(const Duration(hours: 24));
    await _categorieHistory.put(item.id, item);
    for (var item in _historyCategories) {
      if (DateTime.now().isAfter(item.dateTime!)) {
        await _categorieHistory.delete(item.id);
      }
    }
    _historyCategories = _categorieHistory.values.toList();
    update();
  }
}
