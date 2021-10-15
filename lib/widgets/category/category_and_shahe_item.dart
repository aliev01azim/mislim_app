import 'package:aidar_zakaz/controllers/category_detail_controller.dart';
import 'package:aidar_zakaz/screens/audio_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../add_queue.dart';

class DetailListviewItem extends GetView<CategoryDetailController> {
  const DetailListviewItem(this.lecture, this.index, this.url, {Key? key})
      : super(key: key);
  final Map<dynamic, dynamic> lecture;
  final int index;
  final String url;
  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      selectedColor: Theme.of(context).colorScheme.secondary,
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 16, right: 5.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        onTap: () async {
          await Navigator.of(context).push(
            PageRouteBuilder(
              opaque: false,
              pageBuilder: (_, __, ___) => PlayScreen(
                data: {
                  'response': controller.lecturesC,
                  'index': index,
                  'offline': false,
                },
                fromMiniplayer: lecture['url'] == url ? true : false,
              ),
            ),
          );
        },
        selected: lecture['url'] == url,
        title: Text(
          lecture['title'],
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          lecture['image'] == null ? lecture['artist'] : lecture['album'],
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 13,
          ),
        ),
        trailing: lecture['url'] == url
            ? IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.bar_chart_rounded,
                  size: 30,
                ),
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
                  AddToQueueButton(
                    data: lecture,
                  )
                ],
              ),
      ),
    );
  }
}
