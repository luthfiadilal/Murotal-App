import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/api_service.dart';
import '../../../core/services/my_audio_handler.dart';
import 'audio_player_event.dart';
import 'audio_player_state.dart';

class AudioPlayerBloc extends Bloc<AudioPlayerEvent, AudioPlayerState> {
  final MyAudioHandler audioHandler;
  final ApiService apiService;

  StreamSubscription? _positionSubscription;
  StreamSubscription? _durationSubscription;
  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _playerCompleteSubscription;

  AudioPlayerBloc({
    required this.audioHandler,
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
    _positionSubscription = audioHandler.onPositionChanged.listen(
      (position) => add(AudioPositionChanged(position)),
    );

    _durationSubscription = audioHandler.onDurationChanged.listen(
      (duration) => add(AudioDurationChanged(duration)),
    );

    _playerStateSubscription = audioHandler.onPlayerStateChanged.listen(
      (state) {
        add(AudioPlayerStateChanged(state == PlayerState.playing));
      },
    );

    _playerCompleteSubscription = audioHandler.onPlayerComplete.listen(
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

    final mediaItem = MediaItem(
      id: url,
      album: event.qari.englishName ?? 'Quran',
      title: event.surah.englishName ?? 'Surah',
      artist: event.qari.englishName ?? 'Qari',
      artUri: Uri.parse(
          'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d3/Quran_Kareem.svg/1024px-Quran_Kareem.svg.png'), // placeholder image
    );

    await audioHandler.playUrl(url, item: mediaItem);

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
    await audioHandler.pause();
    emit(state.copyWith(isPlaying: false, isPaused: true));
  }

  Future<void> _onResumeAudio(
    ResumeAudio event,
    Emitter<AudioPlayerState> emit,
  ) async {
    await audioHandler.play();
    emit(state.copyWith(isPlaying: true, isPaused: false));
  }

  Future<void> _onStopAudio(
    StopAudio event,
    Emitter<AudioPlayerState> emit,
  ) async {
    await audioHandler.stop();
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
    await audioHandler.seek(event.position);
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
    return super.close();
  }
}
