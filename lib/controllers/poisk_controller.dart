import 'dart:async';
import 'package:aidar_zakaz/controllers/base_controller.dart';
import 'package:aidar_zakaz/models/lecture_model.dart';
import 'package:aidar_zakaz/models/shahe_model.dart';
import 'package:aidar_zakaz/services/base_client.dart';
import 'package:get/get.dart';

class PoiskController extends GetxController with BaseController {
  var isLoading = false;
  var listOfLectures = <LectureModel>[].obs;
  var listOfShahes = <ShaheModel>[];
  String? searchQuery;
  Timer? zaderjka;

  var filteredData = [].obs;
  var tabIndex = 0;
  void search(String query) {
    if (query.isNotEmpty) {
      zaderjka?.cancel();
      zaderjka = Timer(const Duration(milliseconds: 300), () async {
        var response =
            await BaseClient().get('/api/v1/lectures/?search=$query');
        // .catchError(handleError);
        if (response == null) return;
        final List<LectureModel> loadedLectures = [];
        for (var lec in response) {
          loadedLectures.add(LectureModel.fromJson(lec));
        }
        listOfLectures.assignAll(loadedLectures);
        if (tabIndex == 0) {
          filteredData.value = listOfLectures;
        } else if (tabIndex == 1) {
          filteredData.value = listOfShahes
              .where((model) =>
                  model.name.toLowerCase().contains(query.toLowerCase()))
              .toList();
        } else if (tabIndex == 2) {
          filteredData.value = listOfShahes
              .where((model) =>
                  model.name.toLowerCase().contains(query.toLowerCase()))
              .toList();
        }
      });
    } else {
      print(listOfLectures);
      filteredData.value = listOfLectures;
    }
  }

  void changeTab(int value) {
    tabIndex = value;
  }
}
