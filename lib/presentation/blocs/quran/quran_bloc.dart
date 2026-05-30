import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/quran_repository.dart';
import 'quran_event.dart';
import 'quran_state.dart';

/// `QuranBloc` bertanggung jawab untuk mengelola data utama Al-Quran di dalam memori.
/// BLoC ini memuat daftar Surah dan daftar Qari saat aplikasi pertama kali dibuka,
/// dan menyediakan logika pencarian (Search) untuk memfilter data tersebut.
class QuranBloc extends Bloc<QuranEvent, QuranState> {
  final QuranRepository repository;

  QuranBloc({required this.repository}) : super(QuranInitial()) {
    on<FetchInitialData>(_onFetchInitialData);
    on<SearchQuran>(_onSearchQuran);
  }

  /// Event Handler untuk `FetchInitialData`.
  /// Dipanggil sekali saat aplikasi mulai (biasanya di main.dart atau SplashScreen).
  /// Mengambil data dari `QuranRepository` secara paralel untuk mempercepat waktu tunggu.
  Future<void> _onFetchInitialData(
    FetchInitialData event,
    Emitter<QuranState> emit,
  ) async {
    emit(QuranLoading());
    try {
      final surahs = await repository.getAllSurahs();
      final qaris = await repository.getAudioEditions();

      emit(QuranLoaded(
        allSurahs: surahs,
        allQaris: qaris,
        filteredSurahs: surahs,
        filteredQaris: qaris,
      ));
    } catch (e) {
      emit(QuranError(e.toString()));
    }
  }

  /// Event Handler untuk `SearchQuran`.
  /// Fungsi ini tidak melakukan pemanggilan API baru (karena pencarian dilakukan secara lokal / offline)
  /// dengan mencocokkan teks `query` terhadap nama Surah dan nama Qari.
  void _onSearchQuran(
    SearchQuran event,
    Emitter<QuranState> emit,
  ) {
    if (state is QuranLoaded) {
      final currentState = state as QuranLoaded;
      final query = event.query.toLowerCase();

      final filteredSurahs = currentState.allSurahs.where((surah) {
        final englishName = surah.englishName?.toLowerCase() ?? '';
        final name = surah.name?.toLowerCase() ?? '';
        return englishName.contains(query) || name.contains(query);
      }).toList();

      final filteredQaris = currentState.allQaris.where((qari) {
        final englishName = qari.englishName?.toLowerCase() ?? '';
        final name = qari.name?.toLowerCase() ?? '';
        final identifier = qari.identifier?.toLowerCase() ?? '';
        return englishName.contains(query) ||
            name.contains(query) ||
            identifier.contains(query);
      }).toList();

      emit(currentState.copyWith(
        filteredSurahs: filteredSurahs,
        filteredQaris: filteredQaris,
        searchQuery: event.query,
      ));
    }
  }
}
