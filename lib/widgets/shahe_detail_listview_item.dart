import 'package:aidar_zakaz/controllers/category_detail_controller.dart';
import 'package:aidar_zakaz/models/lecture_model.dart';
import 'package:aidar_zakaz/screens/audio_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShaheDetailListviewItem extends GetView<CategoryDetailController> {
  const ShaheDetailListviewItem(this.item, {Key? key}) : super(key: key);
  final LectureModel item;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 16),
      tileColor: Colors.blueGrey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      onTap: () {
        Get.to(
          () => const PlayScreen(
            data: {
              'response': [],
              'index': 0,
              'offline': false,
            },
            fromMiniplayer: false,
          ),
        );
      },
      title: Text(
        item.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        item.categoryTitle,
        style: const TextStyle(fontSize: 13),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(item.dueTime),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
            iconSize: 28,
            padding: const EdgeInsets.all(3),
          )
        ],
      ),
    );
  }
}
