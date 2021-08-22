import 'package:aidar_zakaz/bindings/item_detail_screen_binding.dart';
import 'package:aidar_zakaz/models/listview_item_model.dart';
import 'package:aidar_zakaz/models/listview_popular_item_model.dart';
import 'package:aidar_zakaz/screens/category_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PopularListViewWidget extends StatelessWidget {
  const PopularListViewWidget(this.items, {Key? key}) : super(key: key);
  final List<PopularListviewItemModel> items;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 181,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 10),
        controller: ScrollController(),
        itemCount: items.length,
        itemBuilder: (_, index) => PopularListviewItem(items[index]),
      ),
    );
  }
}

class PopularListviewItem extends StatelessWidget {
  const PopularListviewItem(this.item, {Key? key}) : super(key: key);
  final PopularListviewItemModel item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() => CategoryDetailScreen(item.name, item.url),
          binding: ItemDetailScreenBinding()),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        width: 160,
        child: Column(
          children: [
            Container(
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage(
                    item.url,
                  ),
                ),
              ),
            ),
            Text(
              item.name,
              style: const TextStyle(
                height: 1.5,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
        ),
      ),
    );
  }
}
