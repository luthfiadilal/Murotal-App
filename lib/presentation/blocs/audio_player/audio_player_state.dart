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
  final String? errorMessage;

  const AudioPlayerState({
    this.isPlaying = false,
    this.isPaused = false,
    this.currentPosition = Duration.zero,
    this.totalDuration = Duration.zero,
    this.currentSurah,
    this.currentQari,
    this.errorMessage,
  });

  AudioPlayerState copyWith({
    bool? isPlaying,
    bool? isPaused,
    Duration? currentPosition,
    Duration? totalDuration,
    SurahModel? currentSurah,
    EditionModel? currentQari,
    String? errorMessage,
  }) {
    return AudioPlayerState(
      isPlaying: isPlaying ?? this.isPlaying,
      isPaused: isPaused ?? this.isPaused,
      currentPosition: currentPosition ?? this.currentPosition,
      totalDuration: totalDuration ?? this.totalDuration,
      currentSurah: currentSurah ?? this.currentSurah,
      currentQari: currentQari ?? this.currentQari,
      errorMessage: errorMessage, // We don't use ?? to allow clearing it
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
        errorMessage,
      ];
}
