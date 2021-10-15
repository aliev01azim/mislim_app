import 'package:aidar_zakaz/controllers/theme_controller.dart';
import 'package:aidar_zakaz/screens/audio_screen.dart';
import 'package:aidar_zakaz/services/service_locator.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({Key? key}) : super(key: key);
  @override
  _MiniPlayerState createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  final audioHandler = getIt<AudioPlayerHandler>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlaybackState>(
        stream: audioHandler.playbackState,
        builder: (context, snapshot) {
          final playbackState = snapshot.data;
          final processingState = playbackState?.processingState;
          if (processingState == AudioProcessingState.idle) {
            return const SizedBox();
          }
          return StreamBuilder<MediaItem?>(
              stream: audioHandler.mediaItem,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.active) {
                  return const SizedBox();
                }
                final mediaItem = snapshot.data;
                if (mediaItem == null) return const SizedBox();
                return Dismissible(
                  key: Key(mediaItem.id),
                  onDismissed: (_) {
                    audioHandler.stop();
                  },
                  child: ValueListenableBuilder(
                      valueListenable: Hive.box('settings').listenable(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 0),
                            onTap: () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  opaque: false,
                                  pageBuilder: (_, __, ___) => const PlayScreen(
                                    data: {
                                      'response': [],
                                      'index': 1,
                                      'offline': null,
                                    },
                                    fromMiniplayer: true,
                                  ),
                                ),
                              );
                            },
                            title: Text(
                              mediaItem.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              mediaItem.artist ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            leading: Card(
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7.0)),
                              clipBehavior: Clip.antiAlias,
                              child: const SizedBox(
                                height: 50.0,
                                width: 50.0,
                                child: Image(
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                      'assets/images/placeholder.jpg'),
                                ),
                              ),
                            ),
                            trailing: ControlButtons(
                              audioHandler,
                              miniplayer: true,
                            ),
                          ),
                          StreamBuilder<Duration>(
                              stream: AudioService.position,
                              builder: (context, snapshot) {
                                final position = snapshot.data;
                                return position == null
                                    ? const SizedBox()
                                    : (position.inSeconds.toDouble() < 0.0 ||
                                            (position.inSeconds.toDouble() >
                                                mediaItem.duration!.inSeconds
                                                    .toDouble()))
                                        ? const SizedBox()
                                        : SliderTheme(
                                            data: SliderTheme.of(context)
                                                .copyWith(
                                              trackHeight: 0.5,
                                              thumbColor: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              thumbShape:
                                                  const RoundSliderThumbShape(
                                                      enabledThumbRadius: 1.0),
                                              overlayColor: Colors.transparent,
                                              overlayShape:
                                                  const RoundSliderOverlayShape(
                                                      overlayRadius: 2.0),
                                            ),
                                            child: Slider(
                                              inactiveColor: Colors.transparent,
                                              activeColor:
                                                  currentTheme.currentTheme() ==
                                                          ThemeMode.dark
                                                      ? Colors.white
                                                      : Colors.grey[700],
                                              value:
                                                  position.inSeconds.toDouble(),
                                              max: mediaItem.duration!.inSeconds
                                                  .toDouble(),
                                              onChanged: (newPosition) {
                                                audioHandler.seek(Duration(
                                                    seconds:
                                                        newPosition.round()));
                                              },
                                            ),
                                          );
                              }),
                        ],
                      ),
                      builder: (_, Box box, Widget? widget) {
                        return Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                boxShadow: [
                                  BoxShadow(
                                      color: !(box.get('darkMode',
                                                      defaultValue: true)
                                                  as bool? ??
                                              true)
                                          ? Colors.grey[400]!
                                          : Colors.grey[800]!,
                                      blurRadius: 2)
                                ],
                                gradient: LinearGradient(colors: [
                                  currentTheme.currentColor().withAlpha(100),
                                  (box.get('darkMode', defaultValue: true)
                                              as bool? ??
                                          true)
                                      ? currentTheme.getCanvasColor()
                                      : Colors.white,
                                  (box.get('darkMode', defaultValue: true)
                                              as bool? ??
                                          true)
                                      ? currentTheme.getCanvasColor()
                                      : Colors.white,
                                ])),
                            margin: const EdgeInsets.symmetric(horizontal: 7),
                            height: 77,
                            child: widget);
                      }),
                );
              });
        });
  }
}
