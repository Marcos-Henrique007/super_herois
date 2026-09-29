import 'package:freezed_annotation/freezed_annotation.dart';

part 'hero.freezed.dart';

@freezed
abstract class Hero with _$Hero {
  const factory Hero({

    //Identificação:
    required int id,
    required String name,
    required String slug,

    //Imagens:
    required String image,
    required String largeImage,

    //Atributos:
    required int intelligence,
    required int strength,
    required int speed,
    required int durability,
    required int power,
    required int combat,

    //Aparência:
    required String gender,
    required String race,
    required List<String> height,
    required List<String> weight,
    required String eyeColor,
    required String hairColor,

    //Biografia:
    required String fullName,
    required String alterEgos,
    required List<String> aliases,
    required String placeOfBirth,
    required String firstAppearance,
    required String publisher,
    required String alignment,

    //Trabalho:
    required String occupation,
    required String base,

    //Conexões:
    required String groupAffiliation,
    required String relatives,

  }) = _Hero;
}