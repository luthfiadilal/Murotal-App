import 'package:equatable/equatable.dart';

import 'edition_model.dart';
import 'surah_model.dart';

class FavoriteItemModel extends Equatable {
  final SurahModel surah;
  final EditionModel qari;

  const FavoriteItemModel({
    required this.surah,
    required this.qari,
  });

  factory FavoriteItemModel.fromJson(Map<String, dynamic> json) {
    return FavoriteItemModel(
      surah: SurahModel.fromJson(json['surah'] as Map<String, dynamic>),
      qari: EditionModel.fromJson(json['qari'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'surah': surah.toJson(),
      'qari': qari.toJson(),
    };
  }

  /// Unique identifier based on surah number and qari identifier
  String get id => '${surah.number}_${qari.identifier}';

  @override
  List<Object?> get props => [surah, qari];
}
