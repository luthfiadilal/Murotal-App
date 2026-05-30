import 'package:flutter_test/flutter_test.dart';
import 'package:alquran/data/models/edition_model.dart';

void main() {
  group('EditionModel Test', () {
    final Map<String, dynamic> jsonMap = {
      "identifier": "ar.alafasy",
      "language": "ar",
      "name": "Alafasy",
      "englishName": "Alafasy",
      "format": "audio",
      "type": "versebyverse",
      "direction": "ltr"
    };

    test('should return a valid model from JSON', () {
      final result = EditionModel.fromJson(jsonMap);

      expect(result.identifier, "ar.alafasy");
      expect(result.language, "ar");
      expect(result.name, "Alafasy");
      expect(result.englishName, "Alafasy");
      expect(result.format, "audio");
      expect(result.type, "versebyverse");
    });

    test('should return a JSON map containing proper data', () {
      final model = EditionModel.fromJson(jsonMap);
      final result = model.toJson();

      // We only test the mapped keys
      expect(result['identifier'], "ar.alafasy");
      expect(result['language'], "ar");
      expect(result['name'], "Alafasy");
      expect(result['englishName'], "Alafasy");
      expect(result['format'], "audio");
      expect(result['type'], "versebyverse");
    });
  });
}
