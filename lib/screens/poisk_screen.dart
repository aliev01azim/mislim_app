import 'package:aidar_zakaz/bindings/category_detail_screen_binding.dart';
import 'package:aidar_zakaz/controllers/poisk_controller.dart';
import 'package:aidar_zakaz/models/category_model.dart';
import 'package:aidar_zakaz/models/lecture_model.dart';
import 'package:aidar_zakaz/models/shahe_model.dart';
import 'package:aidar_zakaz/screens/audio_screen.dart';
import 'package:aidar_zakaz/screens/category_detail_screen.dart';
import 'package:aidar_zakaz/screens/category_shahe_detail_screen.dart';
import 'package:aidar_zakaz/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PoiskScreen extends GetView<PoiskController> {
  const PoiskScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            labelPadding: const EdgeInsets.only(bottom: 10, top: 15),
            indicatorColor: Colors.green,
            tabs: const [
              Text(
                'Лекции',
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
              Text(
                'Шейхи',
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
              Text(
                'Категории',
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
            ],
            onTap: (value) => controller.changeTab(value),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(left: 60, right: 10),
              width: MediaQuery.of(context).size.width - 70,
              child: TextField(
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Поиск',
                  hintStyle: const TextStyle(color: Colorss.dark),
                  filled: true,
                  fillColor: Colors.white.withAlpha(235),
                  border: InputBorder.none,
                ),
                controller: controller.controller,
                onSubmitted: (val) => controller.search(val),
                textInputAction: TextInputAction.search,
                onChanged: (query) => controller.search(query),
                enabled: true,
              ),
            ),
          ],
        ),
        body: TabBarView(children: [
          HistoryListTile(controller, controller.filteredLectures),
          HistoryListTile(controller, controller.filteredAuthors),
          HistoryListTile(controller, controller.filteredCategories)
        ]),
      ),
    );
  }
}

class HistoryListTile extends StatelessWidget {
  const HistoryListTile(this.controler, this.list, {Key? key})
      : super(key: key);
  final RxList<dynamic> list;
  final PoiskController controler;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          itemCount: list.length,
          itemBuilder: (context, index) {
            var item = list[index];
            return ListTile(
              onTap: () async {
                if (item is! String) {
                  controler.addSearchHistory(list[index].title);
                  if (item is CategoryModel) {
                    await Get.to(() => CategoryDetailScreen(item),
                        binding: CategoryDetailScreenBinding());
                  }
                  if (item is LectureModel) {
                    await Get.to(
                        () => const PlayScreen(
                              data: {
                                'response': [],
                                'index': 0,
                                'offline': false,
                              },
                              fromMiniplayer: false,
                            ),
                        binding: CategoryDetailScreenBinding(),
                        arguments: '');
                  }
                  if (item is ShaheModel) {
                    await Get.to(() => CategoryShaheDetailScreen(item),
                        binding: CategoryDetailScreenBinding());
                  }
                } else {
                  controler.search(list[index]);
                }
              },
              contentPadding: const EdgeInsets.only(left: 16, right: 0),
              trailing: item is String
                  ? IconButton(
                      onPressed: () => controler.deleteHistory(item),
                      icon: const Icon(Icons.clear))
                  : null,
              leading: item is String ? const Icon(Icons.history) : null,
              title: Text(
                item is String ? item : item.title,
                maxLines: 1,
              ),
              subtitle: item is String
                  ? null
                  : Text(
                      item.title,
                      maxLines: 1,
                    ),
            );
          },
        ),
      ),
    );
  }
}
