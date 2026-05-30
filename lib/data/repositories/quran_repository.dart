import 'package:dio/dio.dart';

import '../../core/network/api_service.dart';
import '../models/api_response.dart';
import '../models/edition_model.dart';
import '../models/surah_model.dart';

class QuranRepository {
  final ApiService _apiService;

  QuranRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  /// Mengambil daftar semua Qari (berdasarkan format = 'audio')
  Future<List<EditionModel>> getAudioEditions() async {
    try {
      final response = await _apiService.getEditions();
      final apiResponse = ApiResponse<List<dynamic>>.fromJson(
        response.data,
        (data) => data as List<dynamic>,
      );

      final editions = apiResponse.data
          .map((e) => EditionModel.fromJson(e as Map<String, dynamic>))
          .where((edition) => edition.format == 'audio')
          .toList();

      return editions;
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Failed to fetch audio editions');
    }
  }

  /// Mengambil metadata seluruh 114 Surah
  Future<List<SurahModel>> getAllSurahs() async {
    try {
      final response = await _apiService.getAllSurahs();
      final apiResponse = ApiResponse<List<dynamic>>.fromJson(
        response.data,
        (data) => data as List<dynamic>,
      );

      final surahs = apiResponse.data
          .map((e) => SurahModel.fromJson(e as Map<String, dynamic>))
          .toList();

      return surahs;
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Failed to fetch surahs');
    }
  }
}
