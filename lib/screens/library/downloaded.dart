import 'dart:io';

import 'package:aidar_zakaz/services/service_locator.dart';
import 'package:aidar_zakaz/widgets/miniplayer.dart';
import 'package:audio_service/audio_service.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../audio_screen.dart';

class DownloadedSongs extends StatefulWidget {
  const DownloadedSongs({Key? key}) : super(key: key);
  @override
  _DownloadedSongsState createState() => _DownloadedSongsState();
}

class _DownloadedSongsState extends State<DownloadedSongs>
    with AutomaticKeepAliveClientMixin {
  List<SongModel> _cachedSongs = [];

  final List<Map> _cachedSongsMap = [];

  bool added = false;

  int minDuration =
      Hive.box('settings').get('minDuration', defaultValue: 10) as int;

  OnAudioQuery audioQuery = OnAudioQuery();

  Future<void> requestPermission() async {
    while (!await audioQuery.permissionsStatus()) {
      await audioQuery.permissionsRequest();
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    getCached();
    super.initState();
  }

  Future<List<SongModel>> getSongs(
      {SongSortType? sortType, OrderType? orderType}) async {
    return audioQuery.querySongs(
      sortType: sortType ?? SongSortType.DATE_ADDED,
      orderType: orderType ?? OrderType.DESC_OR_GREATER,
      uriType: UriType.EXTERNAL,
    );
  }

  Future<void> getCached() async {
    var downloadPath = await ExtStorage.getExternalStoragePublicDirectory(
            ExtStorage.DIRECTORY_MUSIC) ??
        '/storage/emulated/0/Music';
    var path = Hive.box('settings')
        .get('downloadPath', defaultValue: downloadPath) as String;
    await requestPermission();
    final List<SongModel> temp = await getSongs();
    _cachedSongs = temp.where((i) {
      return ((i.duration ?? 60000) > 1000 * minDuration &&
          i.data.contains(path));
    }).toList();
    added = true;
    setState(() {});
    getArtwork();
  }

  void getArtwork() {
    for (final SongModel song in _cachedSongs) {
      _cachedSongsMap.add(song.getMap);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                title: const Text('My Music'),
                centerTitle: true,
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.transparent
                    : Theme.of(context).colorScheme.secondary,
                elevation: 0,
              ),
              body: !added
                  ? SizedBox(
                      child: Center(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.width / 7,
                          width: MediaQuery.of(context).size.width / 7,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).colorScheme.secondary),
                            strokeWidth: 5,
                          ),
                        ),
                      ),
                    )
                  : SongsTab(
                      cachedSongs: _cachedSongs,
                      cachedSongsMap: _cachedSongsMap,
                    ),
            ),
          ),
          const MiniPlayer(),
        ],
      ),
    );
  }
}

class SongsTab extends StatefulWidget {
  final List<SongModel> cachedSongs;
  final List<Map> cachedSongsMap;
  const SongsTab(
      {Key? key, required this.cachedSongs, required this.cachedSongsMap})
      : super(key: key);

  @override
  State<SongsTab> createState() => _SongsTabState();
}

class _SongsTabState extends State<SongsTab> {
  Future<void> deleteFile(String path) async {
    try {
      var file = File(path);
      if (await file.exists()) {
        file.deleteSync(recursive: true);
      }
    } catch (e) {
      rethrow;
    }
  }

  final audioHandler = getIt<AudioPlayerHandler>();

  @override
  Widget build(BuildContext context) {
    return widget.cachedSongs.isEmpty
        ? const Text('no audio downloaded yet')
        : StreamBuilder<MediaItem?>(
            stream: audioHandler.mediaItem,
            builder: (context, snapshot) {
              final MediaItem? mediaItem = snapshot.data;
              if (mediaItem == null) return const SizedBox();
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                shrinkWrap: true,
                itemExtent: 70.0,
                itemCount: widget.cachedSongs.length,
                itemBuilder: (context, index) {
                  return ListTileTheme(
                    selectedColor: Theme.of(context).colorScheme.secondary,
                    child: ListTile(
                      selected:
                          widget.cachedSongs[index].title == mediaItem.title,
                      leading: QueryArtworkWidget(
                        id: widget.cachedSongs[index].id,
                        type: ArtworkType.AUDIO,
                        artworkBorder: BorderRadius.circular(7.0),
                        nullArtworkWidget: ClipRRect(
                          borderRadius: BorderRadius.circular(7.0),
                          child: const Image(
                            fit: BoxFit.cover,
                            height: 50.0,
                            width: 50.0,
                            image: AssetImage('assets/images/placeholder.jpg'),
                          ),
                        ),
                      ),
                      title: Text(
                        widget.cachedSongs[index].title.trim() != ''
                            ? widget.cachedSongs[index].title
                            : widget.cachedSongs[index].displayNameWOExt,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        widget.cachedSongs[index].artist
                                ?.replaceAll('<unknown>', 'Unknown') ??
                            'Unknown',
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            opaque: false, // set to false
                            pageBuilder: (_, __, ___) => PlayScreen(
                              data: {
                                'response': widget.cachedSongsMap,
                                'index': index,
                                'offline': true
                              },
                              fromMiniplayer: false,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            });
  }
}
