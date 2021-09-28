import 'package:audio_service/audio_service.dart';

class MediaItemConverter {
  Map mediaItemtoMap(MediaItem mediaItem) {
    return {
      'id': mediaItem.id.toString(),
      'album': mediaItem.album.toString(),
      'artist': mediaItem.artist.toString(),
      'duration': mediaItem.duration?.inSeconds.toString(),
      // 'image': mediaItem.artUri.toString(),
      'title': mediaItem.title.toString(),
      'url': mediaItem.extras!['url'].toString(),
    };
  }

  MediaItem mapToMediaItem(Map song) {
    return MediaItem(
        id: song['id'].toString(),
        album: song['album'],
        artist: song['artist'],
        duration: Duration(
          seconds: int.parse(
              (song['duration'] == null || song['duration'] == 'null')
                  ? '180'
                  : song['duration'].toString()),
        ),
        title: song['title'],
        // artUri: Uri.parse(song['image']
        //     .toString()
        //     .replaceAll('50x50', '500x500')
        //     .replaceAll('150x150', '500x500')),
        extras: {
          'url': song['url'],
          // 'subtitle': song['subtitle'],
        });
  }
}
