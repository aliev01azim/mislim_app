import 'package:flutter/material.dart';

class ItemDetailScreen extends StatelessWidget {
  const ItemDetailScreen(this.title, this.name, {Key? key}) : super(key: key);
  final String title;
  final String name;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.fade,
        ),
        elevation: 0,
        backgroundColor: const Color.fromRGBO(29, 185, 84, 0.5),
      ),
    );
  }
}
