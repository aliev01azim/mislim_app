import 'dart:async';
import 'dart:io';
import 'package:aidar_zakaz/all_about_audio/mediaitem_converter.dart';
import 'package:aidar_zakaz/controllers/theme_controller.dart';
import 'package:aidar_zakaz/services/service_locator.dart';
import 'package:aidar_zakaz/widgets/download_button.dart';
import 'package:aidar_zakaz/widgets/seekbar.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart' as rx;
import 'package:share_plus/share_plus.dart';

import 'category_screen.dart';

class PlayScreen extends StatefulWidget {
  final Map data;
  final bool fromMiniplayer;
  const PlayScreen({
    Key? key,
    required this.data,
    required this.fromMiniplayer,
  }) : super(key: key);
  @override
  _PlayScreenState createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  bool fromMiniplayer = false;
  String repeatMode =
      Hive.box('settings').get('repeatMode', defaultValue: 'None').toString();
  bool enforceRepeat =
      Hive.box('settings').get('enforceRepeat', defaultValue: false) as bool;
  bool shuffle =
      Hive.box('settings').get('shuffle', defaultValue: false) as bool;
  List<MediaItem> globalQueue = [];
  int globalIndex = 0;
  bool same = false;
  List response = [];
  bool fetched = false;
  bool offline = false;
  final audioHandler = getIt<AudioPlayerHandler>();

  Future<MediaItem> setTags(Map response, Directory tempDir) async {
    final MediaItem tempDict = MediaItem(
        id: response['_id'].toString(),
        album: response['album'].toString(),
        duration: Duration(milliseconds: response['duration']),
        title: response['title'].toString(),
        artist: response['artist'].toString(),
        artUri: Uri.parse(
            'https://clipart-best.com/img/islam/islam-clip-art-31.png'),
        extras: {
          'url': response['_data'],
        });
    return tempDict;
  }

  Future<void> setOffValues(List response) async {
    await getTemporaryDirectory().then((tempDir) async {
      for (int i = 0; i < response.length; i++) {
        globalQueue.add(await setTags(response[i] as Map, tempDir));
      }
    });
  }

  void setValues(List response) {
    for (var element in response) {
      var part = element['duration'].toString();
      if (part.contains(':')) {
        element['duration'] =
            int.parse(part.split(':')[0]) * 60 + int.parse(part.split(':')[1]);
      }
    }
    globalQueue.addAll(
      response.map((song) {
        return MediaItemConverter().mapToMediaItem(song as Map);
      }),
    );
    fetched = true;
  }

