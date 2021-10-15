import 'package:aidar_zakaz/widgets/miniplayer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../audio_screen.dart';

class RecentlyPlayed extends StatefulWidget {
  const RecentlyPlayed({Key? key}) : super(key: key);
  @override
  _RecentlyPlayedState createState() => _RecentlyPlayedState();
}

class _RecentlyPlayedState extends State<RecentlyPlayed> {
  List _songs = [];
  bool added = false;

  Future<void> getSongs() async {
    await Hive.openBox('recentlyPlayed');
    _songs =
        Hive.box('recentlyPlayed').get('recentSongs', defaultValue: []) as List;
    added = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!added) {
      getSongs();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Last Session'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Hive.box('recentlyPlayed').put('recentSongs', []);
              setState(() {
                _songs = [];
              });
            },
            tooltip: 'Очистить',
            icon: const Icon(Icons.remove_circle_outline_outlined),
          ),
        ],
      ),
      body:
          //  _songs.isEmpty
          //     ? EmptyScreen().emptyScreen(context, 3, 'Nothing to ', 15,
          //         'Show Here', 50.0, 'Go and Play Something', 23.0)
          //     :
          ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              shrinkWrap: true,
              itemCount: _songs.length,
              itemExtent: 70.0,
              itemBuilder: (context, index) {
                return _songs.isEmpty
                    ? const SizedBox()
                    : ListTile(
                        leading: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: CachedNetworkImage(
                            errorWidget: (context, _, __) => const Image(
                              image:
                                  AssetImage('assets/images/placeholder.jpg'),
                            ),
                            imageUrl: _songs[index]['image']
                                .toString()
                                .replaceAll('http:', 'https:'),
                            placeholder: (context, url) => const Image(
                              image:
                                  AssetImage('assets/images/placeholder.jpg'),
                            ),
                          ),
                        ),
                        title: Text(
                          '${_songs[index]["title"]}',
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          '${_songs[index]["artist"]}',
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              opaque: false,
                              pageBuilder: (_, __, ___) => PlayScreen(
                                data: {
                                  'response': _songs,
                                  'index': index,
                                  'offline': false,
                                },
                                fromMiniplayer: false,
                              ),
                            ),
                          );
                        },
                      );
              }),
      bottomSheet: const SafeArea(child: MiniPlayer()),
    );
  }
}
