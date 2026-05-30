import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:alquran/data/models/surah_model.dart';
import 'package:alquran/presentation/blocs/quran/quran_bloc.dart';
import 'package:alquran/presentation/blocs/quran/quran_event.dart';
import 'package:alquran/presentation/blocs/quran/quran_state.dart';
import 'package:alquran/presentation/blocs/audio_player/audio_player_bloc.dart';
import 'package:alquran/presentation/blocs/audio_player/audio_player_event.dart';
import 'package:alquran/presentation/blocs/audio_player/audio_player_state.dart';
import 'package:alquran/presentation/screens/search_screen.dart';

class MockQuranBloc extends MockBloc<QuranEvent, QuranState> implements QuranBloc {}
class MockAudioPlayerBloc extends MockBloc<AudioPlayerEvent, AudioPlayerState> implements AudioPlayerBloc {}
class FakeAudioPlayerEvent extends Fake implements AudioPlayerEvent {}
class FakeQuranEvent extends Fake implements QuranEvent {}

void main() {
  late MockQuranBloc mockQuranBloc;
  late MockAudioPlayerBloc mockAudioPlayerBloc;

  setUpAll(() {
    registerFallbackValue(FakeAudioPlayerEvent());
    registerFallbackValue(FakeQuranEvent());
  });

  setUp(() {
    mockQuranBloc = MockQuranBloc();
    mockAudioPlayerBloc = MockAudioPlayerBloc();
    when(() => mockAudioPlayerBloc.state).thenReturn(const AudioPlayerState());
  });

  Widget buildTestableWidget() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<QuranBloc>.value(value: mockQuranBloc),
        BlocProvider<AudioPlayerBloc>.value(value: mockAudioPlayerBloc),
      ],
      child: const MaterialApp(home: SearchScreen()),
    );
  }

  testWidgets('shows No results found when filtered list is empty', (WidgetTester tester) async {
    when(() => mockQuranBloc.state).thenReturn(const QuranLoaded(
      allSurahs: [],
      allQaris: [],
      filteredSurahs: [],
      filteredQaris: [],
    ));

    await tester.pumpWidget(buildTestableWidget());
    expect(find.text('No results found'), findsOneWidget);
  });

  testWidgets('shows list of surahs when filtered list has items', (WidgetTester tester) async {
    when(() => mockQuranBloc.state).thenReturn(const QuranLoaded(
      allSurahs: [],
      allQaris: [],
      filteredSurahs: [
        SurahModel(number: 2, name: 'Al-Baqarah', englishName: 'Al-Baqarah', englishNameTranslation: 'The Cow'),
      ],
      filteredQaris: [],
    ));

    await tester.pumpWidget(buildTestableWidget());
    expect(find.text('Al-Baqarah'), findsWidgets);
    expect(find.byType(ListTile), findsOneWidget);
  });

  testWidgets('triggers SearchQuran event when typing in text field', (WidgetTester tester) async {
    when(() => mockQuranBloc.state).thenReturn(const QuranLoaded(
      allSurahs: [], allQaris: [], filteredSurahs: [], filteredQaris: [],
    ));

    await tester.pumpWidget(buildTestableWidget());
    
    await tester.enterText(find.byType(TextField), 'Fatiha');
    verify(() => mockQuranBloc.add(any(that: isA<SearchQuran>()))).called(1);
  });
}
