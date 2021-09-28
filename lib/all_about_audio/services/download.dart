import 'dart:io';

import 'package:aidar_zakaz/widgets/snackbar.dart';
import 'package:audiotagger/audiotagger.dart';
import 'package:audiotagger/models/tag.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Download with ChangeNotifier {
  int? rememberOption;
  final ValueNotifier<bool> remember = ValueNotifier<bool>(false);

  String downloadFormat = 'm4a';

  double? progress = 0.0;
  String lastDownloadId = '';
  bool downloadLyrics =
      Hive.box('settings').get('downloadLyrics', defaultValue: false) as bool;

  Future<void> prepareDownload(BuildContext context, Map data,
      {bool createFolder = false, String? folderName}) async {
    if (!Platform.isWindows) {
      PermissionStatus status = await Permission.storage.status;
      if (status.isPermanentlyDenied || status.isDenied) {
        final Map<Permission, PermissionStatus> statuses = await [
          Permission.storage,
          Permission.accessMediaLocation,
          Permission.mediaLibrary,
        ].request();
        debugPrint(statuses[Permission.storage].toString());
      }
      status = await Permission.storage.status;
    }
    final RegExp avoid = RegExp(r'[\.\\\*\:\"\?#/;\|]');
    data['title'] = data['title'].toString().split('(From')[0].trim();
    String filename = '${data["title"]} - ${data["artist"]}';
    String dlPath =
        Hive.box('settings').get('downloadPath', defaultValue: '') as String;
    if (filename.length > 200) {
      final String temp = filename.substring(0, 200);
      final List tempList = temp.split(', ');
      tempList.removeLast();
      filename = tempList.join(', ');
    }

    filename = '${filename.replaceAll(avoid, "").replaceAll("  ", " ")}.m4a';
    if (dlPath == '') {
      if (Platform.isWindows) {
        final Directory? temp = await getDownloadsDirectory();
        dlPath = temp!.path;
      } else {
        final String? temp = await ExtStorage.getExternalStoragePublicDirectory(
            ExtStorage.DIRECTORY_MUSIC);
        dlPath = temp!;
      }
    }
    if (data['url'].toString().contains('google')) {
      dlPath = '$dlPath/YouTube';
      if (!await Directory(dlPath).exists()) {
        await Directory(dlPath).create();
      }
    }

    if (createFolder && folderName != null) {
      final String foldername = folderName.replaceAll(avoid, '');
      dlPath = '$dlPath/$foldername';
      if (!await Directory(dlPath).exists()) {
        await Directory(dlPath).create();
      }
    }

    final bool exists = await File('$dlPath/$filename').exists();
    if (exists) {
      if (remember.value == true && rememberOption != null) {
        switch (rememberOption) {
          case 0:
            lastDownloadId = data['id'].toString();
            break;
          case 1:
            downloadSong(context, dlPath, filename, data);
            break;
          case 2:
            while (await File('$dlPath/$filename').exists()) {
              filename = filename.replaceAll('.m4a', ' (1).m4a');
            }
            break;
          default:
            lastDownloadId = data['id'].toString();
            break;
        }
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text(
                  'Already Exists',
                  style: TextStyle(color: Theme.of(context).accentColor),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 400,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '"${data['title']}" already exists.\nDo you want to download it again?',
                            softWrap: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
                actions: [
                  Column(
                    children: [
                      ValueListenableBuilder(
                          valueListenable: remember,
                          builder: (BuildContext context, bool value,
                              Widget? child) {
                            return Row(
                              children: [
                                Checkbox(
                                  activeColor: Theme.of(context).accentColor,
                                  value: remember.value,
                                  onChanged: (bool? value) {
                                    remember.value = value ?? false;
                                  },
                                ),
                                const Text('Remember my choice'),
                              ],
                            );
                          }),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            style: TextButton.styleFrom(
                              primary: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.grey[700],
                            ),
                            onPressed: () {
                              lastDownloadId = data['id'].toString();
                              Navigator.pop(context);
                              rememberOption = 0;
                            },
                            child: const Text(
                              'No',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              primary: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.grey[700],
                            ),
                            onPressed: () async {
                              Navigator.pop(context);
                              downloadSong(context, dlPath, filename, data);
                              rememberOption = 1;
                            },
                            child: const Text('Yes, but Replace Old'),
                          ),
                          const SizedBox(width: 5.0),
                          TextButton(
                            style: TextButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor: Theme.of(context).accentColor,
                            ),
                            onPressed: () async {
                              Navigator.pop(context);
                              while (await File('$dlPath/$filename').exists()) {
                                filename =
                                    filename.replaceAll('.m4a', ' (1).m4a');
                              }
                              rememberOption = 2;
                              downloadSong(context, dlPath, filename, data);
                            },
                            child: const Text('Yes'),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                    ],
                  ),
                ]);
          },
        );
      }
    } else {
      downloadSong(context, dlPath, filename, data);
    }
  }

  Future<void> downloadSong(
      BuildContext context, String? dlPath, String fileName, Map data) async {
    progress = null;
    notifyListeners();
    String filename = fileName;
    String? filepath;
    late String filepath2;
    String appPath;
    final List<int> _bytes = [];
    final artname = filename.replaceAll('.m4a', 'artwork.jpg');
    if (!Platform.isWindows) {
      final Directory appDir = await getApplicationDocumentsDirectory();
      appPath = appDir.path;
    } else {
      final Directory? temp = await getDownloadsDirectory();
      appPath = temp!.path;
    }
    if (data['url'].toString().contains('google')) {
      filename = filename.replaceAll('.m4a', '.opus');
    }
    try {
      await File('$dlPath/$filename')
          .create(recursive: true)
          .then((value) => filepath = value.path);
      await File('$appPath/$artname')
          .create(recursive: true)
          .then((value) => filepath2 = value.path);
    } catch (e) {
      await [
        Permission.manageExternalStorage,
      ].request();
      await File('$dlPath/$filename')
          .create(recursive: true)
          .then((value) => filepath = value.path);
      await File('$appPath/$artname')
          .create(recursive: true)
          .then((value) => filepath2 = value.path);
    }
    debugPrint('Audio path $filepath');
    debugPrint('Image path $filepath2');

    final String kUrl = data['url'].toString();
    final response = await Client().send(Request('GET', Uri.parse(kUrl)));
    final int total = response.contentLength ?? 0;
    int recieved = 0;
    response.stream.asBroadcastStream();
    response.stream.listen((value) {
      _bytes.addAll(value);
      try {
        recieved += value.length;
        progress = recieved / total;
        notifyListeners();
      } catch (e) {}
    }).onDone(() async {
      final file = File(filepath!);
      await file.writeAsBytes(_bytes);

      final HttpClientRequest request2 =
          await HttpClient().getUrl(Uri.parse(data['image'].toString()));
      final HttpClientResponse response2 = await request2.close();
      final bytes2 = await consolidateHttpClientResponseBytes(response2);
      final File file2 = File(filepath2);

      await file2.writeAsBytes(bytes2);

      debugPrint('Started tag editing');
      final Tag tag = Tag(
        title: data['title'].toString(),
        artist: data['artist'].toString(),
        albumArtist: data['album_artist']?.toString() ??
            data['artist']?.toString().split(', ')[0],
        artwork: filepath2.toString(),
        album: data['album'].toString(),
        genre: data['language'].toString(),
        year: data['year'].toString(),
        comment: 'BlackHole',
      );
      try {
        final tagger = Audiotagger();
        await tagger.writeTags(
          path: filepath!,
          tag: tag,
        );
        await Future.delayed(const Duration(seconds: 1), () {});
        if (await file2.exists()) {
          await file2.delete();
        }
      } catch (e) {
        rethrow;
      }
      debugPrint('Done');
      lastDownloadId = data['id'].toString();
      progress = 0.0;
      notifyListeners();
      ShowSnackBar().showSnackBar(
        context,
        '"${data['title'].toString()}" has been downloaded',
      );
    });
  }
}
