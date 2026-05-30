import 'package:equatable/equatable.dart';

import '../../../data/models/edition_model.dart';
import '../../../data/models/surah_model.dart';

abstract class QuranState extends Equatable {
  const QuranState();

  @override
  List<Object?> get props => [];
}

class QuranInitial extends QuranState {}

class QuranLoading extends QuranState {}

class QuranLoaded extends QuranState {
  final List<SurahModel> allSurahs;
  final List<EditionModel> allQaris;
  final List<SurahModel> filteredSurahs;
  final List<EditionModel> filteredQaris;
  final String searchQuery;

  const QuranLoaded({
    required this.allSurahs,
    required this.allQaris,
    required this.filteredSurahs,
    required this.filteredQaris,
    this.searchQuery = '',
  });

  QuranLoaded copyWith({
    List<SurahModel>? allSurahs,
    List<EditionModel>? allQaris,
    List<SurahModel>? filteredSurahs,
    List<EditionModel>? filteredQaris,
    String? searchQuery,
  }) {
    return QuranLoaded(
      allSurahs: allSurahs ?? this.allSurahs,
      allQaris: allQaris ?? this.allQaris,
      filteredSurahs: filteredSurahs ?? this.filteredSurahs,
      filteredQaris: filteredQaris ?? this.filteredQaris,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
        allSurahs,
        allQaris,
        filteredSurahs,
        filteredQaris,
        searchQuery,
      ];
}

class QuranError extends QuranState {
  final String message;

  const QuranError(this.message);

  @override
  List<Object> get props => [message];
}
