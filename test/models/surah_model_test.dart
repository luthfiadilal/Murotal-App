import 'package:flutter_test/flutter_test.dart';
import 'package:alquran/data/models/surah_model.dart';

void main() {
  group('SurahModel Test', () {
    final Map<String, dynamic> jsonMap = {
      "number": 1,
      "name": "سُورَةُ ٱلْفَاتِحَةِ",
      "englishName": "Al-Faatiha",
      "englishNameTranslation": "The Opening",
      "numberOfAyahs": 7,
      "revelationType": "Meccan"
    };

    test('should return a valid model from JSON', () {
      final result = SurahModel.fromJson(jsonMap);

      expect(result.number, 1);
      expect(result.name, "سُورَةُ ٱلْفَاتِحَةِ");
      expect(result.englishName, "Al-Faatiha");
      expect(result.englishNameTranslation, "The Opening");
      expect(result.numberOfAyahs, 7);
      expect(result.revelationType, "Meccan");
    });

    test('should return a JSON map containing proper data', () {
      final model = SurahModel.fromJson(jsonMap);
      final result = model.toJson();

      expect(result['number'], 1);
      expect(result['name'], "سُورَةُ ٱلْفَاتِحَةِ");
      expect(result['englishName'], "Al-Faatiha");
      expect(result['englishNameTranslation'], "The Opening");
      expect(result['numberOfAyahs'], 7);
      expect(result['revelationType'], "Meccan");
    });

    test('Equatable props should match', () {
      final model1 = SurahModel.fromJson(jsonMap);
      final model2 = SurahModel.fromJson(jsonMap);

      expect(model1, equals(model2));
    });
  });
}
