import 'dart:io';

import 'package:aidar_zakaz/screens/audio_screen.dart';
import 'package:aidar_zakaz/services/service_locator.dart';
import 'package:aidar_zakaz/utils/theme.dart';
import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MiniPlayer extends StatefulWidget {
  @override
  _MiniPlayerState createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  final audioHandler = getIt<AudioPlayerHandler>();
  bool isDarkMode = currentTheme.currentTheme() == ThemeMode.dark;
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
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          boxShadow: [
                            BoxShadow(
                                color: !isDarkMode
                                    ? Colors.grey[400]!
                                    : Colors.grey[900]!,
                                blurRadius: 2)
                          ],
                          gradient: LinearGradient(colors: [
                            currentTheme.currentColor().withAlpha(100),
                            isDarkMode
                                ? const Color.fromRGBO(6, 18, 40, 1)
                                : Colors.white,
                            isDarkMode
                                ? const Color.fromRGBO(6, 18, 40, 1)
                                : Colors.white,
                          ])),
                      margin: const EdgeInsets.symmetric(horizontal: 7),
                      height: 77,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
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
                            leading: Hero(
                              tag: 'currentArtwork',
                              child: Card(
                                elevation: 8,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7.0)),
                                clipBehavior: Clip.antiAlias,
                                child: (mediaItem.artUri
                                        .toString()
                                        .startsWith('file:'))
                                    ? SizedBox(
                                        height: 50.0,
                                        width: 50.0,
                                        child: Image(
                                            fit: BoxFit.cover,
                                            image: FileImage(File(mediaItem
                                                .artUri!
                                                .toFilePath()))),
                                      )
                                    : SizedBox(
                                        height: 50.0,
                                        width: 50.0,
                                        child: CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            errorWidget:
                                                (BuildContext context, _, __) =>
                                                    const Image(
                                                      image: AssetImage(
                                                          'assets/images/placeholder.jpg'),
                                                    ),
                                            placeholder:
                                                (BuildContext context, _) =>
                                                    const Image(
                                                      image: AssetImage(
                                                          'assets/images/placeholder.jpg'),
                                                    ),
                                            imageUrl:
                                                'https://png.pngtree.com/element_our/20190603/ourlarge/pngtree-cartoon-black-headphones-illustration-image_1453847.jpg'),
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
                                              thumbColor:
                                                  Theme.of(context).accentColor,
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
                                              activeColor: isDarkMode
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
                          const SizedBox(
                            height: 1,
                          ),
                        ],
                      )),
                );
              });
        });
  }
}
