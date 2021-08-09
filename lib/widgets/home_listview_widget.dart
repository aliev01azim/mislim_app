import 'package:aidar_zakaz/models/listview_item_model.dart';
import 'package:aidar_zakaz/widgets/listview_item.dart';
import 'package:flutter/material.dart';

class ListViewWidget extends StatelessWidget {
  const ListViewWidget(this.items, {Key? key}) : super(key: key);
  final List<ListviewItemModel> items;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 135,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 10),
        controller: ScrollController(),
        itemCount: items.length,
        itemBuilder: (_, index) => ListviewItem(items[index]),
      ),
    );
  }
}
