import 'package:aidar_zakaz/models/listview_item_sheih_model.dart';
import 'package:aidar_zakaz/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ListviewShaheItem extends StatelessWidget {
  const ListviewShaheItem(this.item, {Key? key}) : super(key: key);
  final ListviewItemShaheModel item;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        width: 100,
        child: Column(
          children: [
            Expanded(
              child: SvgPicture.asset(Images.man),
            ),
            Text(
              item.name,
              style: const TextStyle(
                  height: 1.5, fontStyle: FontStyle.italic, fontSize: 11),
              maxLines: 1,
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
