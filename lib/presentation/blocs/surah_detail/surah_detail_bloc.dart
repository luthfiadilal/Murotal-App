import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/quran_repository.dart';
import 'surah_detail_event.dart';
import 'surah_detail_state.dart';

class SurahDetailBloc extends Bloc<SurahDetailEvent, SurahDetailState> {
  final QuranRepository repository;

  SurahDetailBloc({required this.repository}) : super(SurahDetailInitial()) {
    on<FetchSurahDetail>(_onFetchSurahDetail);
  }

  Future<void> _onFetchSurahDetail(
    FetchSurahDetail event,
    Emitter<SurahDetailState> emit,
  ) async {
    emit(SurahDetailLoading());
    try {
      final surah = await repository.getSurahDetails(event.surahNumber);
      emit(SurahDetailLoaded(surah));
    } catch (e) {
      emit(SurahDetailError(e.toString()));
    }
  }
}
