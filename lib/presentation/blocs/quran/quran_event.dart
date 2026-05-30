import 'package:equatable/equatable.dart';

abstract class QuranEvent extends Equatable {
  const QuranEvent();

  @override
  List<Object> get props => [];
}

class FetchInitialData extends QuranEvent {}

class SearchQuran extends QuranEvent {
  final String query;

  const SearchQuran(this.query);

  @override
  List<Object> get props => [query];
}
