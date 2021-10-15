import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'listview__shahe_item.dart';

class ListViewShaheWidgetForLikedShahes extends StatelessWidget {
  const ListViewShaheWidgetForLikedShahes({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box('settings').listenable(),
        builder: (_, Box show, Widget? widget) {
          return (show.get('showLikedAuthors', defaultValue: true) as bool? ??
                  true)
              ? ValueListenableBuilder(
                  valueListenable: Hive.box('favorites').listenable(),
                  builder: (_, Box box, Widget? widget) {
                    final items =
                        box.get('likedShahes', defaultValue: []) as List;
                    return items.isNotEmpty
                        ? Column(children: [
                            SizedBox(
                              height: 126,
                              width: double.infinity,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.only(left: 10),
                                controller: ScrollController(),
                                itemCount: items.length,
                                itemBuilder: (_, index) =>
                                    ListviewShaheItem(items[index], true),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ])
                        : const SizedBox();
                  })
              : const SizedBox();
        });
  }
}
