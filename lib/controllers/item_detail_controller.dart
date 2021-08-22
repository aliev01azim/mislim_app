import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemDetailController extends GetxController {
  IconData btnIcon = Icons.play_arrow;

  Duration duration = const Duration();
  Duration position = const Duration();

  //9.Now add music player
  AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
  bool isPlaying = false;
  String currentSong = "";

  void playMusic(String url) async {
    if (isPlaying && currentSong != url) {
      audioPlayer.pause();
      int result = await audioPlayer.play(url);
      if (result == 1) {
        currentSong = url;
      }
    } else if (!isPlaying) {
      int result = await audioPlayer.play(url);
      if (result == 1) {
        isPlaying = true;
        btnIcon = Icons.pause;
        //from now we hear song
      }
    }
    update();
  }

  //11
  void changing() {
    audioPlayer.onDurationChanged.listen((event) {
      duration = event;
      update();
    });

    audioPlayer.onAudioPositionChanged.listen((event) {
      position = event;
      update();
    });
  }
}
