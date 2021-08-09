import 'package:aidar_zakaz/models/listview_item_model.dart';
import 'package:aidar_zakaz/models/listview_item_sheih_model.dart';
import 'package:get/get.dart';

class HomeScreenController extends GetxController {
  final List<ListviewItemModel> _items = [
    ListviewItemModel(
      title: 'Смысл жизни asd asdasd as das  asdadasdadd',
      name: 'Azim weih',
      url:
          'https://img5.goodfon.ru/wallpaper/nbig/b/11/gorod-vecher-mechet-arkhitektura-religiia-oae-kupola-mechet.jpg',
      thumbnailUrl: '',
      isFavorite: false,
    ),
    ListviewItemModel(
      title: 'Смысл жизни',
      name: 'Аиша Нурмандинова',
      url:
          'https://img5.goodfon.ru/wallpaper/nbig/b/11/gorod-vecher-mechet-arkhitektura-religiia-oae-kupola-mechet.jpg',
      thumbnailUrl: '',
      isFavorite: true,
    ),
    ListviewItemModel(
      title: 'Смысл жизни',
      name: 'Azim weih',
      url:
          'https://img5.goodfon.ru/wallpaper/nbig/b/11/gorod-vecher-mechet-arkhitektura-religiia-oae-kupola-mechet.jpg',
      thumbnailUrl: '',
      isFavorite: false,
    ),
    ListviewItemModel(
      title: 'Смысл жизни',
      name: 'Azim weih',
      url:
          'https://img5.goodfon.ru/wallpaper/nbig/b/11/gorod-vecher-mechet-arkhitektura-religiia-oae-kupola-mechet.jpg',
      thumbnailUrl: '',
      isFavorite: false,
    ),
    ListviewItemModel(
      title: 'Смысл жизни',
      name: 'Azim weih',
      url:
          'https://img5.goodfon.ru/wallpaper/nbig/b/11/gorod-vecher-mechet-arkhitektura-religiia-oae-kupola-mechet.jpg',
      thumbnailUrl: '',
      isFavorite: false,
    ),
    ListviewItemModel(
      title: 'Смысл жизни',
      name: 'Azim weih',
      url:
          'https://img5.goodfon.ru/wallpaper/nbig/b/11/gorod-vecher-mechet-arkhitektura-religiia-oae-kupola-mechet.jpg',
      thumbnailUrl: '',
      isFavorite: false,
    ),
    ListviewItemModel(
      title: 'Смысл жизни',
      name: 'Azim weih',
      url:
          'https://img5.goodfon.ru/wallpaper/nbig/b/11/gorod-vecher-mechet-arkhitektura-religiia-oae-kupola-mechet.jpg',
      thumbnailUrl: '',
      isFavorite: false,
    ),
  ];
  get items => _items;
  final List<ListviewItemShaheModel> _itemsShahe = [
    ListviewItemShaheModel(name: 'Салих аль-Фаузан', isMale: true),
    ListviewItemShaheModel(name: 'Абдуллахаджи Хидирбекова', isMale: false),
    ListviewItemShaheModel(name: 'Салих аль-Фаузан', isMale: true),
    ListviewItemShaheModel(name: 'Абдуллахаджи Хидирбекова', isMale: false),
    ListviewItemShaheModel(name: 'Салих аль-Фаузан', isMale: true),
  ];
  get itemsShahe => _itemsShahe;

  bool isShowing = false;
  void show() {
    isShowing = true;
    update();
  }
}
