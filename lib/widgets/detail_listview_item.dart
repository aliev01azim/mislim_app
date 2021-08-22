import 'package:aidar_zakaz/bindings/item_detail_screen_binding.dart';
import 'package:aidar_zakaz/models/listview_item_model.dart';
import 'package:aidar_zakaz/screens/item_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailListviewItem extends StatelessWidget {
  const DetailListviewItem(this.item, {Key? key}) : super(key: key);
  final ListviewItemModel item;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Get.to(() => ItemDetailScreen(item),
          binding: ItemDetailScreenBinding()),
      title: Text(
        item.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        item.name,
        style: const TextStyle(fontSize: 13),
      ),
    );
  }
}
