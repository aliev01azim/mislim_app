import 'package:aidar_zakaz/all_about_audio/format.dart';
import 'package:aidar_zakaz/services/base_client.dart';
import 'package:get/get.dart';

import 'base_controller.dart';

class CategoryDetailController extends GetxController with BaseController {
  List<dynamic> _lecturesC = [];

  get lecturesC => _lecturesC;
  var isLoading = false;
  fetchLecOfCategoriesOrShahes(String path) async {
    isLoading = true;
    var response =
        await BaseClient().get('/api/v1/$path').catchError(handleError);
    if (response == null) return;
    final Map<String, dynamic> loadedLectures =
        response as Map<String, dynamic>;
    _lecturesC = loadedLectures['image'] != null
        ? await FormatResponse().formatSongsResponseCategories(loadedLectures)
        : await FormatResponse().formatSongsResponseShahes(loadedLectures);
    isLoading = false;
    update();
  }
}
