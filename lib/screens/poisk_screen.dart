import 'package:aidar_zakaz/controllers/poisk_controller.dart';
import 'package:aidar_zakaz/screens/audio_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'category_screen.dart';

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
                  hintStyle: const TextStyle(color: Colors.black87),
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
                  item['title'] != null
                      ? controler.addSearchHistory(item['title'])
                      : controler.addSearchHistory(item['name']);
                  if (controler.tabIndex == 2) {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailScreen(item as Map<dynamic, dynamic>),
                      ),
                    );
                  }
                  if (controler.tabIndex == 0) {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (___) => PlayScreen(
                          data: {
                            'response': list,
                            'index': 0,
                            'offline': false,
                          },
                          fromMiniplayer: false,
                        ),
                      ),
                    );
                  }
                  if (controler.tabIndex == 1) {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailScreen(item as Map<dynamic, dynamic>),
                      ),
                    );
                  }
                } else {
                  controler.search(item);
                }
              },
              contentPadding: const EdgeInsets.only(left: 16, right: 0),
              trailing: item is String
                  ? IconButton(
                      onPressed: () => controler.deleteHistory(item),
                      icon: const Icon(Icons.clear),
                    )
                  : item['duration'] != null
                      ? Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(
                            item['duration'] is! int
                                ? item['duration']
                                : '${(item['duration'] / 60).floor().toString()}:${item['duration'] % 60}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        )
                      : item['lectures'] != null
                          ? Text('${item['lectures'].length} лекций')
                          : null,
              leading: item is String ? const Icon(Icons.history) : null,
              title: item is String
                  ? Text(item, maxLines: 1)
                  : item['lectures'] == null
                      ? Text(item['title'], maxLines: 1)
                      : item['title'] != null
                          ? Text(item['title'], maxLines: 1)
                          : Text(item['name'], maxLines: 1),
              subtitle: item is String
                  ? null
                  : item['lectures'] == null
                      ? Text(item['artist'], maxLines: 1)
                      : null,
            );
          },
        ),
      ),
    );
  }
}
