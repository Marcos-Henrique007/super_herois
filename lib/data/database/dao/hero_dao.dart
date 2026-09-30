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
      orderBy: '${HeroDatabaseContract.idColumn} ASC',
    );

    //Converte os registros para HeroDatabaseEntity:
    return List.generate(
      maps.length,
          (index) {
        return HeroDatabaseEntity.fromJson(
          maps[index],
        );
      },
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
      where: '${HeroDatabaseContract.idColumn} = ?',
      whereArgs: [id],
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

  //Salva um herói no banco:
  Future<void> insert(
      HeroDatabaseEntity entity,
      ) async {
    final Database db = await getDb();

    await db.insert(
      HeroDatabaseContract.heroTable,
      entity.toJson(),

      //Substitui caso o herói já esteja salvo:
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //Salva vários heróis no banco:
  Future<void> insertAll(
      List<HeroDatabaseEntity> entities,
      ) async {
    final Database db = await getDb();

    //Executa os inserts em uma única transação:
    await db.transaction((transaction) async {
      for (final entity in entities) {
        await transaction.insert(
          HeroDatabaseContract.heroTable,
          entity.toJson(),
          conflictAlgorithm:
          ConflictAlgorithm.replace,
        );
      }
    });
  }

  //Apaga todos os heróis do cache:
  Future<void> deleteAll() async {
    final Database db = await getDb();

    await db.delete(
      HeroDatabaseContract.heroTable,
    );
  }
}