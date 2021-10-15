import 'package:aidar_zakaz/all_about_audio/mediaitem_converter.dart';
import 'package:aidar_zakaz/screens/audio_screen.dart';
import 'package:aidar_zakaz/services/service_locator.dart';
import 'package:aidar_zakaz/widgets/snackbar.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class AddToQueueButton extends StatelessWidget {
  AddToQueueButton({Key? key, required this.data}) : super(key: key);
  final Map data;
  final audioHandler = getIt<AudioPlayerHandler>();
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        icon: Icon(
          Icons.more_vert_rounded,
          color: Theme.of(context).iconTheme.color,
        ),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        itemBuilder: (context) => [
              // PopupMenuItem(
              //     textStyle: const TextStyle(fontSize: 13),
              //     padding: const EdgeInsets.only(
              //         top: 4, bottom: 4, left: 12, right: 6),
              //     value: 2,
              //     child: Row(
              //       mainAxisSize: MainAxisSize.min,
              //       children: [
              //         if ((Hive.box('favorites')
              //                 .get('likedLectures', defaultValue: []) as List)
              //             .contains(widget.data)) ...[
              //           Icon(
              //             Icons.remove_done,
              //             color: Theme.of(context).iconTheme.color,
              //           ),
              //         ] else ...[
              //           Icon(
              //             Icons.favorite,
              //             color: Theme.of(context).iconTheme.color,
              //           ),
              //         ],
              //         const SizedBox(width: 10.0),
              //         if ((Hive.box('favorites')
              //                 .get('likedLectures', defaultValue: []) as List)
              //             .contains(widget.data)) ...[
              //           const Text('Из избранных'),
              //         ] else ...[
              //           const Text('В избранные'),
              //         ]
              //       ],
              //     )),
              PopupMenuItem(
                  textStyle: const TextStyle(fontSize: 13),
                  padding: const EdgeInsets.only(
                      top: 4, bottom: 4, left: 12, right: 6),
                  value: 1,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.queue_play_next_rounded,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      const SizedBox(width: 10.0),
                      const Text(
                        'Слушать следующим',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  )),
              PopupMenuItem(
                  textStyle: const TextStyle(fontSize: 13),
                  padding: const EdgeInsets.only(
                      top: 4, bottom: 4, left: 12, right: 6),
                  value: 4,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.playlist_add_rounded,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      const SizedBox(width: 10.0),
                      const Text(
                        'Добавить в очередь',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  )),
              PopupMenuItem(
                  textStyle: const TextStyle(fontSize: 13),
                  padding: const EdgeInsets.only(
                      top: 4, bottom: 4, left: 12, right: 6),
                  value: 3,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.share_rounded,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      const SizedBox(width: 10.0),
                      const Text('Поделиться'),
                    ],
                  )),
            ],
        onSelected: (int? value) async {
          final MediaItem mediaItem = MediaItemConverter().mapToMediaItem(data);

          if (value == 1) {
            final MediaItem? currentMediaItem = audioHandler.mediaItem.value;
            if (currentMediaItem != null &&
                currentMediaItem.extras!['url'].toString().startsWith('http')) {
              final queue = audioHandler.queue.value;
              if (queue.contains(mediaItem)) {
                if (queue.indexOf(mediaItem) <
                        queue.indexOf(currentMediaItem) &&
                    queue.indexOf(currentMediaItem) == queue.length - 1) {
                  await audioHandler.removeQueueItem(mediaItem);
                  await audioHandler.addQueueItem(mediaItem);
                  await audioHandler.moveQueueItem(
                      queue.length - 1, queue.indexOf(currentMediaItem));
                } else {
                  await audioHandler.moveQueueItem(queue.indexOf(mediaItem),
                      queue.indexOf(currentMediaItem) + 1);
                }
              } else {
                await audioHandler.addQueueItem(mediaItem);
                await audioHandler.moveQueueItem(
                    queue.length, queue.indexOf(currentMediaItem) + 1);
              }

              ShowSnackBar().showSnackBar(
                '"${mediaItem.title}" поставится следующим',
              );
            } else {
              ShowSnackBar().showSnackBar(
                currentMediaItem == null
                    ? 'Отсутсвует аудио'
                    : "Нельзя добавить онлайн аудио к оффлайн очереди",
              );
            }
          }

          // if (value == 2) {
          //   final MediaItem? currentMediaItem = audioHandler.mediaItem.value;
          //   if (currentMediaItem != null &&
          //       currentMediaItem.extras!['url'].toString().startsWith('http')) {
          //     widget.data['isFavorite'] =
          //         widget.data['isFavorite'] == 'false' ? 'true' : 'false';
          //     final lectures = Hive.box('favorites')
          //         .get('likedLectures', defaultValue: []) as List;
          //     if (widget.data['isFavorite'] == 'true') {
          //       lectures.insert(0, widget.data);
          //       await Hive.box('favorites').put('likedLectures', lectures);
          //     } else {
          //       lectures.remove(widget.data);
          //       await Hive.box('favorites').put('likedLectures', lectures);
          //     }

          //     if (!lectures.contains(widget.data)) {
          //       ShowSnackBar().showSnackBar(
          //         TabScreen().scaffoldMessengerState!.currentContext,
          //         '"${mediaItem.title}" удалено из избранных',
          //       );
          //     } else {
          //       ShowSnackBar().showSnackBar(
          //         TabScreen().scaffoldMessengerState!.currentContext,
          //         '"${mediaItem.title}" добавлено в избранные',
          //       );
          //     }
          //   } else {
          //     ShowSnackBar().showSnackBar(
          //       TabScreen().scaffoldMessengerState!.currentContext,
          //       currentMediaItem == null
          //           ? 'Отсутсвует аудио'
          //           : "Не удалось добавить аудио",
          //     );
          //   }
          // }
          if (value == 3) {
            await Share.share(data['url'].toString());
          }
          if (value == 4) {
            final MediaItem? currentMediaItem = audioHandler.mediaItem.value;
            if (currentMediaItem != null &&
                currentMediaItem.extras!['url'].toString().startsWith('http')) {
              if (audioHandler.queue.value.contains(mediaItem)) {
                ShowSnackBar().showSnackBar(
                  '"${mediaItem.title}"уже в очереди',
                );
              } else {
                await audioHandler.addQueueItem(mediaItem);

                ShowSnackBar().showSnackBar(
                  '"${mediaItem.title}" добавлен в очередь',
                );
              }
            } else {
              ShowSnackBar().showSnackBar(
                currentMediaItem == null
                    ? 'Отсутсвует аудио'
                    : "Нельзя добавить онлайн аудио к оффлайн очереди",
              );
            }
          }
        });
  }
}
