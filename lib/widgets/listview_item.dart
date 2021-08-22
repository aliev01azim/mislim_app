import 'package:aidar_zakaz/bindings/item_detail_screen_binding.dart';
import 'package:aidar_zakaz/models/listview_item_model.dart';
import 'package:aidar_zakaz/screens/category_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListviewItem extends StatelessWidget {
  const ListviewItem(this.item, {Key? key}) : super(key: key);
  final ListviewItemModel item;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() => CategoryDetailScreen(item.title, item.url),
          binding: ItemDetailScreenBinding()),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        width: 160,
        child: Column(
          children: [
            Container(
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    item.url,
                  ),
                ),
              ),
            ),
            Text(
              item.title,
              style: const TextStyle(
                height: 1.5,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
        ),
      ),
    );
  }
}
