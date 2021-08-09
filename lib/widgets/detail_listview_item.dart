import 'package:aidar_zakaz/models/listview_item_model.dart';
import 'package:aidar_zakaz/screens/item_detail_screen.dart';
import 'package:aidar_zakaz/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailListviewItem extends StatelessWidget {
  const DetailListviewItem(this.item, {Key? key}) : super(key: key);
  final ListviewItemModel item;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Get.to(() => ItemDetailScreen(item.title, item.name)),
      title: Text(
        item.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(item.name),
      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
        if (item.isFavorite!)
          IconButton(
            icon: const Icon(
              Icons.favorite,
              color: Colorss.primary,
            ),
            onPressed: () {},
          ),
        IconButton(
          icon: const Icon(Icons.more_horiz),
          onPressed: () {},
        ),
      ]),
    );
  }
}
