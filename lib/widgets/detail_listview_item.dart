import 'package:aidar_zakaz/bindings/item_detail_screen_binding.dart';
import 'package:aidar_zakaz/controllers/home_screen_controller.dart';
import 'package:aidar_zakaz/models/category_model.dart';
import 'package:aidar_zakaz/models/lecture_model.dart';
import 'package:aidar_zakaz/screens/item_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailListviewItem extends GetView<HomeScreenController> {
  const DetailListviewItem(this.item, this.category, {Key? key})
      : super(key: key);
  final LectureModel item;
  final CategoryModel category;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Get.to(() => ItemDetailScreen(item),
            binding: ItemDetailScreenBinding());
        controller.addHistory(category);
      },
      title: Text(
        item.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        'asd',
        // item.name,
        style: const TextStyle(fontSize: 13),
      ),
    );
  }
}
