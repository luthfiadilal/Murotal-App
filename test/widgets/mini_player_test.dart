import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:alquran/data/models/surah_model.dart';
import 'package:alquran/data/models/edition_model.dart';
import 'package:alquran/presentation/blocs/audio_player/audio_player_bloc.dart';
import 'package:alquran/presentation/blocs/audio_player/audio_player_event.dart';
import 'package:alquran/presentation/blocs/audio_player/audio_player_state.dart';
import 'package:alquran/presentation/widgets/mini_player.dart';

class MockAudioPlayerBloc extends MockBloc<AudioPlayerEvent, AudioPlayerState> implements AudioPlayerBloc {}
class FakeAudioPlayerEvent extends Fake implements AudioPlayerEvent {}

void main() {
  late MockAudioPlayerBloc mockAudioPlayerBloc;

  setUpAll(() {
    registerFallbackValue(FakeAudioPlayerEvent());
  });

  setUp(() {
    mockAudioPlayerBloc = MockAudioPlayerBloc();
  });

  Widget buildTestableWidget() {
    return BlocProvider<AudioPlayerBloc>.value(
      value: mockAudioPlayerBloc,
      child: const MaterialApp(home: Scaffold(body: MiniPlayer())),
    );
  }

  testWidgets('renders nothing when no surah is active', (WidgetTester tester) async {
    when(() => mockAudioPlayerBloc.state).thenReturn(const AudioPlayerState(currentSurah: null));

    await tester.pumpWidget(buildTestableWidget());
    expect(find.byType(GestureDetector), findsNothing);
  });

  testWidgets('renders mini player when surah is active', (WidgetTester tester) async {
    const surah = SurahModel(number: 1, name: 'Al-Fatihah', englishName: 'Al-Fatihah');
    const qari = EditionModel(identifier: 'ar.alafasy', name: 'Alafasy', englishName: 'Alafasy');

    when(() => mockAudioPlayerBloc.state).thenReturn(const AudioPlayerState(
      currentSurah: surah,
      currentQari: qari,
      isPlaying: true,
    ));

    await tester.pumpWidget(buildTestableWidget());

    expect(find.text('Al-Fatihah'), findsOneWidget);
    expect(find.byIcon(Icons.pause), findsOneWidget);
  });
}
