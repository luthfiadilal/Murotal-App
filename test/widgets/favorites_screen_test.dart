import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:alquran/data/models/favorite_item_model.dart';
import 'package:alquran/data/models/surah_model.dart';
import 'package:alquran/data/models/edition_model.dart';
import 'package:alquran/presentation/blocs/favorite/favorite_bloc.dart';
import 'package:alquran/presentation/blocs/favorite/favorite_event.dart';
import 'package:alquran/presentation/blocs/favorite/favorite_state.dart';
import 'package:alquran/presentation/blocs/audio_player/audio_player_bloc.dart';
import 'package:alquran/presentation/blocs/audio_player/audio_player_event.dart';
import 'package:alquran/presentation/blocs/audio_player/audio_player_state.dart';
import 'package:alquran/presentation/screens/favorites_screen.dart';

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
    when(() => mockAudioPlayerBloc.state).thenReturn(const AudioPlayerState());
  });

  Widget buildTestableWidget() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FavoriteBloc>.value(value: mockFavoriteBloc),
        BlocProvider<AudioPlayerBloc>.value(value: mockAudioPlayerBloc),
      ],
      child: const MaterialApp(home: FavoritesScreen()),
    );
  }

  testWidgets('shows empty message when favorites list is empty', (WidgetTester tester) async {
    when(() => mockFavoriteBloc.state).thenReturn(const FavoriteLoaded([]));

    await tester.pumpWidget(buildTestableWidget());

    expect(find.textContaining('Your playlist is empty'), findsOneWidget);
  });

  testWidgets('shows list of favorites when data exists', (WidgetTester tester) async {
    final item = FavoriteItemModel(
      surah: const SurahModel(number: 1, name: 'Al-Fatihah', englishName: 'Al-Fatihah'),
      qari: const EditionModel(identifier: 'ar.alafasy', name: 'Alafasy', englishName: 'Alafasy'),
    );

    when(() => mockFavoriteBloc.state).thenReturn(FavoriteLoaded([item]));

    await tester.pumpWidget(buildTestableWidget());

    expect(find.text('Al-Fatihah'), findsWidgets);
    expect(find.text('Alafasy'), findsWidgets);
    expect(find.byType(ListTile), findsOneWidget);
  });
}
