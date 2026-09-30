import '../../domain/hero.dart';

abstract class HeroRepository {

  //Busca os heróis:
  Future<List<Hero>> getHeroes({
    required int page,
    required int limit,
  });
}