  Future<void> updateNplay() async {
    await audioHandler.updateQueue(globalQueue);
    await audioHandler.skipToQueueItem(globalIndex);
    await audioHandler.play();
    if (enforceRepeat) {
      switch (repeatMode) {
        case 'None':
          audioHandler.setRepeatMode(AudioServiceRepeatMode.none);
          break;
        case 'All':
          audioHandler.setRepeatMode(AudioServiceRepeatMode.all);
          break;
        case 'One':
          audioHandler.setRepeatMode(AudioServiceRepeatMode.one);
          break;
        default:
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    BuildContext? scaffoldContext;
    final Map data = widget.data;
    if (response == data['response'] && globalIndex == data['index']) {
      same = true;
    }
    response = data['response'] as List;
    globalIndex = data['index'] as int;
    if (data['offline'] == null) {
      if (audioHandler.mediaItem.value?.extras!['url'].startsWith('http')
          as bool) {
        offline = false;
      } else {
        offline = true;
      }
    } else {
      offline = data['offline'] as bool;
    }
    if (!fetched) {
      if (response.isEmpty || same) {
        fromMiniplayer = true;
      } else {
        fromMiniplayer = false;
        if (!enforceRepeat) {
          repeatMode = 'None';
          Hive.box('settings').put('repeatMode', repeatMode);
        }
        shuffle = false;
        Hive.box('settings').put('shuffle', shuffle);
        if (offline) {
          setOffValues(response);
          updateNplay();
        } else {
          setValues(response);
          updateNplay();
        }
      }
    }
    return Dismissible(
      direction: DismissDirection.down,
      background: Container(color: Colors.transparent),
      key: const Key('playScreen'),
      onDismissed: (direction) {
        Navigator.pop(context);
      },
      child: SafeArea(
        child: StreamBuilder<MediaItem?>(
            stream: audioHandler.mediaItem,
            builder: (context, snapshot) {
              final MediaItem? mediaItem = snapshot.data;
              if (mediaItem == null) return const SizedBox();
              return Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  centerTitle: true,
                  leading: IconButton(
                      icon: const Icon(Icons.expand_more_rounded),
                      color: Theme.of(context).iconTheme.color,
                      tooltip: 'Назад',
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  actions: [
                    if (!offline)
                      IconButton(
                          icon: const Icon(Icons.share_rounded),
                          tooltip: 'Поделиться',
                          color: Theme.of(context).iconTheme.color,
                          onPressed: () {
                            Share.share(mediaItem.extras!['url'].toString());
                          }),
                    if (!offline)
                      PopupMenuButton(
                        icon: Icon(
                          Icons.more_vert_rounded,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        onSelected: (value) {
                          if (value == 0) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailScreen({
                                  'id':
                                      int.parse(mediaItem.extras!['artistId']),
                                  'name': mediaItem.artist,
                                  'isFavorite': mediaItem.extras!['isFavorite']
                                }),
                                settings: const RouteSettings(
                                    arguments: 'deleteRoute'),
                              ),
                            );
                          }
                          if (value == 1) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailScreen({
                                  'id': int.parse(
                                      mediaItem.extras?['categoryId']),
                                  'image':
                                      'http://allahakbar.pythonanywhere.com/media/akyda.jpg',
                                  'title': mediaItem.album,
                                  'isFavorite': mediaItem.extras?['isFavorite'],
                                }),
                                settings: const RouteSettings(
                                    arguments: 'deleteRoute'),
                              ),
                            );
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 0,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.undo,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                                const SizedBox(width: 10.0),
                                const Text('Перейти к лектору'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 1,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.redo,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                                const SizedBox(width: 10.0),
                                const Text('Перейти к теме'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    if (offline) const SizedBox(),
                  ],
                ),
                body: Builder(builder: (BuildContext context) {
                  scaffoldContext = context;
                  return LayoutBuilder(
                      builder: (_, BoxConstraints constraints) {
                    if (constraints.maxWidth > constraints.maxHeight) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          NameNControls(
                            true,
                            mediaItem,
                            offline: offline,
                          ),
                        ],
                      );
                    }
                    return Column(
                      children: [
                        // Artwork
                        Expanded(
                          child: Center(
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.blueGrey[700],
                              ),
                              height: 200,
                              width: 200,
                              child: Icon(
                                Icons.headphones,
                                color: Colors.grey[300],
                                size: 100,
                              ),
                            ),
                          ),
                        ),

                        Expanded(
                          child: NameNControls(
                            false,
                            mediaItem,
                            offline: offline,
                          ),
                        ),
                      ],
                    );
                  });
                }),
              );
            }),
      ),
    );
  }
}

class QueueState {
  static const QueueState empty =
      QueueState([], 0, [], AudioServiceRepeatMode.none);

  final List<MediaItem> queue;
  final int? queueIndex;
  final List<int>? shuffleIndices;
  final AudioServiceRepeatMode repeatMode;

  const QueueState(
      this.queue, this.queueIndex, this.shuffleIndices, this.repeatMode);

  bool get hasPrevious =>
      repeatMode != AudioServiceRepeatMode.none || (queueIndex ?? 0) > 0;
  bool get hasNext =>
      repeatMode != AudioServiceRepeatMode.none ||
      (queueIndex ?? 0) + 1 < queue.length;

  List<int> get indices =>
      shuffleIndices ?? List.generate(queue.length, (i) => i);
}

