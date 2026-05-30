import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:alquran/data/models/surah_model.dart';
import 'package:alquran/data/models/edition_model.dart';
import 'package:alquran/presentation/blocs/quran/quran_bloc.dart';
import 'package:alquran/presentation/blocs/quran/quran_event.dart';
import 'package:alquran/presentation/blocs/quran/quran_state.dart';
import 'package:alquran/presentation/blocs/audio_player/audio_player_bloc.dart';
import 'package:alquran/presentation/blocs/audio_player/audio_player_event.dart';
import 'package:alquran/presentation/blocs/audio_player/audio_player_state.dart';
import 'package:alquran/presentation/screens/home_screen.dart';

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
      child: const MaterialApp(home: HomeScreen()),
    );
  }

  testWidgets('shows CircularProgressIndicator when QuranLoading', (WidgetTester tester) async {
    when(() => mockQuranBloc.state).thenReturn(QuranLoading());

    await tester.pumpWidget(buildTestableWidget());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows error message when QuranError', (WidgetTester tester) async {
    when(() => mockQuranBloc.state).thenReturn(const QuranError('Error message'));

    await tester.pumpWidget(buildTestableWidget());

    expect(find.text('Error message'), findsOneWidget);
  });

  testWidgets('shows list of surahs when QuranLoaded', (WidgetTester tester) async {
    when(() => mockQuranBloc.state).thenReturn(const QuranLoaded(
      allSurahs: [
        SurahModel(number: 1, name: 'Al-Fatihah', englishName: 'Al-Fatihah', revelationType: 'Meccan', numberOfAyahs: 7),
      ],
      allQaris: [
        EditionModel(identifier: 'ar.alafasy', name: 'Alafasy'),
      ],
      filteredSurahs: [],
      filteredQaris: [],
    ));

    await tester.pumpWidget(buildTestableWidget());

    expect(find.text('Al-Fatihah'), findsWidgets);
    expect(find.byType(ListTile), findsOneWidget);
  });
}
