import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class LookGridItem extends StatelessWidget {
  const LookGridItem(this.title, {Key? key}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigator.of(context)
        // .pushNamed(KuhnyaCategoryScreen.routeName, arguments: title);
      },
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
          title,
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
