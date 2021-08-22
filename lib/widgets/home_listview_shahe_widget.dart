import 'package:aidar_zakaz/models/listview_item_sheih_model.dart';
import 'package:flutter/material.dart';

import 'listview__shahe_item.dart';

class ListViewShaheWidget extends StatelessWidget {
  const ListViewShaheWidget(this.items, {Key? key}) : super(key: key);
  final List<ListviewItemShaheModel> items;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 10),
        controller: ScrollController(),
        itemCount: items.length,
        itemBuilder: (_, index) => ListviewShaheItem(items[index]),
      ),
    );
  }
}
