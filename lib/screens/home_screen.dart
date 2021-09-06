import 'package:aidar_zakaz/controllers/home_screen_controller.dart';
import 'package:aidar_zakaz/widgets/home_listview_shahe_widget.dart';
import 'package:aidar_zakaz/widgets/home_listview_widget.dart';
import 'package:aidar_zakaz/widgets/title.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends GetView<HomeScreenController> {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: ScrollController(),
      child: GetBuilder<HomeScreenController>(builder: (_) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Titlee('Популярные категории'),
            ListViewWidget(controller.itemsPopular, false),
            if (controller.historyCategories.length >= 1)
              const Titlee('Недавно прослушанные'),
            if (controller.historyCategories.length >= 1)
              ListViewWidget(controller.historyCategories, false),
            const Titlee('Популярные шейхи'),
            const SizedBox(height: 20),
            ListViewShaheWidget(controller.itemsShahe, false),
            const Titlee('Новые подборки'),
            ListViewWidget(controller.itemsPopular, false),
            if (controller.favCategories.length >= 1)
              const Titlee('Избранные категории'),
            if (controller.favCategories.length >= 1)
              ListViewWidget(controller.favCategories, true),
            if (controller.favShahes.length >= 1)
              const Titlee('Избранные шейхи'),
            if (controller.favShahes.length >= 1)
              ListViewShaheWidget(controller.favShahes, true),
          ],
        );
      }),
    );
  }
}
