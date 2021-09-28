import 'dart:async';
import 'dart:io';

import 'package:aidar_zakaz/all_about_audio/mediaitem_converter.dart';
import 'package:aidar_zakaz/services/service_locator.dart';
import 'package:aidar_zakaz/utils/colors.dart';
import 'package:aidar_zakaz/utils/theme.dart';
import 'package:aidar_zakaz/widgets/download_button.dart';
import 'package:aidar_zakaz/widgets/seekbar.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:share_plus/share_plus.dart';

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
  String defaultCover = '';
  final audioHandler = getIt<AudioPlayerHandler>();

  Future<void> main() async {
    await Hive.openBox('Favorite Songs');
  }

  @override
  void initState() {
    super.initState();
    main();
  }

  Future<MediaItem> setTags(Map response, Directory tempDir) async {
    String playTitle = response['title'].toString();

    String playArtist = response['artist'].toString();

    final String playAlbum = response['album'].toString();
    final int playDuration =
        int.parse(response['duration'].toString().split(':')[0]) * 60 +
            int.parse(response['duration'].toString().split(':')[1]);

    final String filePath = await getImageFileFromAssets();
    final MediaItem tempDict = MediaItem(
        id: response['id'].toString(),
        album: playAlbum,
        duration: Duration(seconds: playDuration),
        title: playTitle,
        artist: playArtist,
        artUri: Uri.file(filePath),
        extras: {
          'url': response['url'],
        });
    return tempDict;
  }

  Future<String> getImageFileFromAssets() async {
    if (defaultCover != '') return defaultCover;
    final file =
        File('${(await getTemporaryDirectory()).path}/images/placeholder.jpg');
    defaultCover = file.path;
    if (await file.exists()) return file.path;
    final byteData = await rootBundle.load('assets/images/placeholder.jpg');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return file.path;
  }

  void setOffValues(List response) {
    getTemporaryDirectory().then((tempDir) async {
      final file = File(
          '${(await getTemporaryDirectory()).path}/images/placeholder.jpg');
      if (!await file.exists()) {
        final byteData = await rootBundle.load('assets/images/placeholder.jpg');
        await file.writeAsBytes(byteData.buffer
            .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
      }
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
                backgroundColor: Colorss.dark,
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  centerTitle: true,
                  leading: IconButton(
                      icon: const Icon(Icons.expand_more_rounded),
                      color: Theme.of(context).iconTheme.color,
                      tooltip: 'Back',
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  actions: [
                    if (!offline)
                      IconButton(
                          icon: const Icon(Icons.share_rounded),
                          tooltip: 'Share',
                          onPressed: () {
                            Share.share(
                                mediaItem.extras!['perma_url'].toString());
                          }),
                    PopupMenuButton(
                      icon: Icon(
                        Icons.more_vert_rounded,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.0))),
                      onSelected: (int? value) {
                        if (value == 0) {}
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                            value: 0,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.playlist_add_rounded,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                                const SizedBox(width: 10.0),
                                const Text('Add to playlist'),
                              ],
                            )),
                      ],
                    )
                  ],
                ),
                body: Builder(builder: (BuildContext context) {
                  scaffoldContext = context;
                  return LayoutBuilder(builder:
                      (BuildContext context, BoxConstraints constraints) {
                    if (constraints.maxWidth > constraints.maxHeight) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // title and controls
                          SizedBox(
                            width: constraints.maxWidth / 2,
                            child: NameNControls(
                              mediaItem,
                              offline: offline,
                            ),
                          ),
                        ],
                      );
                    }
                    return Column(
                      children: [
                        // Artwork

                        // title and controls
                        Expanded(
                          child: NameNControls(
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

class MediaState {
  final MediaItem? mediaItem;
  final Duration position;

  MediaState(this.mediaItem, this.position);
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
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
      {this.shuffle = false, this.miniplayer = false});

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
                tooltip: 'Skip Previous',
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
                                  Theme.of(context).accentColor),
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
                                  tooltip: 'Pause',
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
                                  tooltip: 'Play',
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
                                        tooltip: 'Pause',
                                        onPressed: audioHandler.pause,
                                        child: const Icon(
                                          Icons.pause_rounded,
                                          size: 40.0,
                                          color: Colors.white,
                                        ),
                                      )
                                    : FloatingActionButton(
                                        elevation: 10,
                                        tooltip: 'Play',
                                        onPressed: audioHandler.play,
                                        child: const Icon(
                                          Icons.play_arrow_rounded,
                                          size: 40.0,
                                          color: Colors.white,
                                        ),
                                      ),
                              )),
                        ),
                    ],
                  );
                }),
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
                tooltip: 'Skip Next',
                onPressed: queueState.hasNext ? audioHandler.skipToNext : null,
              );
            },
          ),
        ]);
  }
}

abstract class AudioPlayerHandler implements AudioHandler {
  Stream<QueueState> get queueState;
  Future<void> moveQueueItem(int currentIndex, int newIndex);
  ValueStream<double> get volume;
  Future<void> setVolume(double volume);
  ValueStream<double> get speed;
}

class NameNControls extends StatelessWidget {
  final MediaItem mediaItem;
  final bool offline;
  final audioHandler = getIt<AudioPlayerHandler>();
  NameNControls(this.mediaItem, {this.offline = false});

  Stream<Duration> get _bufferedPositionStream => audioHandler.playbackState
      .map((state) => state.bufferedPosition)
      .distinct();
  Stream<Duration?> get _durationStream =>
      audioHandler.mediaItem.map((item) => item?.duration).distinct();
  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
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
                  /// Title container
                  Text(
                    mediaItem.title.trim(),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),

                  /// Subtitle container
                  Text(
                    mediaItem.artist ?? 'Unknown',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
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
                                color: Theme.of(context).accentColor)
                            : const Icon(
                                Icons.shuffle,
                              ),
                        tooltip: 'Shuffle',
                        onPressed: () async {
                          final enable = !shuffleModeEnabled;
                          await audioHandler.setShuffleMode(enable
                              ? AudioServiceShuffleMode.all
                              : AudioServiceShuffleMode.none);
                        },
                      );
                    },
                  ),
                  // if (!offline) LikeButton(mediaItem: mediaItem, size: 25.0)
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
                      const texts = ['None', 'All', 'One'];
                      final icons = [
                        const Icon(
                          Icons.repeat_rounded,
                        ),
                        Icon(Icons.repeat_rounded,
                            color: Theme.of(context).accentColor),
                        Icon(Icons.repeat_one_rounded,
                            color: Theme.of(context).accentColor),
                      ];
                      const cycleModes = [
                        AudioServiceRepeatMode.none,
                        AudioServiceRepeatMode.all,
                        AudioServiceRepeatMode.one,
                      ];
                      final index = cycleModes.indexOf(repeatMode);
                      return IconButton(
                        icon: icons[index],
                        tooltip: 'Repeat ${texts[(index + 1) % texts.length]}',
                        onPressed: () {
                          Hive.box('settings').put(
                              'repeatMode', texts[(index + 1) % texts.length]);
                          audioHandler.setRepeatMode(cycleModes[
                              (cycleModes.indexOf(repeatMode) + 1) %
                                  cycleModes.length]);
                        },
                      );
                    },
                  ),
                  if (!offline)
                    DownloadButton(data: {
                      'id': mediaItem.id.toString(),
                      'artist': mediaItem.artist,
                      'album': mediaItem.album,
                      'image': mediaItem.artUri.toString(),
                      'duration': mediaItem.duration?.inSeconds.toString(),
                      'title': mediaItem.title.toString(),
                      'url': mediaItem.extras!['url'].toString(),
                    })
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



// 