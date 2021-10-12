import 'package:aidar_zakaz/controllers/theme_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Titlee extends StatelessWidget {
  const Titlee(this.title, {Key? key}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        Row(
          children: [
            const SizedBox(
              width: 20,
            ),
            ValueListenableBuilder(
                valueListenable: Hive.box('settings').listenable(),
                builder: (_, Box box, __) {
                  return Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                      color: currentTheme.currentColor(),
                    ),
                  );
                }),
          ],
        ),
        const SizedBox(
          height: 0,
        ),
      ],
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
    );
  }
}
