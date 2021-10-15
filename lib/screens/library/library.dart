import 'package:aidar_zakaz/controllers/theme_controller.dart';
import 'package:aidar_zakaz/screens/library/favorites.dart';
import 'package:aidar_zakaz/screens/library/recent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'downloaded.dart';
import 'now_playing.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box('settings').listenable(),
        builder: (_, Box show, Widget? widget) {
          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 14),
                child: Text(
                  'Моя медиатека',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 26,
                      color: currentTheme.currentColor(),
                      fontWeight: FontWeight.w500),
                ),
              ),
              LibraryTile(
                title: 'Избранные',
                icon: Icons.favorite,
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const Favorites(),
                    ),
                  );
                },
              ),
              LibraryTile(
                title: 'Прослушанные лекции',
                icon: Icons.history_rounded,
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const RecentlyPlayed(),
                    ),
                  );
                },
              ),
              LibraryTile(
                title: 'Загрузки',
                icon: Icons.download,
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const DownloadedSongs(),
                    ),
                  );
                },
              ),
              LibraryTile(
                title: 'Сейчас играет',
                icon: Icons.play_circle_filled_rounded,
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => NowPlaying(),
                    ),
                  );
                },
              ),
            ],
          );
        });
  }
}

class LibraryTile extends StatelessWidget {
  const LibraryTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
      ),
      leading: Icon(
        icon,
        color: currentTheme.currentColor(),
      ),
      onTap: onTap,
    );
  }
}
