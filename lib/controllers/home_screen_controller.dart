import 'package:aidar_zakaz/models/listview_item_model.dart';
import 'package:aidar_zakaz/models/listview_item_sheih_model.dart';
import 'package:aidar_zakaz/models/listview_popular_item_model.dart';
import 'package:aidar_zakaz/utils/images.dart';
import 'package:get/get.dart';

class HomeScreenController extends GetxController {
  final List<ListviewItemModel> _items = [
    ListviewItemModel(
      title: 'Смысл жизни asd asdasd as das  asdadasdadd',
      name: 'Azim weih',
      url:
          'https://img5.goodfon.ru/wallpaper/nbig/b/11/gorod-vecher-mechet-arkhitektura-religiia-oae-kupola-mechet.jpg',
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      isFavorite: false,
    ),
    ListviewItemModel(
      title: 'Смысл жизни',
      name: 'Аиша Нурмандинова',
      url:
          'https://img5.goodfon.ru/wallpaper/nbig/b/11/gorod-vecher-mechet-arkhitektura-religiia-oae-kupola-mechet.jpg',
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
      isFavorite: true,
    ),
    ListviewItemModel(
      title: 'Смысл жизни',
      name: 'Azim weih',
      url:
          'https://img5.goodfon.ru/wallpaper/nbig/b/11/gorod-vecher-mechet-arkhitektura-religiia-oae-kupola-mechet.jpg',
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
      isFavorite: false,
    ),
    ListviewItemModel(
      title: 'Смысл жизни',
      name: 'Azim weih',
      url:
          'https://img5.goodfon.ru/wallpaper/nbig/b/11/gorod-vecher-mechet-arkhitektura-religiia-oae-kupola-mechet.jpg',
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
      isFavorite: false,
    ),
    ListviewItemModel(
      title: 'Смысл жизни',
      name: 'Azim weih',
      url:
          'https://img5.goodfon.ru/wallpaper/nbig/b/11/gorod-vecher-mechet-arkhitektura-religiia-oae-kupola-mechet.jpg',
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3',
      isFavorite: false,
    ),
    ListviewItemModel(
      title: 'Смысл жизни',
      name: 'Azim weih',
      url:
          'https://img5.goodfon.ru/wallpaper/nbig/b/11/gorod-vecher-mechet-arkhitektura-religiia-oae-kupola-mechet.jpg',
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-6.mp3',
      isFavorite: false,
    ),
    ListviewItemModel(
      title: 'Смысл жизни',
      name: 'Azim weih',
      url:
          'https://img5.goodfon.ru/wallpaper/nbig/b/11/gorod-vecher-mechet-arkhitektura-religiia-oae-kupola-mechet.jpg',
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-7.mp3',
      isFavorite: false,
    ),
  ];
  get items => _items;
  //
  final List<PopularListviewItemModel> _itemsPopular = [
    PopularListviewItemModel(name: 'Коран и Тафсир', url: Images.kuran),
    PopularListviewItemModel(name: 'Дуа', url: Images.dua),
    PopularListviewItemModel(name: 'Фикх', url: Images.fikh),
    PopularListviewItemModel(name: 'Сунна Пророка', url: Images.sunna),
    PopularListviewItemModel(name: 'Хадисы', url: Images.hadis),
    PopularListviewItemModel(name: 'Акыда', url: Images.akyda),
    PopularListviewItemModel(name: 'Жизнь Пророка', url: Images.prorok),
  ];
  get itemsPopular => _itemsPopular;
  final List<ListviewItemShaheModel> _itemsShahe = [
    ListviewItemShaheModel(name: 'Салих аль-Фаузан'),
    ListviewItemShaheModel(name: 'Абдуллахаджи Хидирбек'),
    ListviewItemShaheModel(name: 'Алиев Азим'),
    ListviewItemShaheModel(name: 'Абдуллахаджи Хидирбек'),
    ListviewItemShaheModel(name: 'Салих аль-Фаузан'),
  ];
  get itemsShahe => _itemsShahe;

  bool isShowing = false;
  void show() {
    isShowing = true;
    update();
  }
}
