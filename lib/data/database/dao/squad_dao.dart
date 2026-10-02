import 'package:sqflite/sqflite.dart';

import '../entity/squad_database_entity.dart';
import 'base_dao.dart';

class SquadDao extends BaseDao {
  //Busca os integrantes do esquadrão:
  Future<List<SquadDatabaseEntity>>
  selectAll() async {
    final Database db = await getDb();

    final List<Map<String, dynamic>> maps =
    await db.query(
      SquadDatabaseContract.squadTable,
    );

    //Converte os registros para SquadDatabaseEntity:
    return List.generate(
      maps.length,
          (index) =>
          SquadDatabaseEntity.fromJson(
            maps[index],
          ),
    );
  }

  //Verifica se um herói já foi recrutado:
  Future<bool> contains(
      int heroId,
      ) async {
    final Database db = await getDb();

    final result = await db.query(
      SquadDatabaseContract.squadTable,
      where:
      '${SquadDatabaseContract.heroIdColumn} = ?',
      whereArgs: [
        heroId,
      ],
      limit: 1,
    );

    return result.isNotEmpty;
  }

  //Retorna a quantidade de integrantes:
  Future<int> count() async {
    final Database db = await getDb();

    final result = await db.rawQuery(
      '''
      SELECT COUNT(*) AS total
      FROM ${SquadDatabaseContract.squadTable}
      ''',
    );

    return result.first['total'] as int;
  }

  //Recruta um herói:
  Future<void> insert(
      SquadDatabaseEntity entity,
      ) async {
    final Database db = await getDb();

    await db.insert(
      SquadDatabaseContract.squadTable,
      entity.toJson(),

      //Evita duplicar o mesmo herói:
      conflictAlgorithm:
      ConflictAlgorithm.ignore,
    );
  }

  //Remove um herói do esquadrão:
  Future<void> delete(
      int heroId,
      ) async {
    final Database db = await getDb();

    await db.delete(
      SquadDatabaseContract.squadTable,
      where:
      '${SquadDatabaseContract.heroIdColumn} = ?',
      whereArgs: [
        heroId,
      ],
    );
  }
}