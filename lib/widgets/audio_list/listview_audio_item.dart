import 'package:aidar_zakaz/controllers/home_screen_controller.dart';
import 'package:aidar_zakaz/screens/audio_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListviewAudioItem extends GetView<HomeScreenController> {
  const ListviewAudioItem(this.item, this.response, this.index, {Key? key})
      : super(key: key);
  final Map<dynamic, dynamic> item;
  final List response;
  final int index;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(
        PageRouteBuilder(
          opaque: false,
          pageBuilder: (_, __, ___) => PlayScreen(
            data: {
              'response': response,
              'index': index,
              'offline': false,
            },
            fromMiniplayer: false,
          ),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 3),
        width: 150,
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(200),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(200),
                child: SizedBox(
                  height: 140,
                  child: CachedNetworkImage(
                    imageUrl:
                        'https://clipart-best.com/img/islam/islam-clip-art-31.png',
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Image(
                      image: AssetImage('assets/images/placeholder.jpg'),
                    ),
                    errorWidget: (context, url, error) => const Image(
                      image: AssetImage('assets/images/placeholder.jpg'),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 150,
              child: Text(
                item['title'] ?? "Без названия",
                textAlign: TextAlign.center,
                maxLines: 2,
                style: const TextStyle(
                  fontSize: 13,
                  height: 1,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
