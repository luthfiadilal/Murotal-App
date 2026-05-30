import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/api_service.dart';
import '../../../core/services/audio_service.dart';
import 'audio_player_event.dart';
import 'audio_player_state.dart';

class AudioPlayerBloc extends Bloc<AudioPlayerEvent, AudioPlayerState> {
  final AudioService audioService;
  final ApiService apiService;

  StreamSubscription? _positionSubscription;
  StreamSubscription? _durationSubscription;
  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _playerCompleteSubscription;

  AudioPlayerBloc({
    required this.audioService,
    required this.apiService,
  }) : super(const AudioPlayerState()) {
    on<PlayAudio>(_onPlayAudio);
    on<PauseAudio>(_onPauseAudio);
    on<ResumeAudio>(_onResumeAudio);
    on<StopAudio>(_onStopAudio);
    on<SeekAudio>(_onSeekAudio);
    on<AudioPositionChanged>(_onAudioPositionChanged);
    on<AudioDurationChanged>(_onAudioDurationChanged);
    on<AudioPlayerStateChanged>(_onAudioPlayerStateChanged);

    _initSubscriptions();
  }

  void _initSubscriptions() {
    _positionSubscription = audioService.onPositionChanged.listen(
      (position) => add(AudioPositionChanged(position)),
    );

    _durationSubscription = audioService.onDurationChanged.listen(
      (duration) => add(AudioDurationChanged(duration)),
    );

    _playerStateSubscription = audioService.onPlayerStateChanged.listen(
      (state) {
        add(AudioPlayerStateChanged(state == PlayerState.playing));
      },
    );

    _playerCompleteSubscription = audioService.onPlayerComplete.listen(
      (_) {
        add(const AudioPlayerStateChanged(false));
        add(const AudioPositionChanged(Duration.zero));
        add(StopAudio());
      },
    );
  }

  Future<void> _onPlayAudio(
    PlayAudio event,
    Emitter<AudioPlayerState> emit,
  ) async {
    final surahNumber = event.surah.number;
    final edition = event.qari.identifier ?? 'ar.alafasy';

    if (surahNumber == null) return;

    final url = apiService.getSurahAudioUrl(
      surahNumber: surahNumber,
      edition: edition,
    );

    await audioService.play(url);

    emit(state.copyWith(
      currentSurah: event.surah,
      currentQari: event.qari,
      isPlaying: true,
      isPaused: false,
    ));
  }

  Future<void> _onPauseAudio(
    PauseAudio event,
    Emitter<AudioPlayerState> emit,
  ) async {
    await audioService.pause();
    emit(state.copyWith(isPlaying: false, isPaused: true));
  }

  Future<void> _onResumeAudio(
    ResumeAudio event,
    Emitter<AudioPlayerState> emit,
  ) async {
    await audioService.resume();
    emit(state.copyWith(isPlaying: true, isPaused: false));
  }

  Future<void> _onStopAudio(
    StopAudio event,
    Emitter<AudioPlayerState> emit,
  ) async {
    await audioService.stop();
    emit(state.copyWith(
      isPlaying: false,
      isPaused: false,
      currentPosition: Duration.zero,
    ));
  }

  Future<void> _onSeekAudio(
    SeekAudio event,
    Emitter<AudioPlayerState> emit,
  ) async {
    await audioService.seek(event.position);
  }

  void _onAudioPositionChanged(
    AudioPositionChanged event,
    Emitter<AudioPlayerState> emit,
  ) {
    emit(state.copyWith(currentPosition: event.position));
  }

  void _onAudioDurationChanged(
    AudioDurationChanged event,
    Emitter<AudioPlayerState> emit,
  ) {
    emit(state.copyWith(totalDuration: event.duration));
  }

  void _onAudioPlayerStateChanged(
    AudioPlayerStateChanged event,
    Emitter<AudioPlayerState> emit,
  ) {
    if (event.isPlaying != state.isPlaying) {
      emit(state.copyWith(
        isPlaying: event.isPlaying,
        isPaused: !event.isPlaying,
      ));
    }
  }

  @override
  Future<void> close() {
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    // Do not dispose audioService here if it's going to be reused.
    // If audioService is a singleton/provider, it might be disposed elsewhere.
    // audioService.dispose();
    return super.close();
  }
}
