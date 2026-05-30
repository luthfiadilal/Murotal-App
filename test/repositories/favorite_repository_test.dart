import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:alquran/data/repositories/favorite_repository.dart';
import 'package:alquran/data/models/favorite_item_model.dart';
import 'package:alquran/data/models/surah_model.dart';
import 'package:alquran/data/models/edition_model.dart';

void main() {
  late FavoriteRepository favoriteRepository;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    favoriteRepository = FavoriteRepository();
  });

  group('FavoriteRepository Tests', () {
    final item = FavoriteItemModel(
      surah: const SurahModel(number: 1, name: "Al-Fatihah"),
      qari: const EditionModel(identifier: "ar.alafasy", name: "Alafasy"),
    );

    test('getFavorites should initially return empty list', () async {
      final result = await favoriteRepository.getFavorites();
      expect(result.isEmpty, true);
    });

    test('saveFavorite should add item to shared preferences', () async {
      await favoriteRepository.saveFavorite(item);
      final result = await favoriteRepository.getFavorites();
      
      expect(result.length, 1);
      expect(result.first.id, item.id);
    });

    test('removeFavorite should remove item from shared preferences', () async {
      await favoriteRepository.saveFavorite(item);
      await favoriteRepository.removeFavorite(item);
      final result = await favoriteRepository.getFavorites();
      
      expect(result.isEmpty, true);
    });

    test('isFavorite should return true if item exists', () async {
      await favoriteRepository.saveFavorite(item);
      final isFav = await favoriteRepository.isFavorite(item);
      
      expect(isFav, true);
    });
  });
}
