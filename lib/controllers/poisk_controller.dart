import 'package:aidar_zakaz/models/listview_item_model.dart';
import 'package:aidar_zakaz/models/listview_item_sheih_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PoiskController extends GetxController {
  var isLoading = false.obs;
  var listOfTitles = <ListviewItemModel>[];
  var listOfShahes = <ListviewItemShaheModel>[];
  @override
  void onInit() {
    fetchAllData();
    super.onInit();
  }

  void fetchAllData() {
    isLoading(true);
    // var url = Uri.parse(
    //     'https://kenguroo-14a75-default-rtdb.firebaseio.com/cafes.json');
    // try {
    //   final response = await get(url);
    //   final restoranData = json.decode(response.body) as Map<String, dynamic>;
    //   if (restoranData == null) {
    //     return;
    //   }

    //   final List<PoiskoviksDataModel> loadedProducts = [];
    //   restoranData.forEach((prodId, prodData) {
    //     loadedProducts.add(PoiskoviksDataModel(
    //         restoranId: prodId,
    //         restoranTitle: prodData['title'],
    //         foods: prodData['foods']));
    //   });
    final List<ListviewItemModel> loadedProducts = [
      ListviewItemModel(
        title: 'Смысл жизни asd asdasd as das  asdadasdadd',
        name: 'Azim weih',
        url:
            'https://img5.goodfon.ru/wallpaper/nbig/b/11/gorod-vecher-mechet-arkhitektura-religiia-oae-kupola-mechet.jpg',
        audioUrl:
            'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
        isFavorite: false,
      ),
      ListviewItemModel(
        title: 'Смысл жизни',
        name: 'Аиша Нурмандинова',
        url:
            'https://img5.goodfon.ru/wallpaper/nbig/b/11/gorod-vecher-mechet-arkhitektura-religiia-oae-kupola-mechet.jpg',
        audioUrl:
            'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
        isFavorite: true,
      ),
      ListviewItemModel(
        title: 'Смысл жизни',
        name: 'Azim weih',
        url:
            'https://img5.goodfon.ru/wallpaper/nbig/b/11/gorod-vecher-mechet-arkhitektura-religiia-oae-kupola-mechet.jpg',
        audioUrl:
            'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
        isFavorite: false,
      ),
      ListviewItemModel(
        title: 'Смысл жизни',
        name: 'Azim weih',
        url:
            'https://img5.goodfon.ru/wallpaper/nbig/b/11/gorod-vecher-mechet-arkhitektura-religiia-oae-kupola-mechet.jpg',
        audioUrl:
            'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
        isFavorite: false,
      ),
      ListviewItemModel(
        title: 'Смысл жизни',
        name: 'Azim weih',
        url:
            'https://img5.goodfon.ru/wallpaper/nbig/b/11/gorod-vecher-mechet-arkhitektura-religiia-oae-kupola-mechet.jpg',
        audioUrl:
            'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3',
        isFavorite: false,
      ),
      ListviewItemModel(
        title: 'Смысл жизни',
        name: 'Azim weih',
        url:
            'https://img5.goodfon.ru/wallpaper/nbig/b/11/gorod-vecher-mechet-arkhitektura-religiia-oae-kupola-mechet.jpg',
        audioUrl:
            'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-6.mp3',
        isFavorite: false,
      ),
      ListviewItemModel(
        title: 'Смысл жизни',
        name: 'Azim weih',
        url:
            'https://img5.goodfon.ru/wallpaper/nbig/b/11/gorod-vecher-mechet-arkhitektura-religiia-oae-kupola-mechet.jpg',
        audioUrl:
            'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-7.mp3',
        isFavorite: false,
      ),
    ];
    listOfTitles = loadedProducts;
    isLoading(false);
  }
  // finally {
  //   isLoading(false);
  // }

  var filteredData = [];
  final searchController = TextEditingController();
  var enabled = true.obs;
  var tabIndex = 0;
  void _search() {
    final query = searchController.text;
    if (query.isNotEmpty) {
      if (tabIndex == 0) {
        filteredData = listOfTitles
            .where((ListviewItemModel model) =>
                model.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
      } else if (tabIndex == 1) {
        filteredData = listOfShahes
            .where((model) =>
                model.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    } else {
      filteredData = listOfTitles;
    }
  }

  void changeTab(int value) {
    tabIndex = value;
    if (tabIndex == 2) {
      enabled(false);
    } else {
      enabled(true);
    }
  }

  @override
  void onClose() {
    searchController.removeListener(() {
      _search();
    });
    searchController.dispose();
    super.onClose();
  }

  initState() {
    filteredData = listOfTitles;
    searchController.addListener(_search);
  }
}
