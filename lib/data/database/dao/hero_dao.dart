import 'package:sqflite/sqflite.dart';

import '../entity/hero_database_entity.dart';
import 'base_dao.dart';

class HeroDao extends BaseDao {
  //Busca os heróis no banco:
  Future<List<HeroDatabaseEntity>> selectAll({
    int? limit,
    int? offset,
  }) async {
    final Database db = await getDb();

    final List<Map<String, dynamic>> maps =
    await db.query(
      HeroDatabaseContract.heroTable,
      limit: limit,
      offset: offset,
      orderBy:
      '${HeroDatabaseContract.idColumn} ASC',
    );

    //Converte os registros:
    return List.generate(
      maps.length,
          (index) =>
          HeroDatabaseEntity.fromJson(
            maps[index],
          ),
    );
  }

  //Busca um herói pelo ID:
  Future<HeroDatabaseEntity?> selectById(
      int id,
      ) async {
    final Database db = await getDb();

    final List<Map<String, dynamic>> maps =
    await db.query(
      HeroDatabaseContract.heroTable,
      where:
      '${HeroDatabaseContract.idColumn} = ?',
      whereArgs: [
        id,
      ],
      limit: 1,
    );

    //Retorna null caso não encontre:
    if (maps.isEmpty) {
      return null;
    }

    return HeroDatabaseEntity.fromJson(
      maps.first,
    );
  }

  //Retorna a quantidade de heróis salvos:
  Future<int> count() async {
    final Database db = await getDb();

    final result = await db.rawQuery(
      '''
      SELECT COUNT(*)
      FROM ${HeroDatabaseContract.heroTable}
      ''',
    );

    return Sqflite.firstIntValue(
      result,
    ) ??
        0;
  }

  //Salva um herói:
  Future<void> insert(
      HeroDatabaseEntity entity,
      ) async {
    final Database db = await getDb();

    await db.insert(
      HeroDatabaseContract.heroTable,
      entity.toJson(),

      //Atualiza caso já exista:
      conflictAlgorithm:
      ConflictAlgorithm.replace,
    );
  }

  //Salva vários heróis:
  Future<void> insertAll(
      List<HeroDatabaseEntity> entities,
      ) async {
    final Database db = await getDb();

    //Executa todos os inserts juntos:
    await db.transaction(
          (transaction) async {
        for (final entity in entities) {
          await transaction.insert(
            HeroDatabaseContract.heroTable,
            entity.toJson(),
            conflictAlgorithm:
            ConflictAlgorithm.replace,
          );
        }
      },
    );
  }

  //Apaga o cache:
  Future<void> deleteAll() async {
    final Database db = await getDb();

    await db.delete(
      HeroDatabaseContract.heroTable,
    );
  }
}