import '../../domain/exception/mapper_exception.dart';
import '../../domain/hero.dart';
import 'entity/http_paged_result.dart';

class NetworkMapper {
  //Converte HeroEntity para Hero:
  Hero toHero(HeroEntity entity) {
    try {
      return Hero(
        //Identificação:
        id: entity.id,
        name: entity.name,
        slug: entity.slug,

        //Imagens:
        image: entity.images.md,
        largeImage: entity.images.lg,

        //Atributos:
        intelligence: entity.powerstats.intelligence,
        strength: entity.powerstats.strength,
        speed: entity.powerstats.speed,
        durability: entity.powerstats.durability,
        power: entity.powerstats.power,
        combat: entity.powerstats.combat,

        //Aparência:
        gender: entity.appearance.gender,
        race: entity.appearance.race ?? 'Desconhecida',
        height: entity.appearance.height,
        weight: entity.appearance.weight,
        eyeColor: entity.appearance.eyeColor,
        hairColor: entity.appearance.hairColor,

        //Biografia:
        fullName: entity.biography.fullName,
        alterEgos: entity.biography.alterEgos,
        aliases: entity.biography.aliases,
        placeOfBirth: entity.biography.placeOfBirth,
        firstAppearance: entity.biography.firstAppearance,
        publisher: entity.biography.publisher ?? 'Desconhecido',
        alignment: entity.biography.alignment,

        //Trabalho:
        occupation: entity.work.occupation,
        base: entity.work.base,

        //Conexões:
        groupAffiliation: entity.connections.groupAffiliation,
        relatives: entity.connections.relatives,
      );
    } catch (e) {
      //Erro durante a conversão:
      throw MapperException<HeroEntity, Hero>(
        e.toString(),
      );
    }
  }

  //Converte uma lista de HeroEntity para Hero:
  List<Hero> toHeroes(List<HeroEntity> entities) {
    final List<Hero> heroes = [];

    //Percorre as entidades recebidas:
    for (var heroEntity in entities) {
      heroes.add(toHero(heroEntity));
    }

    return heroes;
  }
}