import 'package:aidar_zakaz/services/service_locator.dart';
import 'package:aidar_zakaz/widgets/miniplayer.dart';
import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../audio_screen.dart';

class NowPlaying extends StatelessWidget {
  NowPlaying({Key? key}) : super(key: key);
  final audioHandler = getIt<AudioPlayerHandler>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<PlaybackState>(
        stream: audioHandler.playbackState,
        builder: (context, snapshot) {
          final playbackState = snapshot.data;
          final processingState = playbackState?.processingState;
          return Scaffold(
            backgroundColor: Colors.transparent,
            appBar: processingState != AudioProcessingState.idle
                ? null
                : AppBar(
                    title: const Text('Сейчас прослушивается'),
                    centerTitle: true,
                    backgroundColor:
                        Theme.of(context).brightness == Brightness.dark
                            ? Colors.transparent
                            : Theme.of(context).accentColor,
                    elevation: 0,
                  ),
            body: processingState == AudioProcessingState.idle
                // ? EmptyScreen().emptyScreen(context, 3, 'Nothing is ',
                //     18.0, 'PLAYING', 60, 'Go and Play Something', 23.0)
                ? const Center(
                    child: Text('no data'),
                  )
                : StreamBuilder<MediaItem?>(
                    stream: audioHandler.mediaItem,
                    builder: (context, snapshot) {
                      final mediaItem = snapshot.data;
                      return mediaItem == null
                          ? const SizedBox()
                          : CustomScrollView(
                              physics: const BouncingScrollPhysics(),
                              slivers: [
                                SliverAppBar(
                                  elevation: 0,
                                  stretch: true,
                                  pinned: true,
                                  // floating: true,
                                  expandedHeight:
                                      MediaQuery.of(context).size.height * 0.4,
                                  flexibleSpace: FlexibleSpaceBar(
                                    title: const Text(
                                      'Сейчас прослушивается',
                                      textAlign: TextAlign.center,
                                    ),
                                    centerTitle: true,
                                    background: ShaderMask(
                                      shaderCallback: (rect) {
                                        return const LinearGradient(
                                          begin: Alignment.center,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.black,
                                            Colors.transparent
                                          ],
                                        ).createShader(Rect.fromLTRB(
                                            0, 0, rect.width, rect.height));
                                      },
                                      blendMode: BlendMode.dstIn,
                                      child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        errorWidget:
                                            (BuildContext context, _, __) =>
                                                const Image(
                                          image: AssetImage(
                                              'assets/placeholder.jpg'),
                                        ),
                                        placeholder:
                                            (BuildContext context, _) =>
                                                const Image(
                                          image: AssetImage(
                                              'assets/placeholder.jpg'),
                                        ),
                                        imageUrl: mediaItem.artUri!.toString(),
                                      ),
                                    ),
                                  ),
                                ),
                                SliverList(
                                  delegate: SliverChildListDelegate(
                                    [
                                      NowPlayingStream(
                                        audioHandler,
                                        hideHeader: true,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            );
                    },
                  ),
          );
        },
      ),
      bottomSheet: SafeArea(
        child: MiniPlayer(),
      ),
    );
  }
}

class NowPlayingStream extends StatelessWidget {
  final AudioPlayerHandler audioHandler;
  final bool hideHeader;

  const NowPlayingStream(this.audioHandler, {this.hideHeader = false});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QueueState>(
      stream: audioHandler.queueState,
      builder: (context, snapshot) {
        final queueState = snapshot.data ?? QueueState.empty;
        final queue = queueState.queue;
        return ReorderableListView.builder(
          onReorder: (int oldIndex, int newIndex) {
            if (oldIndex < newIndex) {
              newIndex--;
            }
            audioHandler.moveQueueItem(oldIndex, newIndex);
          },
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 10),
          shrinkWrap: true,
          itemCount: queue.length,
          itemBuilder: (context, index) {
            return Dismissible(
              key: ValueKey(queue[index].id),
              direction: index == queueState.queueIndex
                  ? DismissDirection.none
                  : DismissDirection.horizontal,
              onDismissed: (dir) {
                audioHandler.removeQueueItemAt(index);
              },
              child: ListTileTheme(
                selectedColor: Theme.of(context).accentColor,
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.only(left: 16.0, right: 10.0),
                  selected: index == queueState.queueIndex,
                  trailing: IgnorePointer(
                    child: IconButton(
                      icon: index == queueState.queueIndex
                          ? const Icon(
                              Icons.bar_chart_rounded,
                            )
                          : const Icon(Icons.touch_app_rounded),
                      onPressed: () {},
                    ),
                  ),
                  leading: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: (queue[index].artUri == null)
                        ? const SizedBox(
                            height: 50.0,
                            width: 50.0,
                            child: Image(
                              image: AssetImage('assets/cover.jpg'),
                            ),
                          )
                        : SizedBox(
                            height: 50.0,
                            width: 50.0,
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              errorWidget: (BuildContext context, _, __) =>
                                  const Image(
                                image: AssetImage('assets/cover.jpg'),
                              ),
                              placeholder: (BuildContext context, _) =>
                                  const Image(
                                image: AssetImage('assets/cover.jpg'),
                              ),
                              imageUrl: queue[index].artUri.toString(),
                            ),
                          ),
                  ),
                  title: Text(
                    queue[index].title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: index == queueState.queueIndex
                            ? FontWeight.w600
                            : FontWeight.normal),
                  ),
                  subtitle: Text(
                    queue[index].artist!,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    audioHandler.skipToQueueItem(index);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
