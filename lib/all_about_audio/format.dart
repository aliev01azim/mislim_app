class FormatResponse {
  String formatString(String text) {
    return text
        .toString()
        .replaceAll('&amp;', '&')
        .replaceAll('&#039;', "'")
        .replaceAll('&quot;', '"')
        .trim();
  }

  Future<List> formatSongsResponse(List responseList, String type) async {
    final List searchedList = [];
    for (int i = 0; i < responseList.length; i++) {
      Map? response;
      switch (type) {
        case 'song':
        case 'album':
        case 'playlist':
          response = await formatSingleSongResponse(responseList[i] as Map);
          break;
        default:
          break;
      }

      if (response!.containsKey('Error')) {
        // ignore: avoid_print
        print('Error at index $i inside FormatResponse: ${response["Error"]}');
      } else {
        searchedList.add(response);
      }
    }
    return searchedList;
  }

  Future<Map> formatSingleSongResponse(Map response) async {
    try {
      return {
        'id': response['id'].toString(),
        'album': formatString(response['category']['title']),
        'duration': response['due_time'],
        'title': formatString(response['title']),
        'artist': formatString(response['author']['name']),
        'image': response['image']
            .toString()
            .replaceAll('150x150', '500x500')
            .replaceAll('50x50', '500x500')
            .replaceAll('http:', 'https:'),
        'url': response['lecture_file'].toString(),
      };
    } catch (e) {
      return {'Error': e};
    }
  }

  // Future<Map> formatSingleAlbumSongResponse(Map response) async {
  //   try {
  //     final List artistNames = [];
  //     if (response['primary_artists'] == null ||
  //         response['primary_artists'].toString().trim() == '') {
  //       if (response['featured_artists'] == null ||
  //           response['featured_artists'].toString().trim() == '') {
  //         if (response['singers'] == null ||
  //             response['singer'].toString().trim() == '') {
  //           response['singers'].toString().split(', ').forEach((element) {
  //             artistNames.add(element);
  //           });
  //         } else {
  //           artistNames.add('Unknown');
  //         }
  //       } else {
  //         response['featured_artists']
  //             .toString()
  //             .split(', ')
  //             .forEach((element) {
  //           artistNames.add(element);
  //         });
  //       }
  //     } else {
  //       response['primary_artists'].toString().split(', ').forEach((element) {
  //         artistNames.add(element);
  //       });
  //     }

  //     return {
  //       'id': response['id'],
  //       'type': response['type'],
  //       'album': formatString(response['album'].toString()),
  //       // .split('(')
  //       // .first
  //       'year': response['year'],
  //       'duration': response['duration'],
  //       '320kbps': response['320kbps'],
  //       'has_lyrics': response['has_lyrics'],
  //       'lyrics_snippet': formatString(response['lyrics_snippet'].toString()),
  //       'release_date': response['release_date'],
  //       'album_id': response['album_id'],
  //       'subtitle': formatString(
  //           '${response["primary_artists"].toString().trim()} - ${response["album"].toString().trim()}'),
  //       'title': formatString(response['song'].toString()),
  //       // .split('(')
  //       // .first
  //       'artist': formatString(artistNames.join(', ')),
  //       'album_artist': response['more_info'] == null
  //           ? response['music']
  //           : response['more_info']['music'],
  //       'image': response['image']
  //           .toString()
  //           .replaceAll('150x150', '500x500')
  //           .replaceAll('50x50', '500x500')
  //           .replaceAll('http:', 'https:'),
  //       'perma_url': response['perma_url'],
  //       'url': decode(response['encrypted_media_url'].toString())
  //     };
  //   } catch (e) {
  //     return {'Error': e};
  //   }
  // }

  Future<List<Map>> formatAlbumResponse(List responseList, String type) async {
    final List<Map> searchedAlbumList = [];
    for (int i = 0; i < responseList.length; i++) {
      Map? response;
      switch (type) {
        case 'album':
          response = await formatSingleAlbumResponse(responseList[i] as Map);
          break;
        case 'artist':
          response = await formatSingleArtistResponse(responseList[i] as Map);
          break;
        case 'playlist':
          response = await formatSinglePlaylistResponse(responseList[i] as Map);
          break;
      }
      if (response!.containsKey('Error')) {
        // ignore: avoid_print
        print(
            'Error at index $i inside FormatAlbumResponse: ${response["Error"]}');
      } else {
        searchedAlbumList.add(response);
      }
    }
    return searchedAlbumList;
  }

  Future<Map> formatSingleAlbumResponse(Map response) async {
    try {
      return {
        'id': response['id'],
        'type': response['type'],
        'album': formatString(response['title'].toString()),
        // .split('(')
        // .first
        'year': response['more_info']['year'] ?? response['year'],
        'album_id': response['id'],
        'subtitle': response['description'] == null
            ? formatString(response['subtitle'].toString())
            : formatString(response['description'].toString()),
        'title': formatString(response['title'].toString()),
        // .split('(')
        // .first
        'artist': response['music'] == null
            ? response['more_info']['music'] == null
                ? response['more_info']['artistMap']['primary_artists'] == null
                    ? ''
                    : formatString(response['more_info']['artistMap']
                            ['primary_artists'][0]['name']
                        .toString())
                : formatString(response['more_info']['music'].toString())
            : formatString(response['music'].toString()),
        'album_artist': response['more_info'] == null
            ? response['music']
            : response['more_info']['music'],
        'image': response['image']
            .toString()
            .replaceAll('150x150', '500x500')
            .replaceAll('50x50', '500x500')
            .replaceAll('http:', 'https:'),
        'count': response['more_info']['song_pids'] == null
            ? 0
            : response['more_info']['song_pids'].toString().split(', ').length,
        'songs_pids': response['more_info']['song_pids'].toString().split(', '),
      };
    } catch (e) {
      return {'Error': e};
    }
  }

  Future<Map> formatSinglePlaylistResponse(Map response) async {
    try {
      return {
        'id': response['id'],
        'type': response['type'],
        'album': formatString(response['title'].toString()),
        'playlistId': response['id'],
        'subtitle': response['description'] == null
            ? formatString(response['subtitle'].toString())
            : formatString(response['description'].toString()),
        'title': formatString(response['title'].toString()),
        // .split('(')
        // .first
        'artist': formatString(response['extra'].toString()),
        'album_artist': response['more_info'] == null
            ? response['music']
            : response['more_info']['music'],
        'image': response['image']
            .toString()
            .replaceAll('150x150', '500x500')
            .replaceAll('50x50', '500x500')
            .replaceAll('http:', 'https:'),
      };
    } catch (e) {
      return {'Error': e};
    }
  }

  Future<Map> formatSingleArtistResponse(Map response) async {
    try {
      return {
        'id': response['id'],
        'type': response['type'],
        'album': response['title'] == null
            ? formatString(response['name'].toString())
            : formatString(response['title'].toString()),
        'artistId': response['id'],
        'artistToken': response['url'] == null
            ? response['perma_url'].toString().split('/').last
            : response['url'].toString().split('/').last,
        'title': response['title'] == null
            ? formatString(response['name'].toString())
            : formatString(response['title'].toString()),
        // .split('(')
        // .first

        'artist': formatString(response['title'].toString()),
        'album_artist': response['more_info'] == null
            ? response['music']
            : response['more_info']['music'],
        'image': response['image']
            .toString()
            .replaceAll('150x150', '500x500')
            .replaceAll('50x50', '500x500')
            .replaceAll('http:', 'https:'),
      };
    } catch (e) {
      return {'Error': e};
    }
  }

  Future<List> formatArtistTopAlbumsResponse(List responseList) async {
    final List result = [];
    for (int i = 0; i < responseList.length; i++) {
      final Map response =
          await formatSingleArtistTopAlbumSongResponse(responseList[i] as Map);
      if (response.containsKey('Error')) {
        // ignore: avoid_print
        print('Error at index $i inside FormatResponse: ${response["Error"]}');
      } else {
        result.add(response);
      }
    }
    return result;
  }

  Future<Map> formatSingleArtistTopAlbumSongResponse(Map response) async {
    try {
      final List artistNames = [];
      if (response['more_info']['artistMap']['primary_artists'] == null ||
          response['more_info']['artistMap']['primary_artists'].length == 0) {
        if (response['more_info']['artistMap']['featured_artists'] == null ||
            response['more_info']['artistMap']['featured_artists'].length ==
                0) {
          if (response['more_info']['artistMap']['artists'] == null ||
              response['more_info']['artistMap']['artists'].length == 0) {
            artistNames.add('Unknown');
          } else {
            response['more_info']['artistMap']['artists'].forEach((element) {
              artistNames.add(element['name']);
            });
          }
        } else {
          response['more_info']['artistMap']['featured_artists']
              .forEach((element) {
            artistNames.add(element['name']);
          });
        }
      } else {
        response['more_info']['artistMap']['primary_artists']
            .forEach((element) {
          artistNames.add(element['name']);
        });
      }

      return {
        'id': response['id'],
        'type': response['type'],
        'album': formatString(response['title'].toString()),
        // .split('(')
        // .first
        'year': response['year'],
        'album_id': response['id'],
        'subtitle': formatString(response['subtitle'].toString()),
        'title': formatString(response['title'].toString()),
        // .split('(')
        // .first
        'artist': formatString(artistNames.join(', ')),
        'album_artist': response['more_info'] == null
            ? response['music']
            : response['more_info']['music'],
        'image': response['image']
            .toString()
            .replaceAll('150x150', '500x500')
            .replaceAll('50x50', '500x500')
            .replaceAll('http:', 'https:'),
      };
    } catch (e) {
      return {'Error': e};
    }
  }
}
