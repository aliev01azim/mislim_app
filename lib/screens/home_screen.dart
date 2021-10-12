import 'package:aidar_zakaz/controllers/home_screen_controller.dart';
import 'package:aidar_zakaz/widgets/audio_list/listview_audio.dart';
import 'package:aidar_zakaz/widgets/category/listview_widget.dart';
import 'package:aidar_zakaz/widgets/category/listview_widget_liked.dart';
import 'package:aidar_zakaz/widgets/shahe/listview_shahe_widget.dart';
import 'package:aidar_zakaz/widgets/shahe/listview_shahe_widget_liked.dart';
import 'package:aidar_zakaz/widgets/title.dart';
import 'package:aidar_zakaz/widgets/title_for_lectures.dart';
import 'package:aidar_zakaz/widgets/title_for_others.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: ScrollController(),
      child: GetBuilder<HomeScreenController>(builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const TitleeForLectures('Прослушанные лекции'),
            const ListViewWidgetForLectures(),
            const Titlee('Популярные темы'),
            ListViewWidget(
              controller.items.take(10).toList(),
            ),
            const Titlee('Ученые и шейхи'),
            const SizedBox(height: 20),
            ListViewShaheWidget(controller.shahes.take(15).toList()),
            const Titlee('Новые подборки'),
            ListViewWidget(
              controller.items.reversed.take(10).toList(),
            ),
            const TitleeForOthers('Избранные темы', 'temi'),
            const ListViewWidgetForLikedCategories(),
            const TitleeForOthers('Избранные шейхи', 'shahes'),
            const ListViewShaheWidgetForLikedShahes(),
          ],
        );
      }),
    );
  }
}
