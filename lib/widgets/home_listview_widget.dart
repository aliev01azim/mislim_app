import 'package:aidar_zakaz/models/category_model.dart';
import 'package:aidar_zakaz/widgets/listview_item.dart';
import 'package:flutter/material.dart';

class ListViewWidget extends StatelessWidget {
  const ListViewWidget(this.items, this.withIcon, {Key? key}) : super(key: key);
  final List<CategoryModel> items;
  final bool withIcon;
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: 239,
        width: double.infinity,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(left: 10),
          controller: ScrollController(),
          itemCount: items.length,
          itemBuilder: (_, index) => ListviewItem(items[index], withIcon),
        ),
      ),
      const SizedBox(
        height: 20,
      ),
    ]);
  }
}
