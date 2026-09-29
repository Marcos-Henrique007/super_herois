import 'package:freezed_annotation/freezed_annotation.dart';

part 'hero.freezed.dart';

// Modelo principal usado pelas telas e regras de negócio do aplicativo.
@freezed
abstract class Hero with _$Hero {
  const factory Hero({
    // Dados de identificação.
    required int id,
    required String name,
    required String image,

    // Atributos utilizados nas missões.
    required int intelligence,
    required int strength,
    required int speed,
    required int durability,
    required int power,
    required int combat,

    // Informações físicas.
    required String gender,
    required String race,
    required List<String> height,
    required List<String> weight,
  }) = _Hero;
}