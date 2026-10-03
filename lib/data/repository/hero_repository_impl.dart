import '../../domain/hero.dart';
import '../database/dao/hero_dao.dart';
import '../database/database_mapper.dart';
import '../network/client/api_client.dart';
import '../network/network_mapper.dart';
import 'hero_repository.dart';

class HeroRepositoryImpl
    implements HeroRepository {
  final ApiClient apiClient;
  final NetworkMapper networkMapper;
  final HeroDao heroDao;
  final DatabaseMapper databaseMapper;

  //Quantidade de heróis do catálogo:
  static const int _totalHeroes = 563;

  //Quantidade solicitada na primeira carga:
  static const int _fullCacheLimit = 1000;

  HeroRepositoryImpl({
    required this.heroDao,
    required this.databaseMapper,
    required this.apiClient,
    required this.networkMapper,
  });

  //Garante que o catálogo esteja salvo:
  Future<void> _ensureFullCache() async {
    //Verifica a quantidade salva:
    final totalCached =
    await heroDao.count();

    //Evita buscar novamente:
    if (totalCached >= _totalHeroes) {
      return;
    }

    //Busca todo o catálogo:
    final networkEntities =
    await apiClient.getHeroes(
      page: 1,
      limit: _fullCacheLimit,
    );

    //Converte os dados da API:
    final heroes =
    networkMapper.toHeroes(
      networkEntities,
    );

    //Salva todo o catálogo:
    await heroDao.insertAll(
      databaseMapper
          .toHeroDatabaseEntities(
        heroes,
      ),
    );
  }

  @override
  Future<List<Hero>> getHeroes({
    required int page,
    required int limit,
  }) async {
    //Calcula o início da página:
    final offset =
        (page * limit) - limit;

    //Busca primeiro no banco:
    final dbEntities =
    await heroDao.selectAll(
      limit: limit,
      offset: offset,
    );

    //Verifica o tamanho do cache:
    final totalCached =
    await heroDao.count();

    //Se o catálogo já está completo:
    if (totalCached >= _totalHeroes) {
      return databaseMapper.toHeroes(
        dbEntities,
      );
    }

    try {
      //Completa o cache:
      await _ensureFullCache();

      //Busca novamente a página:
      final updatedEntities =
      await heroDao.selectAll(
        limit: limit,
        offset: offset,
      );

      return databaseMapper.toHeroes(
        updatedEntities,
      );
    } catch (e) {
      //Se estiver offline, usa o que já existe:
      if (dbEntities.isNotEmpty) {
        return databaseMapper.toHeroes(
          dbEntities,
        );
      }

      rethrow;
    }
  }

  @override
  Future<Hero> getHeroById({
    required int id,
  }) async {
    //Tenta buscar primeiro no banco:
    var dbEntity =
    await heroDao.selectById(
      id,
    );

    //Se encontrou, retorna:
    if (dbEntity != null) {
      return databaseMapper.toHero(
        dbEntity,
      );
    }

    //Tenta carregar o catálogo completo:
    await _ensureFullCache();

    //Busca novamente no banco:
    dbEntity =
    await heroDao.selectById(
      id,
    );

    //Retorna caso tenha encontrado:
    if (dbEntity != null) {
      return databaseMapper.toHero(
        dbEntity,
      );
    }

    //Caso não encontre, busca pela API:
    final networkEntity =
    await apiClient.getHeroById(
      id: id,
    );

    final hero =
    networkMapper.toHero(
      networkEntity,
    );

    //Salva o herói:
    await heroDao.insert(
      databaseMapper
          .toHeroDatabaseEntity(
        hero,
      ),
    );

    return hero;
  }
}