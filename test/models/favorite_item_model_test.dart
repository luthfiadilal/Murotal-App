import 'package:flutter_test/flutter_test.dart';
import 'package:alquran/data/models/favorite_item_model.dart';
import 'package:alquran/data/models/surah_model.dart';
import 'package:alquran/data/models/edition_model.dart';

void main() {
  group('FavoriteItemModel Test', () {
    final Map<String, dynamic> jsonMap = {
      "surah": {
        "number": 1,
        "name": "Al-Fatihah"
      },
      "qari": {
        "identifier": "ar.alafasy",
        "name": "Alafasy"
      }
    };

    test('should return a valid model from JSON', () {
      final result = FavoriteItemModel.fromJson(jsonMap);

      expect(result.surah.number, 1);
      expect(result.qari.identifier, "ar.alafasy");
      expect(result.id, "1_ar.alafasy");
    });

    test('should return a JSON map containing proper data', () {
      final model = FavoriteItemModel(
        surah: const SurahModel(number: 1, name: "Al-Fatihah"),
        qari: const EditionModel(identifier: "ar.alafasy", name: "Alafasy"),
      );
      
      final result = model.toJson();

      expect(result['surah']['number'], 1);
      expect(result['qari']['identifier'], "ar.alafasy");
    });
  });
}
