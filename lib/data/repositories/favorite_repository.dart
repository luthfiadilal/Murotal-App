import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/favorite_item_model.dart';

class FavoriteRepository {
  static const String _favoritesKey = 'favorites_playlist';

  Future<List<FavoriteItemModel>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String? favoritesJson = prefs.getString(_favoritesKey);

    if (favoritesJson != null) {
      final List<dynamic> decoded = jsonDecode(favoritesJson);
      return decoded
          .map((item) =>
              FavoriteItemModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<void> saveFavorite(FavoriteItemModel item) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();

    if (!favorites.any((fav) => fav.id == item.id)) {
      favorites.add(item);
      final String encoded =
          jsonEncode(favorites.map((e) => e.toJson()).toList());
      await prefs.setString(_favoritesKey, encoded);
    }
  }

  Future<void> removeFavorite(FavoriteItemModel item) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();

    favorites.removeWhere((fav) => fav.id == item.id);
    final String encoded =
        jsonEncode(favorites.map((e) => e.toJson()).toList());
    await prefs.setString(_favoritesKey, encoded);
  }

  Future<bool> isFavorite(FavoriteItemModel item) async {
    final favorites = await getFavorites();
    return favorites.any((fav) => fav.id == item.id);
  }
}
