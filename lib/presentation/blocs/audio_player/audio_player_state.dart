import 'package:equatable/equatable.dart';

import '../../../data/models/edition_model.dart';
import '../../../data/models/surah_model.dart';

class AudioPlayerState extends Equatable {
  final bool isPlaying;
  final bool isPaused;
  final Duration currentPosition;
  final Duration totalDuration;
  final SurahModel? currentSurah;
  final EditionModel? currentQari;

  const AudioPlayerState({
    this.isPlaying = false,
    this.isPaused = false,
    this.currentPosition = Duration.zero,
    this.totalDuration = Duration.zero,
    this.currentSurah,
    this.currentQari,
  });

  AudioPlayerState copyWith({
    bool? isPlaying,
    bool? isPaused,
    Duration? currentPosition,
    Duration? totalDuration,
    SurahModel? currentSurah,
    EditionModel? currentQari,
  }) {
    return AudioPlayerState(
      isPlaying: isPlaying ?? this.isPlaying,
      isPaused: isPaused ?? this.isPaused,
      currentPosition: currentPosition ?? this.currentPosition,
      totalDuration: totalDuration ?? this.totalDuration,
      currentSurah: currentSurah ?? this.currentSurah,
      currentQari: currentQari ?? this.currentQari,
    );
  }

  @override
  List<Object?> get props => [
        isPlaying,
        isPaused,
        currentPosition,
        totalDuration,
        currentSurah,
        currentQari,
      ];
}
