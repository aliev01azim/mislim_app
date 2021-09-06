import 'package:aidar_zakaz/bindings/item_detail_screen_binding.dart';
import 'package:aidar_zakaz/controllers/home_screen_controller.dart';
import 'package:aidar_zakaz/models/category_model.dart';
import 'package:aidar_zakaz/screens/category_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListviewItem extends StatelessWidget {
  const ListviewItem(this.item, this.isIcon, {Key? key}) : super(key: key);
  final CategoryModel item;
  final bool isIcon;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => CategoryDetailScreen(item),
            binding: ItemDetailScreenBinding());
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        width: 190,
        child: Stack(
          children: [
            Container(
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    item.url,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 186,
              child: Text(
                item.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isIcon)
              Positioned(
                  right: 0,
                  top: 0,
                  child: IconButton(
                    onPressed: () => Get.find<HomeScreenController>()
                        .addFavoriteCategory(item),
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
