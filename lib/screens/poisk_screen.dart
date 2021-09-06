import 'package:aidar_zakaz/controllers/poisk_controller.dart';
import 'package:aidar_zakaz/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PoiskScreen extends GetView<PoiskController> {
  const PoiskScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetX<PoiskController>(builder: (_) {
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
                  onSubmitted: (val) => print(val),
                  textInputAction: TextInputAction.search,
                  onChanged: (query) => controller.search(query),
                  enabled: true,
                ),
              ),
            ],
          ),
          body: TabBarView(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                itemCount: controller.filteredData.length,
                itemBuilder: (context, index) {
                  // final restoranId =
                  //     controller.filteredData[index].restoranId;
                  return ListTile(
                    onTap: () {
                      // Navigator.of(context).pushNamed(
                      //     CafeDetailScreen.routeName,
                      //     arguments: restoranId);
                    },
                    title: Text(
                      controller.filteredData[index].title,
                      maxLines: 1,
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                physics: const ScrollPhysics(
                  parent: NeverScrollableScrollPhysics(),
                ),
                shrinkWrap: true,
                itemCount: controller.filteredData.length,
                itemBuilder: (context, i) => ListTile(
                  onTap: () {
                    // Navigator.of(context).pushNamed(
                    //     CafeDetailScreen.routeName,
                    //     arguments: restoranId);
                  },
                  title: Text(
                    controller.filteredData[i].name,
                    maxLines: 1,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: ListView(
                children: const [
                  ItemP('Коран и Тафсир'),
                  ItemP('Дуа'),
                  ItemP('Фикх'),
                  ItemP('Сунна Пророка'),
                  ItemP('Хадисы'),
                  ItemP('Акыда'),
                  ItemP('Жизнь Пророка'),
                  ItemP('Мудрость и Наставления'),
                  ItemP('Течения и секты'),
                  ItemP('История Ислама'),
                  ItemP('Оберегания человека'),
                ],
              ),
            ),
          ]),
        ),
      );
    });
  }
}

class ItemP extends StatelessWidget {
  const ItemP(this.title, {Key? key}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigator.of(context)
        //     .pushNamed(KuhnyaCategoryScreen.routeName, arguments: title);
      },
      child: ListTile(
        title: Text(
          title,
        ),
      ),
    );
  }
}
