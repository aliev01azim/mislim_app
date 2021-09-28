import 'package:aidar_zakaz/controllers/category_detail_controller.dart';
import 'package:aidar_zakaz/controllers/home_screen_controller.dart';
import 'package:aidar_zakaz/models/category_model.dart';
import 'package:aidar_zakaz/screens/audio_screen.dart';
import 'package:aidar_zakaz/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailListviewItem extends GetView<CategoryDetailController> {
  const DetailListviewItem(
      this.lecture, this.category, this.index, this.queueState,
      {Key? key})
      : super(key: key);
  final Map<dynamic, dynamic> lecture;
  final CategoryModel category;
  final int index;
  final QueueState queueState;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                offset: Offset.fromDirection(2),
                color: currentTheme.currentTheme() != ThemeMode.dark
                    ? Colors.grey[400]!
                    : Colors.grey[900]!,
                blurRadius: 2)
          ],
          color: currentTheme.currentTheme() != ThemeMode.dark
              ? Colors.white
              : const Color.fromRGBO(6, 18, 40, 1)),
      child: ListTileTheme(
        selectedColor: Theme.of(context).colorScheme.secondary,
        child: ListTile(
          contentPadding: const EdgeInsets.only(left: 16, right: 5.0),
          selected: lecture['url'] ==
              queueState.queue[queueState.queueIndex!].extras!['url'],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
          onTap: () async {
            await Get.to(
              () => PlayScreen(
                data: {
                  'response': controller.lecturesC,
                  'index': index,
                  'offline': false,
                },
                fromMiniplayer: false,
              ),
            );

            Get.find<HomeScreenController>().addHistory(category);
          },
          title: Text(
            lecture['title'],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: currentTheme.currentTheme() != ThemeMode.dark
                    ? const Color.fromRGBO(6, 18, 40, 1)
                    : Colors.white),
          ),
          subtitle: Text(
            lecture['artist'],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 13,
                color: currentTheme.currentTheme() != ThemeMode.dark
                    ? const Color.fromRGBO(6, 18, 40, 1)
                    : Colors.white),
          ),
          trailing: lecture['url'] ==
                  queueState.queue[queueState.queueIndex!].extras!['url']
              ? IconButton(
                  icon: const Icon(
                    Icons.bar_chart_rounded,
                    size: 30,
                  ),
                  tooltip: 'Playing',
                  onPressed: () {},
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      lecture['duration'].toString().contains(':')
                          ? lecture['duration']
                          : '${(lecture['duration'] / 60).toString().substring(0, 2).replaceAll('.', '')}:${(lecture['duration'] % 60).toString().padLeft(2, '0')}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.more_vert),
                      iconSize: 22,
                      padding: const EdgeInsets.all(3),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
