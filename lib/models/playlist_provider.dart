import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_app/models/song.dart';

class PlaylistProvider extends ChangeNotifier {
  // playlist of songs
  final List<Song> _playlist = [
    //song 1
    Song(
      songName: "Gul",
      artistName: "Anuv jain",
      albumArtImagePath: "assets/images/gul_song_img.jpeg",
      audioPath: "audio/Gul.mp3",
    ),

    // Song 2
    Song(
      songName: "One Love",
      artistName: "Subh",
      albumArtImagePath: "assets/images/One-Love-img.jpeg",
      audioPath: "audio/One Love.mp3",
    ),
    // Song 3
    Song(
      songName: "Rang Lageya",
      artistName: "Mohit Chauhan",
      albumArtImagePath: "assets/images/rang_lagya_img.jpeg",
      audioPath: "audio/Rang-Lageya.mp3",
    ),
  ];

  // current song playing index

  int? _currentSongIndex;

  //! coding up the Audio player

  // audio player

  final AudioPlayer _audioPlayer = AudioPlayer();

  // duration
  Duration _currentDuartion = Duration.zero;
  Duration _totalDuaration = Duration.zero;

  // constructor
  PlaylistProvider() {
    listenToDuration();
  }
  // intially not playing
  bool _isPlaying = false;

  // play the song
  void play() async {
    final String path = _playlist[_currentSongIndex!].audioPath;
    await _audioPlayer.stop(); // stop the current song
    await _audioPlayer.play(AssetSource(path)); // then play this assest
    _isPlaying = true;
    notifyListeners();
  }

  //pause current song
  void pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  // resume song
  void resume() async {
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  // pause or resume
  void pauseOrResume() async {
    if (_isPlaying) {
      pause();
    } else {
      resume();
    }
    notifyListeners();
  }

  //seek to a speific poistion in the current song // use thumb to drag around
  void seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  //play next song
  void playNextSong() {
    if (_currentSongIndex != null) {
      if (_currentSongIndex! < _playlist.length - 1) {
        // go to the next song if it’s not the last song
        currentSongIndex = currentSongIndex! + 1;
      } else {
        // if it’s the last song , loop back to the first song
        currentSongIndex = 0;
      }
    }
  }

  // play previous song
  void playPreviousSong() async {
    // if moew then 2 seconds have passed , restart the current song
    if (_currentDuartion.inSeconds > 2) {
      seek(Duration.zero);
// if more then two seconds have passed then restart the current song
    }
    // if it's within first two seconds of song , go to previous song
    else {
      if (_currentSongIndex! > 0) {
        currentSongIndex = _currentSongIndex! - 1;
      } else {
        // if it's the first song, loop back to last song
        currentSongIndex = _playlist.length - 1;
      }
    }
  }

  //listen to duration
  void listenToDuration() {
    // listen for the total duration
    _audioPlayer.onDurationChanged.listen((newDuartion) {
      _totalDuaration = newDuartion;
      notifyListeners();
    });

    // listen for current duration
    _audioPlayer.onPositionChanged.listen((newPosition) {
      _currentDuartion = newPosition;
      notifyListeners();
    });

    // listen for song completion
    _audioPlayer.onPlayerComplete.listen((event) {
      playNextSong();
    });
  }
  // dispose audio player

  // Getters

  List<Song> get playlist => _playlist; // getting the current playlist
  int? get currentSongIndex => _currentSongIndex;
  bool? get isPlaying => _isPlaying;
  Duration get currentDuartion => _currentDuartion;
  Duration get totalDuartion => _totalDuaration;

  // Setters

  set currentSongIndex(int? newIndex) {
    // update current song index
    _currentSongIndex = newIndex;

    if (newIndex != null) {
      play(); // play the song at the new index
    }

    // update UI
    notifyListeners();
  }
}
