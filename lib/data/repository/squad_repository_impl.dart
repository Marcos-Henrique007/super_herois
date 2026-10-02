import '../../domain/hero.dart';
import '../database/dao/hero_dao.dart';
import '../database/dao/squad_dao.dart';
import '../database/database_mapper.dart';
import '../database/entity/squad_database_entity.dart';
import 'squad_repository.dart';

class SquadRepositoryImpl implements SquadRepository {
  final SquadDao squadDao;
  final HeroDao heroDao;
  final DatabaseMapper databaseMapper;

  SquadRepositoryImpl({
    required this.squadDao,
    required this.heroDao,
    required this.databaseMapper,
  });

  @override
  Future<List<Hero>> getSquad() async {
    //Busca os IDs recrutados:
    final squadEntities =
    await squadDao.selectAll();

    final List<Hero> heroes = [];

    //Busca os dados de cada herói:
    for (final squadEntity in squadEntities) {
      final heroEntity =
      await heroDao.selectById(
        squadEntity.heroId,
      );

      if (heroEntity != null) {
        heroes.add(
          databaseMapper.toHero(
            heroEntity,
          ),
        );
      }
    }

    return heroes;
  }

  @override
  Future<bool> isRecruited({
    required int heroId,
  }) {
    //Verifica se o herói já está no esquadrão:
    return squadDao.contains(
      heroId,
    );
  }

  @override
  Future<int> getSquadCount() {
    //Retorna a quantidade de agentes:
    return squadDao.count();
  }

  @override
  Future<void> recruit({
    required Hero hero,
  }) async {
    //Garante que o herói esteja salvo no cache:
    await heroDao.insert(
      databaseMapper.toHeroDatabaseEntity(
        hero,
      ),
    );

    //Salva o ID no esquadrão:
    await squadDao.insert(
      SquadDatabaseEntity(
        heroId: hero.id,
      ),
    );
  }

  @override
  Future<void> dismiss({
    required int heroId,
  }) async {
    //Remove o herói do esquadrão:
    await squadDao.delete(
      heroId,
    );
  }
}