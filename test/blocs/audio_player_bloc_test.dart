import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audio_service/audio_service.dart';
import 'package:alquran/core/network/api_service.dart';
import 'package:alquran/core/services/my_audio_handler.dart';
import 'package:alquran/presentation/blocs/audio_player/audio_player_bloc.dart';
import 'package:alquran/presentation/blocs/quran/quran_bloc.dart';

class MockMyAudioHandler extends Mock implements MyAudioHandler {}
class MockApiService extends Mock implements ApiService {}
class MockQuranBloc extends Mock implements QuranBloc {}
class FakeMediaItem extends Fake implements MediaItem {} 

void main() {
  late MockMyAudioHandler mockAudioHandler;
  late MockApiService mockApiService;
  late MockQuranBloc mockQuranBloc;

  setUpAll(() {
    registerFallbackValue(Duration.zero);
    registerFallbackValue(FakeMediaItem());
  });

  setUp(() {
    mockAudioHandler = MockMyAudioHandler();
    mockApiService = MockApiService();
    mockQuranBloc = MockQuranBloc();

    when(() => mockAudioHandler.onPositionChanged).thenAnswer((_) => const Stream.empty());
    when(() => mockAudioHandler.onDurationChanged).thenAnswer((_) => const Stream.empty());
    when(() => mockAudioHandler.onPlayerStateChanged).thenAnswer((_) => const Stream.empty());
    when(() => mockAudioHandler.onPlayerComplete).thenAnswer((_) => const Stream.empty());
    when(() => mockAudioHandler.onSkipToNext).thenAnswer((_) => const Stream.empty());
    when(() => mockAudioHandler.onSkipToPrevious).thenAnswer((_) => const Stream.empty());
  });

  group('AudioPlayerBloc Tests', () {
    test('initial state is correct', () {
      final bloc = AudioPlayerBloc(audioHandler: mockAudioHandler, apiService: mockApiService, quranBloc: mockQuranBloc);
      expect(bloc.state.isPlaying, false);
      expect(bloc.state.currentSurah, isNull);
      bloc.close();
    });
  });
}
