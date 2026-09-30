import 'package:json_annotation/json_annotation.dart';

part 'hero_database_entity.g.dart';

@JsonSerializable()
class HeroDatabaseEntity {
  //Identificação:
  @JsonKey(name: HeroDatabaseContract.idColumn)
  final int id;

  @JsonKey(name: HeroDatabaseContract.nameColumn)
  final String name;

  @JsonKey(name: HeroDatabaseContract.slugColumn)
  final String slug;

  //Imagens:
  @JsonKey(name: HeroDatabaseContract.imageColumn)
  final String image;

  @JsonKey(name: HeroDatabaseContract.largeImageColumn)
  final String largeImage;

  //Atributos:
  @JsonKey(name: HeroDatabaseContract.intelligenceColumn)
  final int intelligence;

  @JsonKey(name: HeroDatabaseContract.strengthColumn)
  final int strength;

  @JsonKey(name: HeroDatabaseContract.speedColumn)
  final int speed;

  @JsonKey(name: HeroDatabaseContract.durabilityColumn)
  final int durability;

  @JsonKey(name: HeroDatabaseContract.powerColumn)
  final int power;

  @JsonKey(name: HeroDatabaseContract.combatColumn)
  final int combat;

  //Aparência:
  @JsonKey(name: HeroDatabaseContract.genderColumn)
  final String gender;

  @JsonKey(name: HeroDatabaseContract.raceColumn)
  final String race;

  @JsonKey(name: HeroDatabaseContract.heightColumn)
  final String height;

  @JsonKey(name: HeroDatabaseContract.weightColumn)
  final String weight;

  @JsonKey(name: HeroDatabaseContract.eyeColorColumn)
  final String eyeColor;

  @JsonKey(name: HeroDatabaseContract.hairColorColumn)
  final String hairColor;

  //Biografia:
  @JsonKey(name: HeroDatabaseContract.fullNameColumn)
  final String fullName;

  @JsonKey(name: HeroDatabaseContract.alterEgosColumn)
  final String alterEgos;

  @JsonKey(name: HeroDatabaseContract.aliasesColumn)
  final String aliases;

  @JsonKey(name: HeroDatabaseContract.placeOfBirthColumn)
  final String placeOfBirth;

  @JsonKey(name: HeroDatabaseContract.firstAppearanceColumn)
  final String firstAppearance;

  @JsonKey(name: HeroDatabaseContract.publisherColumn)
  final String publisher;

  @JsonKey(name: HeroDatabaseContract.alignmentColumn)
  final String alignment;

  //Trabalho:
  @JsonKey(name: HeroDatabaseContract.occupationColumn)
  final String occupation;

  @JsonKey(name: HeroDatabaseContract.baseColumn)
  final String base;

  //Conexões:
  @JsonKey(name: HeroDatabaseContract.groupAffiliationColumn)
  final String groupAffiliation;

  @JsonKey(name: HeroDatabaseContract.relativesColumn)
  final String relatives;

  HeroDatabaseEntity({
    required this.id,
    required this.name,
    required this.slug,
    required this.image,
    required this.largeImage,
    required this.intelligence,
    required this.strength,
    required this.speed,
    required this.durability,
    required this.power,
    required this.combat,
    required this.gender,
    required this.race,
    required this.height,
    required this.weight,
    required this.eyeColor,
    required this.hairColor,
    required this.fullName,
    required this.alterEgos,
    required this.aliases,
    required this.placeOfBirth,
    required this.firstAppearance,
    required this.publisher,
    required this.alignment,
    required this.occupation,
    required this.base,
    required this.groupAffiliation,
    required this.relatives,
  });

  //Converte os dados do banco para HeroDatabaseEntity:
  factory HeroDatabaseEntity.fromJson(Map<String, dynamic> json) =>
      _$HeroDatabaseEntityFromJson(json);

  //Converte HeroDatabaseEntity para Map:
  Map<String, dynamic> toJson() =>
      _$HeroDatabaseEntityToJson(this);
}

//Nomes da tabela e colunas:
abstract class HeroDatabaseContract {
  static const String heroTable = 'hero_table';

  //Identificação:
  static const String idColumn = 'id';
  static const String nameColumn = 'name';
  static const String slugColumn = 'slug';

  //Imagens:
  static const String imageColumn = 'image';
  static const String largeImageColumn = 'large_image';

  //Atributos:
  static const String intelligenceColumn = 'intelligence';
  static const String strengthColumn = 'strength';
  static const String speedColumn = 'speed';
  static const String durabilityColumn = 'durability';
  static const String powerColumn = 'power';
  static const String combatColumn = 'combat';

  //Aparência:
  static const String genderColumn = 'gender';
  static const String raceColumn = 'race';
  static const String heightColumn = 'height';
  static const String weightColumn = 'weight';
  static const String eyeColorColumn = 'eye_color';
  static const String hairColorColumn = 'hair_color';

  //Biografia:
  static const String fullNameColumn = 'full_name';
  static const String alterEgosColumn = 'alter_egos';
  static const String aliasesColumn = 'aliases';
  static const String placeOfBirthColumn = 'place_of_birth';
  static const String firstAppearanceColumn = 'first_appearance';
  static const String publisherColumn = 'publisher';
  static const String alignmentColumn = 'alignment';

  //Trabalho:
  static const String occupationColumn = 'occupation';
  static const String baseColumn = 'base';

  //Conexões:
  static const String groupAffiliationColumn = 'group_affiliation';
  static const String relativesColumn = 'relatives';
}