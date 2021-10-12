import 'package:hive/hive.dart';

class FormatResponse {
  String formatString(String text) {
    return text
        .toString()
        .replaceAll('&amp;', '&')
        .replaceAll('&#039;', "'")
        .replaceAll('&quot;', '"')
        .trim();
  }

  Future<List> formatSongsResponse(List responseList) async {
    final List searchedList = [];
    for (int i = 0; i < responseList.length; i++) {
      Map? response;

      response = await formatSingleSongResponse(responseList[i] as Map);

      if (response.containsKey('Error')) {
        // ignore: avoid_print
        print('Error at index $i inside FormatResponse: ${response["Error"]}');
      } else {
        searchedList.add(response);
      }
    }
    return searchedList;
  }

  Future<List> formatSongsResponseShahes(
      Map<String, dynamic> responseMap) async {
    final List searchedList = [];
    for (int i = 0; i < responseMap['lectures'].length; i++) {
      Map? response;

      response = await formatSingleSongResponse(
          (responseMap['lectures'][i] as Map), responseMap['categoryImage']);

      if (response.containsKey('Error')) {
        // ignore: avoid_print
        print('Error at index $i inside FormatResponse: ${response["Error"]}');
      } else {
        searchedList.add(response);
      }
    }
    return searchedList;
  }

  Future<List> formatSongsResponseCategories(
      Map<String, dynamic> responseMap) async {
    final List searchedList = [];
    for (int i = 0; i < responseMap['lectures'].length; i++) {
      Map? response;

      response = await formatSingleSongResponse(
          (responseMap['lectures'][i] as Map), responseMap['image']);

      if (response.containsKey('Error')) {
        // ignore: avoid_print
        print('Error at index $i inside FormatResponse: ${response["Error"]}');
      } else {
        searchedList.add(response);
      }
    }
    return searchedList;
  }

  Future<Map> formatSingleSongResponse(Map response,
      [String? categoryImage]) async {
    try {
      final lectures = await Hive.box('favorites')
          .get('likedLectures', defaultValue: []) as List;
      Map? _item = lectures.firstWhere(
        (element) => element['id'] == response['id'].toString(),
        orElse: () => null,
      );
      bool _isFavorite = _item != null;
      return {
        'id': response['id'].toString(),
        'album': formatString(response['category']['title']),
        'duration': response['due_time'],
        'title': formatString(response['title']),
        'artist': formatString(response['author']['name']),
        'artistId': response['author']['id'].toString(),
        'categoryId': response['category']['id'].toString(),
        'categoryImage': categoryImage?.toString(),
        'image': 'https://clipart-best.com/img/islam/islam-clip-art-31.png',
        'isFavorite': _isFavorite,
        'url': response['lecture_file'].toString(),
      };
    } catch (e) {
      return {'Error': e};
    }
  }
}
