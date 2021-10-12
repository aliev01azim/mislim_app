import 'package:aidar_zakaz/screens/category_screen.dart';
import 'package:aidar_zakaz/utils/card_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class LookGridItem extends StatelessWidget {
  const LookGridItem(this.category, this.index, {Key? key}) : super(key: key);
  final Map category;
  final int index;
  @override
  Widget build(BuildContext context) {
    var gradientColor = GradientTemplate.gradientTemplate[index].colors;
    return InkWell(
      onTap: () => Navigator.of(context).push(
        PageRouteBuilder(
          opaque: false,
          pageBuilder: (_, __, ___) => DetailScreen(category),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColor,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          boxShadow: [
            BoxShadow(
              color: gradientColor.last.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: Center(
            child: Text(
          category['title'],
          style: const TextStyle(
              fontSize: 18,
              fontFamily: 'IBM Plex Sans',
              color: Colors.white,
              fontWeight: FontWeight.bold),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        )),
      ),
    );
  }
}
