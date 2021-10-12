import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'listview_audio_item.dart';

class ListViewWidgetForLectures extends StatelessWidget {
  const ListViewWidgetForLectures({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box('settings').listenable(),
        builder: (_, Box show, Widget? widget) {
          var items = Hive.box('recentlyPlayed')
              .get('recentSongs', defaultValue: []) as List;
          if (items.isNotEmpty &&
              items.any((element) => element['title'] == 'kachaet')) {
            items.removeWhere((element) => element['title'] == 'kachaet');
          }
          return (show.get('showRecent', defaultValue: true) as bool? ?? true)
              ? Column(children: [
                  SizedBox(
                    height: items.isEmpty ? 0 : 185,
                    width: double.infinity,
                    child:items.isEmpty? ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(left: 10),
                      controller: ScrollController(),
                      itemCount: items.length,
                      itemBuilder: (_, index) => ValueListenableBuilder(
                          valueListenable:
                              Hive.box('recentlyPlayed').listenable(),
                          builder: (_, Box box, Widget? widget) {
                            var items = box.get('recentSongs', defaultValue: [])
                                as List;
                            if (items.isNotEmpty &&
                                items.any((element) => element['id'] == '1')) {
                              items.removeWhere(
                                  (element) => element['id'] == '1');
                            }
                            return ListviewAudioItem(
                                items[index], items, index);
                          }),
                    ):const SizedBox(),
                  ),
                ])
              : const SizedBox();
        });
  }
}
