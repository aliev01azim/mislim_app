import 'package:aidar_zakaz/controllers/theme_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TitleeForLectures extends StatelessWidget {
  const TitleeForLectures(this.title, {Key? key}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box('settings').listenable(),
        builder: (_, Box show, Widget? widget) {
          var items = Hive.box('recentlyPlayed')
              .get('recentSongs', defaultValue: []) as List;
          if (items.isNotEmpty &&
              items.any((element) => element['id'] == '1')) {
            items.removeWhere((element) => element['id'] == '1');
          }
          return (show.get('showRecent', defaultValue: true) as bool? ?? true)
              ? Column(
                  children: [
                    if (items.isNotEmpty)
                      const SizedBox(
                        height: 15,
                      ),
                    if (items.isNotEmpty)
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
                    if (items.isNotEmpty)
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
