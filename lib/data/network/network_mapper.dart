import '../../domain/exception/mapper_exception.dart';
import '../../domain/hero.dart';
import 'entity/http_paged_result.dart';

class NetworkMapper {
  // Converte um HeroEntity da API para o modelo Hero usado no aplicativo.
  Hero toHero(HeroEntity entity) {
    try {
      return Hero(
        // Informações básicas do herói.
        id: entity.id,
        name: entity.name,
        image: entity.images.md,

        // Atributos de combate.
        intelligence: entity.powerstats.intelligence,
        strength: entity.powerstats.strength,
        speed: entity.powerstats.speed,
        durability: entity.powerstats.durability,
        power: entity.powerstats.power,
        combat: entity.powerstats.combat,

        // Informações de aparência.
        gender: entity.appearance.gender,
        race: entity.appearance.race ?? 'Desconhecida',

        // Altura e peso vêm como listas na API.
        height: entity.appearance.height,
        weight: entity.appearance.weight,
      );
    } catch (e) {
      // Caso ocorra erro na conversão, lança uma exceção de mapper.
      throw MapperException<HeroEntity, Hero>(
        e.toString(),
      );
    }
  }

  // Converte uma lista de HeroEntity em uma lista de Hero.
  List<Hero> toHeroes(List<HeroEntity> entities) {
    final List<Hero> heroes = [];

    // Percorre cada entidade recebida da API.
    for (var heroEntity in entities) {
      heroes.add(toHero(heroEntity));
    }

    return heroes;
  }
}