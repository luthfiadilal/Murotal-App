import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/api_service.dart';
import '../../../core/services/my_audio_handler.dart';
import '../quran/quran_bloc.dart';
import '../quran/quran_state.dart';
import 'audio_player_event.dart';
import 'audio_player_state.dart';

/// `AudioPlayerBloc` adalah pusat kendali (State Management) untuk semua operasi pemutar musik.
/// BLoC ini mendengarkan event seperti `PlayAudio`, `PauseAudio`, `PlayNextAudio`, dll
/// dan memperbarui antarmuka (UI) dengan memancarkan `AudioPlayerState` yang baru.
/// BLoC ini bekerja erat dengan `MyAudioHandler` untuk pemutaran audio di latar belakang.
class AudioPlayerBloc extends Bloc<AudioPlayerEvent, AudioPlayerState> {
  final MyAudioHandler audioHandler;
  final ApiService apiService;
  final QuranBloc quranBloc;

  StreamSubscription? _positionSubscription;
  StreamSubscription? _durationSubscription;
  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _playerCompleteSubscription;

  StreamSubscription? _skipNextSubscription;
  StreamSubscription? _skipPrevSubscription;

  /// Constructor: Menerima dependensi yang dibutuhkan dan mendaftarkan pemetaan Event ke fungsi penanganannya.
  AudioPlayerBloc({
    required this.audioHandler,
    required this.apiService,
    required this.quranBloc,
  }) : super(const AudioPlayerState()) {
    on<PlayAudio>(_onPlayAudio);
    on<PauseAudio>(_onPauseAudio);
    on<ResumeAudio>(_onResumeAudio);
    on<StopAudio>(_onStopAudio);
    on<PlayNextAudio>(_onPlayNextAudio);
    on<PlayPreviousAudio>(_onPlayPreviousAudio);
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
        add(PlayNextAudio());
      },
    );

    _skipNextSubscription = audioHandler.onSkipToNext.listen((_) {
      add(PlayNextAudio());
    });

    _skipPrevSubscription = audioHandler.onSkipToPrevious.listen((_) {
      add(PlayPreviousAudio());
    });
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
      album: 'Murotal Al-Quran',
      title: event.surah.englishName ?? 'Surah',
      artist: event.qari.englishName ?? 'Qari',
      artUri: Uri.parse(
          'https://images.unsplash.com/photo-1609599006353-e629aaab31f5?auto=format&fit=crop&w=800&q=80'), // Aesthetic Quran Image
    );

    try {
      await audioHandler.playUrl(url, item: mediaItem);

      emit(state.copyWith(
        currentSurah: event.surah,
        currentQari: event.qari,
        isPlaying: true,
        isPaused: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Audio tidak tersedia untuk edisi ini.',
        isPlaying: false,
      ));
    }
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

  Future<void> _onPlayNextAudio(
    PlayNextAudio event,
    Emitter<AudioPlayerState> emit,
  ) async {
    if (state.currentSurah == null || state.currentQari == null) return;
    
    final currentNumber = state.currentSurah!.number;
    if (currentNumber == null || currentNumber >= 114) {
      add(StopAudio());
      return;
    }

    final nextNumber = currentNumber + 1;
    final nextSurah = quranBloc.state is QuranLoaded 
        ? (quranBloc.state as QuranLoaded).allSurahs.firstWhere((s) => s.number == nextNumber, orElse: () => state.currentSurah!)
        : null;

    if (nextSurah != null && nextSurah.number != currentNumber) {
      add(PlayAudio(surah: nextSurah, qari: state.currentQari!));
    }
  }

  Future<void> _onPlayPreviousAudio(
    PlayPreviousAudio event,
    Emitter<AudioPlayerState> emit,
  ) async {
    if (state.currentSurah == null || state.currentQari == null) return;
    
    final currentNumber = state.currentSurah!.number;
    if (currentNumber == null || currentNumber <= 1) {
      return;
    }

    final prevNumber = currentNumber - 1;
    final prevSurah = quranBloc.state is QuranLoaded 
        ? (quranBloc.state as QuranLoaded).allSurahs.firstWhere((s) => s.number == prevNumber, orElse: () => state.currentSurah!)
        : null;

    if (prevSurah != null && prevSurah.number != currentNumber) {
      add(PlayAudio(surah: prevSurah, qari: state.currentQari!));
    }
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
    _skipNextSubscription?.cancel();
    _skipPrevSubscription?.cancel();
    return super.close();
  }
}
