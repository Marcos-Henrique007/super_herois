import 'package:json_annotation/json_annotation.dart';

part 'http_paged_result.g.dart';

// Representa a resposta paginada enviada pelo json-server.
@JsonSerializable()
class HttpPagedResult {
  final int first;
  final dynamic prev;
  final dynamic next;
  final int last;
  final int pages;
  final int items;

  // Lista de heróis retornada na página atual.
  final List<HeroEntity> data;

  HttpPagedResult({
    required this.first,
    required this.prev,
    required this.next,
    required this.last,
    required this.pages,
    required this.items,
    required this.data,
  });

  // Converte o JSON da resposta para HttpPagedResult.
  factory HttpPagedResult.fromJson(Map<String, dynamic> json) =>
      _$HttpPagedResultFromJson(json);
}

// Representa um herói exatamente como ele vem da API.
@JsonSerializable()
class HeroEntity {
  final int id;
  final String name;

  // Os atributos vêm agrupados dentro de "powerstats".
  final PowerstatsEntity powerstats;

  // Informações físicas vêm dentro de "appearance".
  final AppearanceEntity appearance;

  // URLs das imagens vêm dentro de "images".
  final ImagesEntity images;

  HeroEntity({
    required this.id,
    required this.name,
    required this.powerstats,
    required this.appearance,
    required this.images,
  });

  // Converte o JSON de um herói para HeroEntity.
  factory HeroEntity.fromJson(Map<String, dynamic> json) =>
      _$HeroEntityFromJson(json);
}

// Representa os atributos de poder do herói.
@JsonSerializable()
class PowerstatsEntity {
  final int intelligence;
  final int strength;
  final int speed;
  final int durability;
  final int power;
  final int combat;

  PowerstatsEntity({
    required this.intelligence,
    required this.strength,
    required this.speed,
    required this.durability,
    required this.power,
    required this.combat,
  });

  factory PowerstatsEntity.fromJson(Map<String, dynamic> json) =>
      _$PowerstatsEntityFromJson(json);
}

// Representa as informações de aparência do herói.
@JsonSerializable()
class AppearanceEntity {
  final String gender;

  // Alguns personagens não possuem raça definida.
  final String? race;

  final List<String> height;
  final List<String> weight;

  AppearanceEntity({
    required this.gender,
    required this.race,
    required this.height,
    required this.weight,
  });

  factory AppearanceEntity.fromJson(Map<String, dynamic> json) =>
      _$AppearanceEntityFromJson(json);
}

// Guarda as diferentes resoluções das imagens do herói.
@JsonSerializable()
class ImagesEntity {
  final String xs;
  final String sm;
  final String md;
  final String lg;

  ImagesEntity({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
  });

  factory ImagesEntity.fromJson(Map<String, dynamic> json) =>
      _$ImagesEntityFromJson(json);
}