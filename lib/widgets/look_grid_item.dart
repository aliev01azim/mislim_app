import 'package:aidar_zakaz/bindings/category_detail_screen_binding.dart';
import 'package:aidar_zakaz/models/category_model.dart';
import 'package:aidar_zakaz/screens/category_detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:get/get.dart';

class LookGridItem extends StatelessWidget {
  const LookGridItem(this.category, {Key? key}) : super(key: key);
  final CategoryModel category;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() => CategoryDetailScreen(category),
          binding: CategoryDetailScreenBinding()),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          gradient: LinearGradient(
              colors: [
                Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                    .withOpacity(0.1),
                Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                    .withOpacity(1)
              ],
              tileMode: TileMode.clamp,
              begin: const Alignment(0.4, 0),
              transform: const GradientRotation(-90)),
        ),
        child: Center(
            child: Text(
          category.title,
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Alisson'),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        )),
      ),
    );
  }
}
