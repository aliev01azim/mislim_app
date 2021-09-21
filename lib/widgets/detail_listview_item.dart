import 'package:aidar_zakaz/controllers/home_screen_controller.dart';
import 'package:aidar_zakaz/models/category_model.dart';
import 'package:aidar_zakaz/models/lecture_model.dart';
import 'package:aidar_zakaz/screens/audio_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailListviewItem extends GetView<HomeScreenController> {
  const DetailListviewItem(this.lecture, this.category, {Key? key})
      : super(key: key);
  final LectureModel lecture;
  final CategoryModel category;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 16),
      tileColor: Colors.blueGrey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      onTap: () async {
        await Get.to(() => AudioScreen(lecture), arguments: '');
        controller.addHistory(category);
      },
      title: Text(
        lecture.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        lecture.author.title,
        maxLines: 1,
        style: const TextStyle(fontSize: 13),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(lecture.dueTime),
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
