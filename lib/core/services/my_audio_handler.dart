import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';

class MyAudioHandler extends BaseAudioHandler with SeekHandler {
  final AudioPlayer _player = AudioPlayer();
  final _skipToNextSubject = StreamController<void>.broadcast();
  final _skipToPreviousSubject = StreamController<void>.broadcast();

  MyAudioHandler() {
    _player.onPlayerStateChanged.listen((state) {
      final playing = state == PlayerState.playing;
      playbackState.add(playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.skipToNext,
        ],
        systemActions: const {
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
        },
        androidCompactActionIndices: const [0, 1, 2],
        processingState: const {
          PlayerState.playing: AudioProcessingState.ready,
          PlayerState.paused: AudioProcessingState.ready,
          PlayerState.completed: AudioProcessingState.completed,
          PlayerState.stopped: AudioProcessingState.idle,
          PlayerState.disposed: AudioProcessingState.idle,
        }[state]!,
        playing: playing,
      ));
    });

    _player.onPositionChanged.listen((position) {
      playbackState.add(playbackState.value.copyWith(updatePosition: position));
    });

    _player.onDurationChanged.listen((duration) {
      if (mediaItem.value != null) {
        mediaItem.add(mediaItem.value!.copyWith(duration: duration));
      }
    });
  }

  // Expose streams for BLoC if needed
  Stream<Duration> get onPositionChanged => _player.onPositionChanged;
  Stream<Duration> get onDurationChanged => _player.onDurationChanged;
  Stream<PlayerState> get onPlayerStateChanged => _player.onPlayerStateChanged;
  Stream<void> get onPlayerComplete => _player.onPlayerComplete;
  Stream<void> get onSkipToNext => _skipToNextSubject.stream;
  Stream<void> get onSkipToPrevious => _skipToPreviousSubject.stream;

  @override
  Future<void> play() => _player.resume();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() async {
    await _player.stop();
    return super.stop();
  }

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  Future<void> playUrl(String url, {required MediaItem item}) async {
    mediaItem.add(item);
    
    // Paksa update state agar notifikasi langsung muncul dalam mode buffering
    playbackState.add(playbackState.value.copyWith(
      controls: [
        MediaControl.skipToPrevious,
        MediaControl.pause,
        MediaControl.skipToNext,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 2],
      processingState: AudioProcessingState.buffering,
      playing: true,
    ));

    await _player.play(UrlSource(url));
  }

  @override
  Future<void> skipToNext() async {
    _skipToNextSubject.add(null);
  }

  @override
  Future<void> skipToPrevious() async {
    _skipToPreviousSubject.add(null);
  }
}
