import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:alquran/core/network/api_service.dart';
import 'package:alquran/data/repositories/quran_repository.dart';
import 'package:dio/dio.dart';
import 'package:alquran/data/models/surah_model.dart';
import 'package:alquran/data/models/edition_model.dart';

class MockApiService extends Mock implements ApiService {}

void main() {
  late MockApiService mockApiService;
  late QuranRepository quranRepository;

  setUp(() {
    mockApiService = MockApiService();
    quranRepository = QuranRepository(apiService: mockApiService);
  });

  group('QuranRepository Tests', () {
    test('getAllSurahs should return list of SurahModel on success', () async {
      when(() => mockApiService.getAllSurahs()).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          data: {
            "code": 200,
            "status": "OK",
            "data": [
              {"number": 1, "name": "Al-Fatihah"}
            ],
          },
        ),
      );

      final result = await quranRepository.getAllSurahs();

      expect(result, isA<List<SurahModel>>());
      expect(result.length, 1);
      expect(result.first.number, 1);
      verify(() => mockApiService.getAllSurahs()).called(1);
    });

    test('getAudioEditions should return list of EditionModel on success', () async {
      when(() => mockApiService.getEditions()).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          data: {
            "code": 200,
            "status": "OK",
            "data": [
              {"identifier": "ar.alafasy", "format": "audio"}
            ],
          },
        ),
      );

      final result = await quranRepository.getAudioEditions();

      expect(result, isA<List<EditionModel>>());
      expect(result.length, 1);
      expect(result.first.identifier, "ar.alafasy");
      verify(() => mockApiService.getEditions()).called(1);
    });

    test('getAllSurahs should throw exception on error', () async {
      when(() => mockApiService.getAllSurahs()).thenThrow(Exception('Failed to fetch'));

      expect(() => quranRepository.getAllSurahs(), throwsException);
    });
  });
}
