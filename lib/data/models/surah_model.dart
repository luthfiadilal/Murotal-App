import 'package:equatable/equatable.dart';

import 'ayah_model.dart';
import 'edition_model.dart';

class SurahModel extends Equatable {
  final int? number;
  final String? name;
  final String? englishName;
  final String? englishNameTranslation;
  final String? revelationType;
  final int? numberOfAyahs;
  final List<AyahModel>? ayahs;
  final EditionModel? edition;

  const SurahModel({
    this.number,
    this.name,
    this.englishName,
    this.englishNameTranslation,
    this.revelationType,
    this.numberOfAyahs,
    this.ayahs,
    this.edition,
  });

  factory SurahModel.fromJson(Map<String, dynamic> json) {
    return SurahModel(
      number: json['number'] as int?,
      name: json['name'] as String?,
      englishName: json['englishName'] as String?,
      englishNameTranslation: json['englishNameTranslation'] as String?,
      revelationType: json['revelationType'] as String?,
      numberOfAyahs: json['numberOfAyahs'] as int?,
      ayahs: (json['ayahs'] as List<dynamic>?)
          ?.map((e) => AyahModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      edition: json['edition'] != null
          ? EditionModel.fromJson(json['edition'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'name': name,
      'englishName': englishName,
      'englishNameTranslation': englishNameTranslation,
      'revelationType': revelationType,
      'numberOfAyahs': numberOfAyahs,
      'ayahs': ayahs?.map((e) => e.toJson()).toList(),
      'edition': edition?.toJson(),
    };
  }

  @override
  List<Object?> get props => [
        number,
        name,
        englishName,
        englishNameTranslation,
        revelationType,
        numberOfAyahs,
        ayahs,
        edition,
      ];
}
