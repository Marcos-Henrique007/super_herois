import 'package:json_annotation/json_annotation.dart';

part 'http_paged_result.g.dart';

//Resultado paginado recebido do json-server:
@JsonSerializable()
class HttpPagedResult {
  final int first;
  final dynamic prev;
  final dynamic next;
  final int last;
  final int pages;
  final int items;

  //Lista de heróis da página:
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

  //Converte o JSON para HttpPagedResult:
  factory HttpPagedResult.fromJson(Map<String, dynamic> json) =>
      _$HttpPagedResultFromJson(json);
}

//Representa um herói recebido da API:
@JsonSerializable()
class HeroEntity {
  //Identificação:
  final int id;
  final String name;
  final String slug;

  //Dados agrupados:
  final PowerstatsEntity powerstats;
  final AppearanceEntity appearance;
  final BiographyEntity biography;
  final WorkEntity work;
  final ConnectionsEntity connections;
  final ImagesEntity images;

  HeroEntity({
    required this.id,
    required this.name,
    required this.slug,
    required this.powerstats,
    required this.appearance,
    required this.biography,
    required this.work,
    required this.connections,
    required this.images,
  });

  //Converte o JSON para HeroEntity:
  factory HeroEntity.fromJson(Map<String, dynamic> json) =>
      _$HeroEntityFromJson(json);
}

//Representa os atributos do herói:
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

  //Converte o JSON para PowerstatsEntity:
  factory PowerstatsEntity.fromJson(Map<String, dynamic> json) =>
      _$PowerstatsEntityFromJson(json);
}

//Representa a aparência do herói:
@JsonSerializable()
class AppearanceEntity {
  final String gender;

  //A raça pode ser nula no JSON:
  final String? race;

  final List<String> height;
  final List<String> weight;
  final String eyeColor;
  final String hairColor;

  AppearanceEntity({
    required this.gender,
    required this.race,
    required this.height,
    required this.weight,
    required this.eyeColor,
    required this.hairColor,
  });

  //Converte o JSON para AppearanceEntity:
  factory AppearanceEntity.fromJson(Map<String, dynamic> json) =>
      _$AppearanceEntityFromJson(json);
}

//Representa a biografia do herói:
@JsonSerializable()
class BiographyEntity {
  final String fullName;
  final String alterEgos;
  final List<String> aliases;
  final String placeOfBirth;
  final String firstAppearance;

  //A editora pode ser nula no JSON:
  final String? publisher;

  final String alignment;

  BiographyEntity({
    required this.fullName,
    required this.alterEgos,
    required this.aliases,
    required this.placeOfBirth,
    required this.firstAppearance,
    required this.publisher,
    required this.alignment,
  });

  //Converte o JSON para BiographyEntity:
  factory BiographyEntity.fromJson(Map<String, dynamic> json) =>
      _$BiographyEntityFromJson(json);
}

//Representa os dados de trabalho:
@JsonSerializable()
class WorkEntity {
  final String occupation;
  final String base;

  WorkEntity({
    required this.occupation,
    required this.base,
  });

  //Converte o JSON para WorkEntity:
  factory WorkEntity.fromJson(Map<String, dynamic> json) =>
      _$WorkEntityFromJson(json);
}

//Representa as conexões do herói:
@JsonSerializable()
class ConnectionsEntity {
  final String groupAffiliation;
  final String relatives;

  ConnectionsEntity({
    required this.groupAffiliation,
    required this.relatives,
  });

  //Converte o JSON para ConnectionsEntity:
  factory ConnectionsEntity.fromJson(Map<String, dynamic> json) =>
      _$ConnectionsEntityFromJson(json);
}

//Representa as imagens do herói:
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

  //Converte o JSON para ImagesEntity:
  factory ImagesEntity.fromJson(Map<String, dynamic> json) =>
      _$ImagesEntityFromJson(json);
}