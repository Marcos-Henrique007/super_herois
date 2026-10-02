import '../../domain/hero.dart';

abstract class SquadRepository {
  //Busca os agentes do esquadrão:
  Future<List<Hero>> getSquad();

  //Verifica se o agente já foi recrutado:
  Future<bool> isRecruited({
    required int heroId,
  });

  //Retorna a quantidade de agentes:
  Future<int> getSquadCount();

  //Recruta um agente:
  Future<void> recruit({
    required Hero hero,
  });

  //Remove um agente:
  Future<void> dismiss({
    required int heroId,
  });
}