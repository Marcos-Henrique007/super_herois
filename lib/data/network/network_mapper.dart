import '../../domain/hero.dart';
import 'entity/hero_network_entity.dart';

class NetworkMapper {
  Hero toHero(HeroNetworkEntity entity) {
    return Hero(
      //converte as informações que foram trazidas da API para o formato de Hero
      id: entity.id,
      name: entity.name,
      image: entity.image,

      intelligence: entity.intelligence,
      strength: entity.strength,
      speed: entity.speed,
      durability: entity.durability,
      power: entity.power,
      combat: entity.combat,

      gender: entity.gender,
      race: entity.race,
      height: entity.height,
      weight: entity.weight,
    );
  }

  //Converte uma lista de HeroNetworkEntity em uma lista de Hero
  List<Hero> toHeroList(List<HeroNetworkEntity> entities) {
    return entities.map((entity) => toHero(entity)).toList();
  }
}