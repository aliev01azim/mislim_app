import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import 'listview_item.dart';

class ListViewWidgetForLikedCategories extends StatelessWidget {
  const ListViewWidgetForLikedCategories({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box('favorites').listenable(),
        builder: (_, Box box, Widget? widget) {
          final items = box.get('likedCategories', defaultValue: []) as List;
          return items.isNotEmpty
              ? Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 196,
                      width: double.infinity,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(left: 10),
                        controller: ScrollController(),
                        itemCount: items.length,
                        itemBuilder: (_, index) =>
                            ListviewItem(items[index], true),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                )
              : const SizedBox();
        });
  }
}
