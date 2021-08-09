import 'package:aidar_zakaz/controllers/home_screen_controller.dart';
import 'package:aidar_zakaz/widgets/home_listview_shahe_widget.dart';
import 'package:aidar_zakaz/widgets/home_listview_widget.dart';
import 'package:aidar_zakaz/widgets/title.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends GetView<HomeScreenController> {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: ScrollController(),
      child: GetBuilder<HomeScreenController>(
          init: HomeScreenController(),
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Titlee('Популярные категории'),
                ListViewWidget(controller.items),
                const SizedBox(
                  height: 20,
                ),
                const Titlee('Недавно прослушанные'),
                ListViewWidget(controller.items),
                const SizedBox(
                  height: 20,
                ),
                const Titlee('Шейхи и проповедники'),
                ListViewShaheWidget(controller.itemsShahe),
                const SizedBox(
                  height: 20,
                ),
                const Titlee('Новые подборки'),
                ListViewWidget(controller.items),
                const SizedBox(
                  height: 20,
                ),
                const Titlee('Избранные'),
                ListViewWidget(controller.items),
                const SizedBox(
                  height: 20,
                ),
              ],
            );
          }),
    );
  }
}
