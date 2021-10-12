import 'package:aidar_zakaz/controllers/home_screen_controller.dart';
import 'package:aidar_zakaz/controllers/theme_controller.dart';
import 'package:aidar_zakaz/screens/category_screen.dart';
import 'package:aidar_zakaz/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ListviewShaheItem extends GetView<HomeScreenController> {
  const ListviewShaheItem(this.item, this.isIcon, {Key? key}) : super(key: key);
  final Map<dynamic, dynamic> item;
  final bool isIcon;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DetailScreen(item),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        width: 90,
        child: Stack(
          children: [
            SizedBox(
              height: 80,
              child: SvgPicture.asset(Images.man),
            ),
            Positioned(
              top: 85,
              left: 0,
              right: 0,
              child: Text(
                item['name'] ?? "Неизвестный",
                style: const TextStyle(fontSize: 12, height: 1.3),
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isIcon)
              Positioned(
                right: -5,
                top: -10,
                child: ValueListenableBuilder(
                    valueListenable: Hive.box('settings').listenable(),
                    builder: (_, __, ___) {
                      return StreamBuilder<Object>(
                          stream: null,
                          builder: (context, snapshot) {
                            return IconButton(
                              onPressed: () async {
                                item['isFavorite'] == 'false'
                                    ? 'true'
                                    : 'false';
                                final shahes = await Hive.box('favorites')
                                        .get('likedShahes', defaultValue: [])
                                    as List;
                                if (item['isFavorite'] == 'true') {
                                  shahes.insert(0, item);
                                  await Hive.box('favorites')
                                      .put('likedShahes', shahes);
                                } else {
                                  shahes.remove(item);
                                  await Hive.box('favorites')
                                      .put('likedShahes', shahes);
                                }
                              },
                              icon: Icon(
                                Icons.favorite,
                                color: currentTheme.currentColor(),
                                size: 25,
                              ),
                            );
                          });
                    }),
              ),
          ],
        ),
      ),
    );
  }
}
