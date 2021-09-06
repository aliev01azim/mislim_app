import 'package:aidar_zakaz/bindings/item_detail_screen_binding.dart';
import 'package:aidar_zakaz/controllers/home_screen_controller.dart';
import 'package:aidar_zakaz/models/lecture_model.dart';
import 'package:aidar_zakaz/screens/item_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShaheDetailListviewItem extends GetView<HomeScreenController> {
  const ShaheDetailListviewItem(this.item, {Key? key}) : super(key: key);
  final LectureModel item;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Get.to(() => ItemDetailScreen(item),
            binding: ItemDetailScreenBinding());
      },
      title: Text(
        item.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        // item.name,
        'asd',
        style: const TextStyle(fontSize: 13),
      ),
    );
  }
}
