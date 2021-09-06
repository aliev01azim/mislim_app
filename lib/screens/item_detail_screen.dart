import 'package:aidar_zakaz/controllers/item_detail_controller.dart';
import 'package:aidar_zakaz/models/lecture_model.dart';
import 'package:aidar_zakaz/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemDetailScreen extends GetView<ItemDetailController> {
  const ItemDetailScreen(this.item, {Key? key}) : super(key: key);
  final LectureModel item;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF03174C),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          'https://img5.goodfon.ru/wallpaper/nbig/b/11/gorod-vecher-mechet-arkhitektura-religiia-oae-kupola-mechet.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colorss.dark.withOpacity(0.4), Colorss.dark],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(
                        height: 52.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(50.0)),
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_drop_down,
                              ),
                              onPressed: () => Get.back(),
                              color: Colors.white,
                            ),
                          ),
                          Column(
                            children: [
                              Text(
                                'PLAYLIST',
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.6)),
                              ),
                              const Text(
                                'Best Vibes of the Week',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 40,
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        item.title,
                        maxLines: 4,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                            fontSize: 22.0),
                      ),
                      const SizedBox(
                        height: 6.0,
                      ),
                      Text(
                        // item.name,
                        'asd',
                        textAlign: TextAlign.start,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontStyle: FontStyle.italic,
                            fontSize: 16.0),
                      ),
                      const SizedBox(height: 16.0),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          const Spacer(),
          GetBuilder<ItemDetailController>(builder: (_) {
            return Slider.adaptive(
              //change value after 11 step, and add min and max
              value: controller.position.inSeconds.toDouble(),
              min: 0.0,
              max: controller.duration.inSeconds.toDouble(),
              onChanged: (value) {},
            );
          }),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(
                Icons.fast_rewind,
                color: Colors.white54,
                size: 42.0,
              ),
              const SizedBox(width: 32.0),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                child: GetBuilder<ItemDetailController>(builder: (_) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      onPressed: () {
                        controller.playMusic(item.lecture_file);
                        if (controller.isPlaying) {
                          controller.audioPlayer.pause();
                          // setState(() {
                          //   btnIcon = Icons.play_arrow;
                          //   isPlaying = false;
                          // });
                        } else {
                          controller.audioPlayer.resume();
                          // setState(() {
                          //   btnIcon = Icons.pause;
                          //   isPlaying = true;
                          // });
                        }

                        //10.lets Build the Pause button
                      },
                      iconSize: 42.0,
                      icon: Icon(controller.btnIcon),
                      color: Colors.white,
                    ),
                  );
                }),
              ),
              const SizedBox(width: 32.0),
              const Icon(
                Icons.fast_forward,
                color: Colors.white54,
                size: 42.0,
              ),
            ],
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const <Widget>[
              Icon(
                Icons.bookmark_border,
              ),
              Icon(
                Icons.repeat,
              ),
              Icon(Icons.favorite_border)
            ],
          ),
          const SizedBox(height: 58.0),
        ],
      ),
    );
  }
}