class ControlButtons extends StatelessWidget {
  final AudioPlayerHandler audioHandler;
  final bool shuffle;
  final bool miniplayer;
  const ControlButtons(this.audioHandler,
      {Key? key, this.shuffle = false, this.miniplayer = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: [
          StreamBuilder<QueueState>(
            stream: audioHandler.queueState,
            builder: (context, snapshot) {
              final queueState = snapshot.data ?? QueueState.empty;
              return IconButton(
                color: currentTheme.currentTheme() == ThemeMode.dark
                    ? Colors.grey[200]
                    : Colors.grey[800],
                icon: const Icon(Icons.skip_previous_rounded),
                iconSize: miniplayer ? 24.0 : 45.0,
                tooltip: 'Предыдущее',
                onPressed:
                    queueState.hasPrevious ? audioHandler.skipToPrevious : null,
              );
            },
          ),
          SizedBox(
            height: miniplayer ? 40.0 : 65.0,
            width: miniplayer ? 40.0 : 65.0,
            child: StreamBuilder<PlaybackState>(
              stream: audioHandler.playbackState,
              builder: (context, snapshot) {
                final playbackState = snapshot.data;
                final processingState = playbackState?.processingState;
                final playing = playbackState?.playing ?? false;
                return Stack(
                  children: [
                    if (processingState == AudioProcessingState.loading ||
                        processingState == AudioProcessingState.buffering)
                      Center(
                        child: SizedBox(
                          height: miniplayer ? 40.0 : 65.0,
                          width: miniplayer ? 40.0 : 65.0,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).colorScheme.secondary),
                          ),
                        ),
                      ),
                    if (miniplayer)
                      Center(
                        child: playing
                            ? IconButton(
                                color: currentTheme.currentTheme() ==
                                        ThemeMode.dark
                                    ? Colors.grey[200]!
                                    : Colors.grey[800]!,
                                tooltip: 'Пауза',
                                onPressed: audioHandler.pause,
                                icon: const Icon(
                                  Icons.pause_rounded,
                                ),
                              )
                            : IconButton(
                                color: currentTheme.currentTheme() ==
                                        ThemeMode.dark
                                    ? Colors.grey[200]!
                                    : Colors.grey[800]!,
                                tooltip: 'Слушать',
                                onPressed: audioHandler.play,
                                icon: const Icon(
                                  Icons.play_arrow_rounded,
                                ),
                              ),
                      )
                    else
                      Center(
                        child: SizedBox(
                          height: 59,
                          width: 59,
                          child: Center(
                            child: playing
                                ? FloatingActionButton(
                                    elevation: 10,
                                    tooltip: 'Пауза',
                                    onPressed: audioHandler.pause,
                                    child: const Icon(
                                      Icons.pause_rounded,
                                      size: 40.0,
                                      color: Colors.white,
                                    ),
                                  )
                                : FloatingActionButton(
                                    elevation: 10,
                                    tooltip: 'Слушать',
                                    onPressed: audioHandler.play,
                                    child: const Icon(
                                      Icons.play_arrow_rounded,
                                      size: 40.0,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          StreamBuilder<QueueState>(
            stream: audioHandler.queueState,
            builder: (context, snapshot) {
              final queueState = snapshot.data ?? QueueState.empty;
              return IconButton(
                color: currentTheme.currentTheme() == ThemeMode.dark
                    ? Colors.grey[200]
                    : Colors.grey[800],
                icon: const Icon(Icons.skip_next_rounded),
                iconSize: miniplayer ? 24.0 : 45.0,
                tooltip: 'Слудующее',
                onPressed: queueState.hasNext ? audioHandler.skipToNext : null,
              );
            },
          ),
        ]);
  }
}

class NameNControls extends StatelessWidget {
  final bool isWidthMore;
  final MediaItem mediaItem;
  final bool offline;
  final audioHandler = getIt<AudioPlayerHandler>();
  NameNControls(this.isWidthMore, this.mediaItem,
      {Key? key, this.offline = false})
      : super(key: key);

  Stream<Duration> get _bufferedPositionStream => audioHandler.playbackState
      .map((state) => state.bufferedPosition)
      .distinct();
  Stream<Duration?> get _durationStream =>
      audioHandler.mediaItem.map((item) => item?.duration).distinct();
  Stream<PositionData> get _positionDataStream =>
      rx.Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          AudioService.position,
          _bufferedPositionStream,
          _durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        /// Title and subtitle
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(35, 5, 35, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 90,
                    child: Center(
                      child: SingleChildScrollView(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          mediaItem.title.trim(),
                          style: const TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 90,
                    child: Center(
                      child: SingleChildScrollView(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          mediaItem.artist ?? 'Неизвестно',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            height: 1.6,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        /// Seekbar starts from here
        StreamBuilder<PositionData>(
          stream: _positionDataStream,
          builder: (context, snapshot) {
            final positionData = snapshot.data ??
                PositionData(Duration.zero, Duration.zero,
                    mediaItem.duration ?? Duration.zero);
            return SeekBar(
              duration: positionData.duration,
              position: positionData.position,
              bufferedPosition: positionData.bufferedPosition,
              onChangeEnd: (newPosition) {
                audioHandler.seek(newPosition);
              },
            );
          },
        ),

        /// Final row starts from here
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  const SizedBox(height: 6.0),
                  StreamBuilder<bool>(
                    stream: audioHandler.playbackState
                        .map((state) =>
                            state.shuffleMode == AudioServiceShuffleMode.all)
                        .distinct(),
                    builder: (context, snapshot) {
                      final shuffleModeEnabled = snapshot.data ?? false;
                      return IconButton(
                        icon: shuffleModeEnabled
                            ? Icon(Icons.shuffle,
                                color: Theme.of(context).colorScheme.secondary)
                            : const Icon(
                                Icons.shuffle,
                              ),
                        tooltip: 'Случайный выбор',
                        onPressed: () async {
                          final enable = !shuffleModeEnabled;
                          await audioHandler.setShuffleMode(
                            enable
                                ? AudioServiceShuffleMode.all
                                : AudioServiceShuffleMode.none,
                          );
                        },
                      );
                    },
                  ),
                  if (!offline)
                    ValueListenableBuilder(
                        valueListenable: Hive.box('favorites').listenable(),
                        builder: (_, Box box, ___) {
                          return IconButton(
                            onPressed: () async {
                              mediaItem.extras!['isFavorite'] =
                                  mediaItem.extras!['isFavorite'] == 'false'
                                      ? 'true'
                                      : 'false';
                              final lectures =
                                  box.get('likedLectures', defaultValue: [])
                                      as List;
                              if (mediaItem.extras!['isFavorite'] == 'true') {
                                lectures.insert(
                                    0,
                                    MediaItemConverter()
                                        .mediaItemtoMap(mediaItem));
                                await box.put('likedLectures', lectures);
                              } else {
                                lectures.removeWhere(
                                    (lec) => lec['id'] == mediaItem.id);
                                await box.put('likedLectures', lectures);
                              }
                            },
                            icon: mediaItem.extras!['isFavorite'] == 'true'
                                ? Icon(
                                    Icons.favorite,
                                    color: currentTheme.currentColor(),
                                  )
                                : const Icon(
                                    Icons.favorite_border,
                                  ),
                            tooltip: 'Добавить в Избранные лекции',
                          );
                        }),
                ],
              ),
              ControlButtons(audioHandler),
              Column(
                children: [
                  const SizedBox(height: 6.0),
                  StreamBuilder<AudioServiceRepeatMode>(
                    stream: audioHandler.playbackState
                        .map((state) => state.repeatMode)
                        .distinct(),
                    builder: (context, snapshot) {
                      final repeatMode =
                          snapshot.data ?? AudioServiceRepeatMode.none;
                      const texts = ['Отменить', 'Все', 'Один'];
                      final icons = [
                        const Icon(
                          Icons.repeat_rounded,
                        ),
                        Icon(Icons.repeat_rounded,
                            color: Theme.of(context).colorScheme.secondary),
                        Icon(Icons.repeat_one_rounded,
                            color: Theme.of(context).colorScheme.secondary),
                      ];
                      const cycleModes = [
                        AudioServiceRepeatMode.none,
                        AudioServiceRepeatMode.all,
                        AudioServiceRepeatMode.one,
                      ];
                      final index = cycleModes.indexOf(repeatMode);
                      return IconButton(
                        icon: icons[index],
                        tooltip: ' ${texts[(index + 1) % texts.length]}',
                        onPressed: () async {
                          await Hive.box('settings').put(
                              'repeatMode', texts[(index + 1) % texts.length]);
                          audioHandler.setRepeatMode(cycleModes[
                              (cycleModes.indexOf(repeatMode) + 1) %
                                  cycleModes.length]);
                        },
                      );
                    },
                  ),
                  if (!offline)
                    DownloadButton(
                      data: {
                        'id': mediaItem.id.toString(),
                        'artist': mediaItem.artist,
                        'album': mediaItem.album,
                        'image': mediaItem.artUri.toString(),
                        'duration': mediaItem.duration?.inSeconds.toString(),
                        'title': mediaItem.title.toString(),
                        'url': mediaItem.extras!['url'].toString(),
                      },
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

//
abstract class AudioPlayerHandler implements AudioHandler {
  Stream<QueueState> get queueState;
  Future<void> moveQueueItem(int currentIndex, int newIndex);
  rx.ValueStream<double> get volume;
  Future<void> setVolume(double volume);
  rx.ValueStream<double> get speed;
}

//

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}
