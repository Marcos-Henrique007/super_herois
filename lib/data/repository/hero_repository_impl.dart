import '../../domain/hero.dart';
import '../database/dao/hero_dao.dart';
import '../database/database_mapper.dart';
import '../network/client/api_client.dart';
import '../network/network_mapper.dart';
import 'hero_repository.dart';

class HeroRepositoryImpl implements HeroRepository {
  final ApiClient apiClient;
  final NetworkMapper networkMapper;
  final HeroDao heroDao;
  final DatabaseMapper databaseMapper;

  HeroRepositoryImpl({
    required this.heroDao,
    required this.databaseMapper,
    required this.apiClient,
    required this.networkMapper,
  });

  @override
  Future<List<Hero>> getHeroes({
    required int page,
    required int limit,
  }) async {

    //Tenta carregar os heróis do banco:
    final dbEntities = await heroDao.selectAll(
      limit: 10,
      offset: (page * limit) - limit,
    );

    //Se os dados já existem, carrega do banco:
    if (dbEntities.isNotEmpty) {
      return databaseMapper.toHeroes(dbEntities);
    }

    //Caso contrário, busca pela API:
    final networkEntity = await apiClient.getHeroes(
      page: page,
      limit: limit,
    );

    final heroes = networkMapper.toHeroes(
      networkEntity,
    );

    //Salva os dados no banco local para cache:
    heroDao.insertAll(
      databaseMapper.toHeroDatabaseEntities(
        heroes,
      ),
    );

    return heroes;
  }

  @override
  Future<Hero> getHeroById({
    required int id,
  }) async {

    //Tenta carregar o herói do banco:
    final dbEntity = await heroDao.selectById(
      id,
    );

    //Se o herói já existe no banco, retorna o cache:
    if (dbEntity != null) {
      return databaseMapper.toHero(
        dbEntity,
      );
    }

    //Caso contrário, busca pela API:
    final networkEntity = await apiClient.getHeroById(
      id: id,
    );

    //Converte o HeroEntity para Hero:
    final hero = networkMapper.toHero(
      networkEntity,
    );

    //Salva o herói no banco local:
    await heroDao.insert(
      databaseMapper.toHeroDatabaseEntity(
        hero,
      ),
    );

    return hero;
  }
}