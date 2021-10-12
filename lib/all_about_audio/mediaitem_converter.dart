import 'package:audio_service/audio_service.dart';

class MediaItemConverter {
  Map mediaItemtoMap(MediaItem mediaItem) {
    return {
      'id': mediaItem.id.toString(),
      'album': mediaItem.album.toString(),
      'artist': mediaItem.artist.toString(),
      'duration': mediaItem.duration?.inSeconds.toString(),
      'image': mediaItem.artUri.toString(),
      'title': mediaItem.title.toString(),
      'url': mediaItem.extras!['url'].toString(),
      'isFavorite': mediaItem.extras!['isFavorite'].toString(),
      'artistId': mediaItem.extras!['artistId'].toString(),
      'categoryId': mediaItem.extras!['categoryId'].toString(),
      'categoryImage': mediaItem.extras!['categoryImage'].toString(),
    };
  }

  MediaItem mapToMediaItem(Map song) {
    if (song['duration'].toString().contains(':')) {
      song['duration'] =
          int.parse(song['duration'].toString().split(':')[0]) * 60 +
              int.parse(song['duration'].toString().split(':')[1]);
    }
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
        artUri: Uri.parse(song['image'].toString()),
        extras: {
          'url': song['url'],
          'isFavorite': song['isFavorite'].toString(),
          'artistId': song['artistId'],
          'categoryId': song['categoryId'],
          'categoryImage': song['categoryImage'],
        });
  }
}
