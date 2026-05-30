import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:alquran/presentation/blocs/quran/quran_bloc.dart';
import 'package:alquran/presentation/blocs/quran/quran_event.dart';
import 'package:alquran/presentation/blocs/quran/quran_state.dart';
import 'package:alquran/presentation/blocs/audio_player/audio_player_bloc.dart';
import 'package:alquran/presentation/blocs/audio_player/audio_player_event.dart';
import 'package:alquran/presentation/blocs/audio_player/audio_player_state.dart';
import 'package:alquran/presentation/blocs/favorite/favorite_bloc.dart';
import 'package:alquran/presentation/blocs/favorite/favorite_event.dart';
import 'package:alquran/presentation/blocs/favorite/favorite_state.dart';
import 'package:alquran/presentation/screens/main_screen.dart';

class MockQuranBloc extends MockBloc<QuranEvent, QuranState> implements QuranBloc {}
class MockAudioPlayerBloc extends MockBloc<AudioPlayerEvent, AudioPlayerState> implements AudioPlayerBloc {}
class MockFavoriteBloc extends MockBloc<FavoriteEvent, FavoriteState> implements FavoriteBloc {}
class FakeQuranEvent extends Fake implements QuranEvent {}
class FakeAudioPlayerEvent extends Fake implements AudioPlayerEvent {}
class FakeFavoriteEvent extends Fake implements FavoriteEvent {}

void main() {
  late MockQuranBloc mockQuranBloc;
  late MockAudioPlayerBloc mockAudioPlayerBloc;
  late MockFavoriteBloc mockFavoriteBloc;

  setUpAll(() {
    registerFallbackValue(FakeQuranEvent());
    registerFallbackValue(FakeAudioPlayerEvent());
    registerFallbackValue(FakeFavoriteEvent());
  });

  setUp(() {
    mockQuranBloc = MockQuranBloc();
    mockAudioPlayerBloc = MockAudioPlayerBloc();
    mockFavoriteBloc = MockFavoriteBloc();

    when(() => mockQuranBloc.state).thenReturn(QuranInitial());
    when(() => mockAudioPlayerBloc.state).thenReturn(const AudioPlayerState());
    when(() => mockFavoriteBloc.state).thenReturn(FavoriteInitial());
  });

  Widget buildTestableWidget() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<QuranBloc>.value(value: mockQuranBloc),
        BlocProvider<AudioPlayerBloc>.value(value: mockAudioPlayerBloc),
        BlocProvider<FavoriteBloc>.value(value: mockFavoriteBloc),
      ],
      child: const MaterialApp(home: MainScreen()),
    );
  }

  testWidgets('bottom navigation changes tabs correctly', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableWidget());

    // Initially on Home Tab
    expect(find.text('Al-Quran'), findsOneWidget); // AppBar title in HomeScreen

    // Tap on Search Tab
    await tester.tap(find.text('Search').last);
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsOneWidget); // Search input in SearchScreen

    // Tap on Library Tab
    await tester.tap(find.text('Your Library').last);
    await tester.pumpAndSettle();

    expect(find.text('Your Library'), findsWidgets); // AppBar title in FavoritesScreen
  });
}
