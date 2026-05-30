import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:alquran/data/models/surah_model.dart';
import 'package:alquran/data/models/edition_model.dart';
import 'package:alquran/presentation/blocs/favorite/favorite_bloc.dart';
import 'package:alquran/presentation/blocs/favorite/favorite_event.dart';
import 'package:alquran/presentation/blocs/favorite/favorite_state.dart';
import 'package:alquran/presentation/blocs/audio_player/audio_player_bloc.dart';
import 'package:alquran/presentation/blocs/audio_player/audio_player_event.dart';
import 'package:alquran/presentation/blocs/audio_player/audio_player_state.dart';
import 'package:alquran/presentation/screens/player_screen.dart';

class MockFavoriteBloc extends MockBloc<FavoriteEvent, FavoriteState> implements FavoriteBloc {}
class MockAudioPlayerBloc extends MockBloc<AudioPlayerEvent, AudioPlayerState> implements AudioPlayerBloc {}
class FakeAudioPlayerEvent extends Fake implements AudioPlayerEvent {}
class FakeFavoriteEvent extends Fake implements FavoriteEvent {}

void main() {
  late MockFavoriteBloc mockFavoriteBloc;
  late MockAudioPlayerBloc mockAudioPlayerBloc;

  setUpAll(() {
    registerFallbackValue(FakeAudioPlayerEvent());
    registerFallbackValue(FakeFavoriteEvent());
  });

  setUp(() {
    mockFavoriteBloc = MockFavoriteBloc();
    mockAudioPlayerBloc = MockAudioPlayerBloc();
    when(() => mockFavoriteBloc.state).thenReturn(const FavoriteLoaded([]));
  });

  Widget buildTestableWidget() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FavoriteBloc>.value(value: mockFavoriteBloc),
        BlocProvider<AudioPlayerBloc>.value(value: mockAudioPlayerBloc),
      ],
      child: const MaterialApp(home: PlayerScreen()),
    );
  }

  testWidgets('shows No Audio Playing when surah is null', (WidgetTester tester) async {
    when(() => mockAudioPlayerBloc.state).thenReturn(const AudioPlayerState(currentSurah: null));

    await tester.pumpWidget(buildTestableWidget());
    expect(find.text('No Audio Playing'), findsOneWidget);
  });

  testWidgets('shows player UI when audio is playing', (WidgetTester tester) async {
    const surah = SurahModel(number: 1, name: 'Al-Fatihah', englishName: 'Al-Fatihah');
    const qari = EditionModel(identifier: 'ar.alafasy', name: 'Alafasy', englishName: 'Alafasy');

    when(() => mockAudioPlayerBloc.state).thenReturn(const AudioPlayerState(
      currentSurah: surah,
      currentQari: qari,
      isPlaying: true,
      totalDuration: Duration(seconds: 100),
      currentPosition: Duration(seconds: 50),
    ));

    await tester.pumpWidget(buildTestableWidget());

    expect(find.text('Al-Fatihah'), findsOneWidget);
    expect(find.text('Alafasy'), findsOneWidget);
    
    // Play/Pause button should show pause icon because isPlaying is true
    expect(find.byIcon(Icons.pause), findsOneWidget);
    expect(find.byIcon(Icons.play_arrow), findsNothing);
  });

  testWidgets('shows play button when paused', (WidgetTester tester) async {
    const surah = SurahModel(number: 1, name: 'Al-Fatihah', englishName: 'Al-Fatihah');
    const qari = EditionModel(identifier: 'ar.alafasy', name: 'Alafasy', englishName: 'Alafasy');

    when(() => mockAudioPlayerBloc.state).thenReturn(const AudioPlayerState(
      currentSurah: surah,
      currentQari: qari,
      isPlaying: false,
    ));

    await tester.pumpWidget(buildTestableWidget());

    expect(find.byIcon(Icons.play_arrow), findsOneWidget);
    expect(find.byIcon(Icons.pause), findsNothing);
  });
}
