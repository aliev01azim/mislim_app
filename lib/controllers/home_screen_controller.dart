import 'package:aidar_zakaz/models/category_model.dart';
import 'package:aidar_zakaz/models/lecture_model.dart';
import 'package:aidar_zakaz/models/shahe_model.dart';
import 'package:aidar_zakaz/services/base_client.dart';
import 'package:aidar_zakaz/utils/images.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import 'base_controller.dart';

class HomeScreenController extends GetxController with BaseController {
// for tabs
  var selectedIndex = 1;
  void changePage(int value) {
    selectedIndex = value;
    update();
  }

  //
  final List<LectureModel> _items = [
    // LectureModel(
    //   id: 1,
    //   category: 1,
    //   author: 1,
    //   title: 'Смысл жизни1 asd asdasd as das  asdadasdadd',
    //   // name: 'Azim weih',
    //   lecture_file:
    //       'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
    //   isFavorite: false,
    // ),
    // LectureModel(
    //   id: 2,
    //   category: 2,
    //   author: 2,
    //   title: 'Смысл жизни2',
    //   // name: 'Аиша Нурмандинова',
    //   lecture_file:
    //       'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
    //   isFavorite: true,
    // ),
    // LectureModel(
    //   id: 3,
    //   category: 3,
    //   author: 3,
    //   title: 'Смысл жизни3',
    //   // name: 'Azim weih',
    //   lecture_file:
    //       'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
    //   isFavorite: false,
    // ),
    // LectureModel(
    //   id: 4,
    //   category: 4,
    //   author: 2,
    //   title: 'Смысл жизни4',
    //   // name: 'Azim weih',
    //   lecture_file:
    //       'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
    //   isFavorite: false,
    // ),
    // LectureModel(
    //   id: 5,
    //   category: 5,
    //   author: 4,
    //   title: 'Смысл жизни5',
    //   // name: 'Azim weih',
    //   lecture_file:
    //       'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3',
    //   isFavorite: false,
    // ),
    // LectureModel(
    //   id: 6,
    //   category: 6,
    //   author: 5,
    //   title: 'Смысл жизни6',
    //   // name: 'Azim weih',
    //   lecture_file:
    //       'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-6.mp3',
    //   isFavorite: false,
    // ),
    // LectureModel(
    //   id: 7,
    //   category: 7,
    //   author: 5,
    //   title: 'Смысл жизни7',
    //   // name: 'Azim weih',
    //   lecture_file:
    //       'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-7.mp3',
    //   isFavorite: false,
    // ),
  ];

  get items => _items;
  //
  final List<CategoryModel> _itemsPopular = [
    CategoryModel(
        id: 1,
        name: 'Коран и Тафсир sa da s das das dasd dsa das das da d ad ',
        url: Images.kuran),
    CategoryModel(id: 2, name: 'Дуа', url: Images.dua),
    CategoryModel(id: 3, name: 'Акыда', url: Images.akyda),
    CategoryModel(id: 4, name: 'Сунна Пророка', url: Images.sunna),
    CategoryModel(id: 5, name: 'Хадисы', url: Images.hadis),
    CategoryModel(id: 6, name: 'Фикх', url: Images.fikh),
    CategoryModel(id: 7, name: 'Жизнь Пророка', url: Images.prorok),
  ];
  get itemsPopular => _itemsPopular;
//
  final List<ShaheModel> _itemsShahe = [
    ShaheModel(name: 'Салих аль-Фаузан', id: 1),
    ShaheModel(name: 'Абдуллахаджи Хидирбек', id: 2),
    ShaheModel(name: 'Алиев Азим', id: 3),
    ShaheModel(name: 'Абдуллахаджи Хидирбек', id: 4),
    ShaheModel(name: 'Салих аль-Фаузан', id: 5),
  ];
  get itemsShahe => _itemsShahe;

  // @override
  // void onClose() {
  //   Hive.box<CategoryModel>('favorite_categories').compact();
  //   Hive.box<CategoryModel>('favorite_categories').close();
  //   Hive.box<ShaheModel>('favorite_shahes').compact();
  //   Hive.box<ShaheModel>('favorite_shahes').close();
  //   super.onClose();
  // }

  @override
  void onInit() {
    getLocalData();
    getLectures();
    super.onInit();
  }

  void getLectures() async {
    var response =
        await BaseClient().get('/api/v1/lectures/').catchError(handleError);
    if (response == null) return;
    final List<LectureModel> loadedLectures = [];
    for (var lec in response) {
      loadedLectures.add(LectureModel.fromJson(lec));
    }
    _items.assignAll(loadedLectures);
    update();
  }

  void getLocalData() async {
    Hive.registerAdapter(CategoryModelAdapter());
    Hive.registerAdapter(ShaheModelAdapter());
    var favBox = await Hive.openBox<CategoryModel>('favorite_categories');
    var shaheBox = await Hive.openBox<ShaheModel>('favorite_shahes');
    var historyBox = await Hive.openBox<CategoryModel>('history_categories');
    _favCategories = favBox.values.toList();
    _favShahes = shaheBox.values.toList();
    _historyCategories = historyBox.values.toList();
    update();
  }

  // потом при запросе controller.getData() или он инит())

  List<CategoryModel> _favCategories = [];
  get favCategories => _favCategories;

  void addFavoriteCategory(CategoryModel item) async {
    item.isFavorite = !item.isFavorite!;
    var box = Hive.box<CategoryModel>('favorite_categories');
    if (item.isFavorite == true) {
      await box.put(item.id, item);
    } else {
      await box.delete(item.id);
    }
    _favCategories = box.values.toList();
    // box.close();
    update();
  }

  List<ShaheModel> _favShahes = [];
  get favShahes => _favShahes;

  void addFavoriteShahes(ShaheModel item) async {
    item.isFavorite = !item.isFavorite!;
    var box = Hive.box<ShaheModel>('favorite_shahes');
    if (item.isFavorite == true) {
      await box.put(item.id, item);
    } else {
      await box.delete(item.id);
    }
    _favShahes = box.values.toList();
    // box.close();
    update();
  }

  List<CategoryModel> _historyCategories = [];
  get historyCategories => _historyCategories;
  void addHistory(CategoryModel item) async {
    if (_historyCategories.contains(item)) {
      return;
    }
    var box = Hive.box<CategoryModel>('history_categories');
    await box.add(item);
    _historyCategories = box.values.toList().reversed.toList();
    if (box.values.length >= 10) {
      box.clear();
    }
    update();
  }
}
