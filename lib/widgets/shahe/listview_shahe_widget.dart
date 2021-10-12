import 'package:flutter/material.dart';

import 'listview__shahe_item.dart';

class ListViewShaheWidget extends StatelessWidget {
  const ListViewShaheWidget(this.items, {Key? key}) : super(key: key);
  final List items;
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: 126,
        width: double.infinity,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(left: 10),
          controller: ScrollController(),
          itemCount: items.length,
          itemBuilder: (_, index) => ListviewShaheItem(items[index], false),
        ),
      ),
      const SizedBox(
        height: 10,
      ),
    ]);
  }
}
