import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../entity/hero_database_entity.dart';
import '../entity/squad_database_entity.dart';

abstract class BaseDao {
  //Versão do banco:
  static const int databaseVersion = 2;

  //Nome do banco:
  static const String _databaseName =
      'hero_database.db';

  Database? _database;

  //Retorna o banco aberto:
  @protected
  Future<Database> getDb() async {
    _database ??= await _getDatabase();

    return _database!;
  }

  //Abre ou cria o banco:
  Future<Database> _getDatabase() async {
    return openDatabase(
      join(
        await getDatabasesPath(),
        _databaseName,
      ),

      //Cria o banco pela primeira vez:
      onCreate: (db, version) async {
        final batch = db.batch();

        //Cria a tabela de heróis:
        _createHeroesTableV1(batch);

        //Cria a tabela do esquadrão:
        _createSquadTableV2(batch);

        await batch.commit();
      },

      //Atualiza um banco já existente:
      onUpgrade: (
          db,
          oldVersion,
          newVersion,
          ) async {
        final batch = db.batch();

        //Adiciona a tabela do esquadrão na versão 2:
        if (oldVersion < 2) {
          _createSquadTableV2(batch);
        }

        await batch.commit();
      },

      version: databaseVersion,
    );
  }

  //Cria a tabela de heróis:
  void _createHeroesTableV1(
      Batch batch,
      ) {
    batch.execute(
      '''
      CREATE TABLE ${HeroDatabaseContract.heroTable}(
        ${HeroDatabaseContract.idColumn} INTEGER PRIMARY KEY,
        ${HeroDatabaseContract.nameColumn} TEXT NOT NULL,
        ${HeroDatabaseContract.slugColumn} TEXT NOT NULL,
        ${HeroDatabaseContract.imageColumn} TEXT NOT NULL,
        ${HeroDatabaseContract.largeImageColumn} TEXT NOT NULL,
        ${HeroDatabaseContract.intelligenceColumn} INTEGER NOT NULL,
        ${HeroDatabaseContract.strengthColumn} INTEGER NOT NULL,
        ${HeroDatabaseContract.speedColumn} INTEGER NOT NULL,
        ${HeroDatabaseContract.durabilityColumn} INTEGER NOT NULL,
        ${HeroDatabaseContract.powerColumn} INTEGER NOT NULL,
        ${HeroDatabaseContract.combatColumn} INTEGER NOT NULL,
        ${HeroDatabaseContract.genderColumn} TEXT NOT NULL,
        ${HeroDatabaseContract.raceColumn} TEXT NOT NULL,
        ${HeroDatabaseContract.heightColumn} TEXT NOT NULL,
        ${HeroDatabaseContract.weightColumn} TEXT NOT NULL,
        ${HeroDatabaseContract.eyeColorColumn} TEXT NOT NULL,
        ${HeroDatabaseContract.hairColorColumn} TEXT NOT NULL,
        ${HeroDatabaseContract.fullNameColumn} TEXT NOT NULL,
        ${HeroDatabaseContract.alterEgosColumn} TEXT NOT NULL,
        ${HeroDatabaseContract.aliasesColumn} TEXT NOT NULL,
        ${HeroDatabaseContract.placeOfBirthColumn} TEXT NOT NULL,
        ${HeroDatabaseContract.firstAppearanceColumn} TEXT NOT NULL,
        ${HeroDatabaseContract.publisherColumn} TEXT NOT NULL,
        ${HeroDatabaseContract.alignmentColumn} TEXT NOT NULL,
        ${HeroDatabaseContract.occupationColumn} TEXT NOT NULL,
        ${HeroDatabaseContract.baseColumn} TEXT NOT NULL,
        ${HeroDatabaseContract.groupAffiliationColumn} TEXT NOT NULL,
        ${HeroDatabaseContract.relativesColumn} TEXT NOT NULL
      );
      ''',
    );
  }

  //Cria a tabela do esquadrão:
  void _createSquadTableV2(
      Batch batch,
      ) {
    batch.execute(
      '''
      CREATE TABLE ${SquadDatabaseContract.squadTable}(
        ${SquadDatabaseContract.heroIdColumn} INTEGER PRIMARY KEY
      );
      ''',
    );
  }
}