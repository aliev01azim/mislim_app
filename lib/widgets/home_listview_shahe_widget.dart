import 'package:aidar_zakaz/models/shahe_model.dart';
import 'package:flutter/material.dart';

import 'listview__shahe_item.dart';

class ListViewShaheWidget extends StatelessWidget {
  const ListViewShaheWidget(this.items, this.withIcon, {Key? key})
      : super(key: key);
  final List<ShaheModel> items;
  final bool withIcon;
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: items.isNotEmpty ? 126 : 60,
        width: double.infinity,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(left: 10),
          controller: ScrollController(),
          itemCount: items.length,
          itemBuilder: (_, index) => ListviewShaheItem(items[index], withIcon),
        ),
      ),
      const SizedBox(
        height: 20,
      ),
    ]);
  }
}
