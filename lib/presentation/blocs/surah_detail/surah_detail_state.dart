import 'package:equatable/equatable.dart';
import '../../../data/models/surah_model.dart';

abstract class SurahDetailState extends Equatable {
  const SurahDetailState();
  
  @override
  List<Object?> get props => [];
}

class SurahDetailInitial extends SurahDetailState {}

class SurahDetailLoading extends SurahDetailState {}

class SurahDetailLoaded extends SurahDetailState {
  final SurahModel surah;

  const SurahDetailLoaded(this.surah);

  @override
  List<Object?> get props => [surah];
}

class SurahDetailError extends SurahDetailState {
  final String message;

  const SurahDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
