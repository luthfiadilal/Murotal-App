import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:alquran/data/repositories/quran_repository.dart';
import 'package:alquran/data/models/surah_model.dart';
import 'package:alquran/data/models/edition_model.dart';
import 'package:alquran/presentation/blocs/quran/quran_bloc.dart';
import 'package:alquran/presentation/blocs/quran/quran_event.dart';
import 'package:alquran/presentation/blocs/quran/quran_state.dart';

class MockQuranRepository extends Mock implements QuranRepository {}

void main() {
  late MockQuranRepository mockRepository;
  late QuranBloc quranBloc;

  setUp(() {
    mockRepository = MockQuranRepository();
    quranBloc = QuranBloc(repository: mockRepository);
  });

  tearDown(() {
    quranBloc.close();
  });

  group('QuranBloc Tests', () {
    final surahs = [
      const SurahModel(number: 1, name: "Al-Fatihah", englishName: "Al-Fatihah"),
      const SurahModel(number: 2, name: "Al-Baqarah", englishName: "Al-Baqarah"),
    ];
    final qaris = [
      const EditionModel(identifier: "ar.alafasy", name: "Alafasy"),
    ];

    test('initial state is QuranInitial', () {
      expect(quranBloc.state, isA<QuranInitial>());
    });

    blocTest<QuranBloc, QuranState>(
      'emits [QuranLoading, QuranLoaded] when FetchInitialData succeeds',
      build: () {
        when(() => mockRepository.getAllSurahs()).thenAnswer((_) async => surahs);
        when(() => mockRepository.getAudioEditions()).thenAnswer((_) async => qaris);
        return quranBloc;
      },
      act: (bloc) => bloc.add(FetchInitialData()),
      expect: () => [
        isA<QuranLoading>(),
        isA<QuranLoaded>()
            .having((s) => s.allSurahs.length, 'surahs length', 2)
            .having((s) => s.allQaris.length, 'qaris length', 1),
      ],
    );

    blocTest<QuranBloc, QuranState>(
      'emits [QuranLoading, QuranError] when FetchInitialData fails',
      build: () {
        when(() => mockRepository.getAllSurahs()).thenThrow(Exception('Error'));
        when(() => mockRepository.getAudioEditions()).thenThrow(Exception('Error'));
        return quranBloc;
      },
      act: (bloc) => bloc.add(FetchInitialData()),
      expect: () => [
        isA<QuranLoading>(),
        isA<QuranError>(),
      ],
    );
  });
}
