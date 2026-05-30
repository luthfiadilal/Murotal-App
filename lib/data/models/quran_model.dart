import 'package:equatable/equatable.dart';

import 'edition_model.dart';
import 'surah_model.dart';

class QuranModel extends Equatable {
  final List<SurahModel>? surahs;
  final EditionModel? edition;

  const QuranModel({
    this.surahs,
    this.edition,
  });

  factory QuranModel.fromJson(Map<String, dynamic> json) {
    return QuranModel(
      surahs: (json['surahs'] as List<dynamic>?)
          ?.map((e) => SurahModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      edition: json['edition'] != null
          ? EditionModel.fromJson(json['edition'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'surahs': surahs?.map((e) => e.toJson()).toList(),
      'edition': edition?.toJson(),
    };
  }

  @override
  List<Object?> get props => [surahs, edition];
}
