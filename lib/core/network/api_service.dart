import 'package:dio/dio.dart';

/// Class `ApiService` bertanggung jawab untuk mengatur semua komunikasi dengan API.
/// Kita menggunakan package `dio` karena fiturnya yang lengkap untuk HTTP request (seperti interceptor, timeout, dsb).
class ApiService {
  final Dio _dio;

  /// Constructor `ApiService`.
  /// Jika instance `Dio` tidak diberikan saat inisiasi, maka akan membuat instance `Dio` baru
  /// dengan konfigurasi dasar (BaseOptions) seperti `baseUrl` dan pengaturan `timeout`.
  ApiService({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              // URL dasar (Base URL) untuk semua request teks Al-Quran
              baseUrl: 'https://api.alquran.cloud/v1',
              // Batas waktu maksimal saat mencoba terhubung ke server (10 detik)
              connectTimeout: const Duration(seconds: 10),
              // Batas waktu maksimal saat menunggu respons dari server (10 detik)
              receiveTimeout: const Duration(seconds: 10),
            ),
          );

  /// Endpoint: `GET /edition`
  /// Mengambil daftar semua edisi teks dan audio Al-Quran yang tersedia di API.
  /// Contoh: Untuk mendapatkan identifier bahasa atau qori (pembaca) tertentu.
  Future<Response> getEditions() async {
    try {
      final response = await _dio.get('/edition');
      return response;
    } catch (e) {
      // Jika terjadi error (misalnya tidak ada internet), kita lempar errornya agar bisa ditangkap oleh BLoC/Repository.
      rethrow;
    }
  }

  Future<Response> getEditionsType(String language, String type) async {
    try {
      final response = await _dio.get(
        '/edition?format=audio&language=$language&type=$type',
      );
      return response;
    } catch (e) {
      // Jika terjadi error (misalnya tidak ada internet), kita lempar errornya agar bisa ditangkap oleh BLoC/Repository.
      rethrow;
    }
  }

  /// Endpoint: `GET /quran/{edition}`
  /// Mengambil data lengkap Al-Quran (seluruh surah dan ayat) berdasarkan edisi tertentu.
  /// Parameter [edition] diisi dengan identifier (misal: 'en.asad' untuk terjemahan Inggris).
  Future<Response> getQuran(String edition) async {
    try {
      final response = await _dio.get('/quran/$edition');
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Endpoint: `GET /surah/{surahNumber}/{edition}`
  /// Mengambil data detail satu Surah beserta ayat-ayatnya dengan edisi tertentu (misal bacaan/terjemahan spesifik).
  /// Parameter:
  /// - [surahNumber]: Nomor surah (1 - 114)
  /// - [edition]: Identifier edisi (misal 'ar.alafasy' untuk audio, atau 'id.indonesian' untuk teks terjemahan)
  Future<Response> getSurahWithEdition(int surahNumber, String edition) async {
    try {
      final response = await _dio.get('/surah/$surahNumber/$edition');
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Endpoint: `GET /surah/{surahNumber}`
  /// Mengambil data detail satu Surah beserta ayat-ayatnya menggunakan edisi teks default dari API.
  /// Parameter [surahNumber] diisi dengan nomor surah (1 - 114).
  Future<Response> getSurah(int surahNumber) async {
    try {
      final response = await _dio.get('/surah/$surahNumber');
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Endpoint: `GET /surah`
  /// Mengambil daftar seluruh surah (1-114) berupa metadatanya.
  Future<Response> getAllSurahs() async {
    try {
      final response = await _dio.get('/surah');
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Fungsi bantuan untuk mem-build URL file MP3.
  /// Karena pemutar musik (audioplayers) biasanya membutuhkan URL langsung ke file `.mp3`,
  /// kita tidak perlu me-request ini melalui `dio`, melainkan langsung mereturn String URL-nya.
  ///
  /// Parameter:
  /// - [surahNumber]: Nomor surah yang ingin diputar (1 - 114)
  /// - [edition]: Identifier qori, default menggunakan Mishary Rashid Alafasy ('ar.alafasy')
  /// - [bitrate]: Kualitas audio (64 atau 128 kbps), default 128 kbps.
  String getSurahAudioUrl({
    required int surahNumber,
    String edition = 'ar.alafasy',
    int bitrate = 128,
  }) {
    // Struktur URL mengacu pada format CDN Network:
    // https://cdn.islamic.network/quran/audio-surah/{bitrate}/{edition}/{surah_number}.mp3
    return 'https://cdn.islamic.network/quran/audio-surah/$bitrate/$edition/$surahNumber.mp3';
  }
}
