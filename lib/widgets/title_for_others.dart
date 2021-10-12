import 'package:aidar_zakaz/controllers/theme_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TitleeForOthers extends StatelessWidget {
  const TitleeForOthers(this.title, this.type, {Key? key}) : super(key: key);
  final String title;
  final String type;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box('favorites').listenable(),
        builder: (_, Box box, Widget? widget) {
          return (box.get(type == 'temi' ? 'likedCategories' : 'likedShahes',
                          defaultValue: []) as List? ??
                      [])
                  .isNotEmpty
              ? Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w700,
                            color: currentTheme.currentColor(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                )
              : const SizedBox();
        });
  }
}
