import 'package:flutter/material.dart';

import 'listview_item.dart';

class ListViewWidget extends StatelessWidget {
  const ListViewWidget(this.items, {Key? key}) : super(key: key);
  final List items;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 196,
          width: double.infinity,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 10),
            controller: ScrollController(),
            itemCount: items.length,
            itemBuilder: (_, index) => ListviewItem(items[index], false),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
