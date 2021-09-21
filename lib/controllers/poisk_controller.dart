import 'dart:async';
import 'package:aidar_zakaz/controllers/base_controller.dart';
import 'package:aidar_zakaz/models/category_model.dart';
import 'package:aidar_zakaz/models/lecture_model.dart';
import 'package:aidar_zakaz/models/shahe_model.dart';
import 'package:aidar_zakaz/services/base_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class PoiskController extends GetxController with BaseController {
  var isLoading = false;
  String? _oldQuery;
  Timer? _zaderjka;
  var controller = TextEditingController();
  var filteredLectures = [].obs;
  var filteredAuthors = [].obs;
  var filteredCategories = [].obs;
  var tabIndex = 0;
  late final _lecturesBox = Hive.box<String>('lectures_history');
  late final _authorsBox = Hive.box<String>('authors_history');
  late final _categoriesBox = Hive.box<String>('categories_history');
  void search(String query) async {
    _zaderjka?.cancel();
    if (query != '') {
      controller.text = query.inCaps;
      controller.selection = TextSelection.fromPosition(
          TextPosition(offset: controller.text.length));
      _zaderjka = Timer(const Duration(milliseconds: 300), () async {
        if (tabIndex == 0) {
          var response =
              await BaseClient().get('/api/v1/search_lecture/?q=$query');
          if (response == null) return;
          final List<LectureModel> loadedLectures = [];
          for (var lec in response['data']) {
            loadedLectures.add(LectureModel.fromJson(lec));
          }
          filteredLectures.value = loadedLectures;
        } else if (tabIndex == 1) {
          var response =
              await BaseClient().get('/api/v1/search_author/?q=$query');
          if (response == null) return;
          final List<ShaheModel> loadedAuthors = [];
          for (var author in response['data']) {
            loadedAuthors.add(ShaheModel.fromJson(author));
          }
          filteredAuthors.value = loadedAuthors;
        } else {
          var response =
              await BaseClient().get('/api/v1/search_category/?q=$query');
          if (response == null) return;
          final List<CategoryModel> loadedCategories = [];
          for (var author in response['data']) {
            loadedCategories.add(CategoryModel.fromJson(author));
          }
          filteredCategories.value = loadedCategories;
        }
      });
    } else {
      filteredLectures.value = _lecturesBox.values.toList();
      filteredAuthors.value = _authorsBox.values.toList();
      filteredCategories.value = _categoriesBox.values.toList();
    }
  }

  void changeTab(int value) {
    tabIndex = value;
  }

  @override
  void onClose() {
    _lecturesBox.compact();
    _lecturesBox.close();
    _authorsBox.compact();
    _authorsBox.close();
    _categoriesBox.compact();
    _categoriesBox.close();
    controller.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    getLocalData();
    super.onInit();
  }

  void getLocalData() async {
    await Hive.openBox<String>('lectures_history')
        .then((value) => filteredLectures.value = value.values.toList());
    await Hive.openBox<String>('authors_history')
        .then((value) => filteredAuthors.value = value.values.toList());
    await Hive.openBox<String>('categories_history')
        .then((value) => filteredCategories.value = value.values.toList());
  }

  void addSearchHistory(String query) async {
    if (_oldQuery == query || query == '') return;
    if (tabIndex == 0) {
      await _lecturesBox.put(query.codeUnits.toString(), query);
    } else if (tabIndex == 1) {
      await _authorsBox.put(query.codeUnits.toString(), query);
    } else {
      await _categoriesBox.put(query.codeUnits.toString(), query);
    }
    _oldQuery = query;
  }

  void deleteHistory(String query) async {
    if (tabIndex == 0) {
      await _lecturesBox.delete(query.codeUnits.toString());
      filteredLectures.value = _lecturesBox.values.toList();
    } else if (tabIndex == 1) {
      await _authorsBox.delete(query.codeUnits.toString());
      filteredAuthors.value = _authorsBox.values.toList();
    } else {
      await _categoriesBox.delete(query.codeUnits.toString());
      filteredCategories.value = _categoriesBox.values.toList();
    }
  }
}

extension CapExtension on String {
  String get inCaps =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1)}' : '';
}
