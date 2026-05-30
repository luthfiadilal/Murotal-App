import 'package:dio/dio.dart';

import '../../core/network/api_service.dart';
import '../models/api_response.dart';
import '../models/edition_model.dart';
import '../models/surah_model.dart';

/// Class `QuranRepository` berfungsi sebagai jembatan (penghubung) antara sumber data (API)
/// dengan lapisan State Management (BLoC).
/// Repository bertugas memanggil fungsi dari `ApiService`, lalu memparsing JSON mentah
/// menjadi Model Data yang terstruktur seperti `SurahModel` dan `EditionModel`.
class QuranRepository {
  final ApiService _apiService;

  QuranRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  /// Mengambil daftar semua Qari (berdasarkan format = 'audio').
  /// Fungsi ini mengambil data mentah dari endpoint `/edition`, lalu memfilter
  /// hanya edisi yang memiliki format 'audio', sehingga kita mendapatkan daftar pembaca (Qari).
  /// Mengembalikan `List<EditionModel>`.
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

  /// Mengambil metadata seluruh 114 Surah.
  /// Memanggil endpoint `/surah` untuk mendapatkan kerangka awal Surah 
  /// (seperti nama Arab, nama Inggris, nomor, jumlah ayat, tanpa lirik ayatnya).
  /// Ini sangat berguna untuk ditampilkan di daftar menu utama karena ringan.
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

  /// Mengambil detail satu Surah beserta ayat-ayatnya.
  /// Jika pengguna membuka Surah tertentu untuk membaca lirik, fungsi ini memanggil `/surah/{nomor}`.
  /// Parameter [surahNumber] diisi dengan nomor surah yang ingin dimuat.
  Future<SurahModel> getSurahDetails(int surahNumber) async {
    try {
      final response = await _apiService.getSurah(surahNumber);
      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );

      return SurahModel.fromJson(apiResponse.data);
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Failed to fetch surah details');
    }
  }
}
