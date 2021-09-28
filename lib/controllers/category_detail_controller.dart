import 'package:aidar_zakaz/all_about_audio/format.dart';
import 'package:aidar_zakaz/models/lecture_model.dart';
import 'package:aidar_zakaz/services/base_client.dart';
import 'package:get/get.dart';

import 'base_controller.dart';

class CategoryDetailController extends GetxController with BaseController {
  List<dynamic> _lecturesC = [];

  get lecturesC => _lecturesC;
  var isLoading = false;
  fetchLecOfCategories(int id) async {
    isLoading = true;
    var response =
        await BaseClient().get('/api/v1/category/$id').catchError(handleError);
    if (response == null) return;
    // final List<LectureModel> loadedLectures = [];
    final List<dynamic> loadedLectures = response['lectures'] as List<dynamic>;

    // for (var lec in response['lectures']) {
    //   loadedLectures.add(LectureModel.fromJson(lec));
    // }

    _lecturesC =
        await FormatResponse().formatSongsResponse(loadedLectures, 'playlist');
    isLoading = false;
    update();
  }

//
  final List<LectureModel> _lecturesA = [];
  get lecturesA => _lecturesA;
  fetchLecOfAuthors(int id) async {
    isLoading = true;
    var response =
        await BaseClient().get('/api/v1/author/$id').catchError(handleError);
    if (response == null) return;
    final List<LectureModel> loadedLectures = [];
    for (var lec in response['lectures']) {
      loadedLectures.add(LectureModel.fromJson(lec));
    }
    _lecturesA.assignAll(loadedLectures);
    isLoading = false;
    update();
  }
}
