import 'package:json_annotation/json_annotation.dart';

part 'squad_database_entity.g.dart';

@JsonSerializable()
class SquadDatabaseEntity {
  //Identificação do herói recrutado:
  @JsonKey(name: SquadDatabaseContract.heroIdColumn)
  final int heroId;

  SquadDatabaseEntity({
    required this.heroId,
  });

  //Converte os dados do banco para SquadDatabaseEntity:
  factory SquadDatabaseEntity.fromJson(
      Map<String, dynamic> json,
      ) =>
      _$SquadDatabaseEntityFromJson(json);

  //Converte SquadDatabaseEntity para Map:
  Map<String, dynamic> toJson() =>
      _$SquadDatabaseEntityToJson(this);
}

//Nomes da tabela e colunas:
abstract class SquadDatabaseContract {
  static const String squadTable =
      'squad_table';

  //Identificação:
  static const String heroIdColumn =
      'hero_id';
}