import 'package:equatable/equatable.dart';

class AyahModel extends Equatable {
  final int? number;
  final String? audio;
  final List<String>? audioSecondary;
  final String? text;
  final int? numberInSurah;
  final int? juz;
  final int? manzil;
  final int? page;
  final int? ruku;
  final int? hizbQuarter;
  final dynamic sajda;

  const AyahModel({
    this.number,
    this.audio,
    this.audioSecondary,
    this.text,
    this.numberInSurah,
    this.juz,
    this.manzil,
    this.page,
    this.ruku,
    this.hizbQuarter,
    this.sajda,
  });

  factory AyahModel.fromJson(Map<String, dynamic> json) {
    return AyahModel(
      number: json['number'] as int?,
      audio: json['audio'] as String?,
      audioSecondary: (json['audioSecondary'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      text: json['text'] as String?,
      numberInSurah: json['numberInSurah'] as int?,
      juz: json['juz'] as int?,
      manzil: json['manzil'] as int?,
      page: json['page'] as int?,
      ruku: json['ruku'] as int?,
      hizbQuarter: json['hizbQuarter'] as int?,
      sajda: json['sajda'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'audio': audio,
      'audioSecondary': audioSecondary,
      'text': text,
      'numberInSurah': numberInSurah,
      'juz': juz,
      'manzil': manzil,
      'page': page,
      'ruku': ruku,
      'hizbQuarter': hizbQuarter,
      'sajda': sajda,
    };
  }

  @override
  List<Object?> get props => [
        number,
        audio,
        audioSecondary,
        text,
        numberInSurah,
        juz,
        manzil,
        page,
        ruku,
        hizbQuarter,
        sajda,
      ];
}
