import 'package:flutter/material.dart';
import 'package:music_player/music_player.dart';

import '../main.dart';

enum PlayerState { stopped, playing, paused }

class PlayerProvider extends ChangeNotifier {
  Duration duration;
  Duration position;

  PlayerState playerState = PlayerState.stopped;

  get isPlaying => playerState == PlayerState.playing;
  get isPaused => playerState == PlayerState.paused;

  get durationText =>
      duration != null ? duration.toString().split('.').first : '';
  get positionText =>
      position != null ? position.toString().split('.').first : '';


  initAudioPlayer() {
    musicPlayer = MusicPlayer();
  }

  play(String url, String title, String album, String artist, String albumArt, Duration duration ) async {
    musicPlayer.play(MusicItem(
      trackName: title,
      albumName: album,
      artistName: artist,
      url: url,
      coverUrl: albumArt,
      duration: duration,
    ));
    notifyListeners();
  }

  pause() {
    musicPlayer.pause();
    playerState = PlayerState.paused;
    notifyListeners();
  }

  pauseOrPlay(){

  }

  stop() {
  musicPlayer.stop();
  playerState = PlayerState.stopped;
  notifyListeners();
}


  void onComplete() {
    playerState = PlayerState.stopped;
    notifyListeners();
  }
}
