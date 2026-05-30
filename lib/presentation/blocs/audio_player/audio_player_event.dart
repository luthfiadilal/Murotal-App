import 'package:equatable/equatable.dart';

import '../../../data/models/edition_model.dart';
import '../../../data/models/surah_model.dart';

abstract class AudioPlayerEvent extends Equatable {
  const AudioPlayerEvent();

  @override
  List<Object?> get props => [];
}

class PlayAudio extends AudioPlayerEvent {
  final SurahModel surah;
  final EditionModel qari;

  const PlayAudio({required this.surah, required this.qari});

  @override
  List<Object?> get props => [surah, qari];
}

class PauseAudio extends AudioPlayerEvent {}

class ResumeAudio extends AudioPlayerEvent {}

class StopAudio extends AudioPlayerEvent {}

class SeekAudio extends AudioPlayerEvent {
  final Duration position;

  const SeekAudio(this.position);

  @override
  List<Object?> get props => [position];
}

class AudioPositionChanged extends AudioPlayerEvent {
  final Duration position;

  const AudioPositionChanged(this.position);

  @override
  List<Object?> get props => [position];
}

class AudioDurationChanged extends AudioPlayerEvent {
  final Duration duration;

  const AudioDurationChanged(this.duration);

  @override
  List<Object?> get props => [duration];
}

class AudioPlayerStateChanged extends AudioPlayerEvent {
  final bool isPlaying;

  const AudioPlayerStateChanged(this.isPlaying);

  @override
  List<Object?> get props => [isPlaying];
}
