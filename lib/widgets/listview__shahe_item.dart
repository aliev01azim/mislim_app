import 'package:aidar_zakaz/bindings/item_detail_screen_binding.dart';
import 'package:aidar_zakaz/controllers/home_screen_controller.dart';
import 'package:aidar_zakaz/models/shahe_model.dart';
import 'package:aidar_zakaz/screens/category_shahe_detail_screen.dart';
import 'package:aidar_zakaz/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ListviewShaheItem extends StatelessWidget {
  const ListviewShaheItem(this.item, this.isIcon, {Key? key}) : super(key: key);
  final ShaheModel item;
  final bool isIcon;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() => CategoryShaheDetailScreen(item),
          binding: ItemDetailScreenBinding()),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        width: 100,
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
                item.name,
                style: const TextStyle(fontSize: 12, height: 1.3),
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isIcon)
              Positioned(
                  right: -5,
                  top: -15,
                  child: IconButton(
                    onPressed: () => Get.find<HomeScreenController>()
                        .addFavoriteShahes(item),
                    icon: isIcon
                        ? const Icon(
                            Icons.favorite,
                            size: 25,
                          )
                        : const Icon(
                            Icons.favorite_border,
                            size: 25,
                          ),
                  ))
          ],
        ),
      ),
    );
  }
}
