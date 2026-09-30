import 'dart:convert';

import '../../domain/exception/mapper_exception.dart';
import '../../domain/hero.dart';
import 'entity/hero_database_entity.dart';

class DatabaseMapper {
  //Converte HeroDatabaseEntity para Hero:
  Hero toHero(HeroDatabaseEntity entity) {
    try {
      return Hero(
        //Identificação:
        id: entity.id,
        name: entity.name,
        slug: entity.slug,

        //Imagens:
        image: entity.image,
        largeImage: entity.largeImage,

        //Atributos:
        intelligence: entity.intelligence,
        strength: entity.strength,
        speed: entity.speed,
        durability: entity.durability,
        power: entity.power,
        combat: entity.combat,

        //Aparência:
        gender: entity.gender,
        race: entity.race,

        //Converte o texto salvo no banco para uma lista de string:
        height: List<String>.from(
          jsonDecode(entity.height),
        ),

        weight: List<String>.from(
          jsonDecode(entity.weight),
        ),

        eyeColor: entity.eyeColor,
        hairColor: entity.hairColor,

        //Biografia:
        fullName: entity.fullName,
        alterEgos: entity.alterEgos,

        aliases: List<String>.from(
          jsonDecode(entity.aliases),
        ),

        placeOfBirth: entity.placeOfBirth,
        firstAppearance: entity.firstAppearance,
        publisher: entity.publisher,
        alignment: entity.alignment,

        //Trabalho:
        occupation: entity.occupation,
        base: entity.base,

        //Conexões:
        groupAffiliation: entity.groupAffiliation,
        relatives: entity.relatives,
      );
    } catch (e) {
      //Erro durante a conversão:
      throw MapperException<HeroDatabaseEntity, Hero>(
        e.toString(),
      );
    }
  }

  //Converte uma lista de HeroDatabaseEntity para Hero:
  List<Hero> toHeroes(
      List<HeroDatabaseEntity> entities,
      ) {
    final List<Hero> heroes = [];

    for (var heroEntity in entities) {
      heroes.add(toHero(heroEntity));
    }

    return heroes;
  }

  //Converte Hero para HeroDatabaseEntity:
  HeroDatabaseEntity toHeroDatabaseEntity(Hero hero) {
    try {
      return HeroDatabaseEntity(
        //Identificação:
        id: hero.id,
        name: hero.name,
        slug: hero.slug,

        //Imagens:
        image: hero.image,
        largeImage: hero.largeImage,

        //Atributos:
        intelligence: hero.intelligence,
        strength: hero.strength,
        speed: hero.speed,
        durability: hero.durability,
        power: hero.power,
        combat: hero.combat,

        //Aparência:
        gender: hero.gender,
        race: hero.race,

        //Converte List<String> para texto JSON:
        height: jsonEncode(hero.height),
        weight: jsonEncode(hero.weight),

        eyeColor: hero.eyeColor,
        hairColor: hero.hairColor,

        //Biografia:
        fullName: hero.fullName,
        alterEgos: hero.alterEgos,
        aliases: jsonEncode(hero.aliases),
        placeOfBirth: hero.placeOfBirth,
        firstAppearance: hero.firstAppearance,
        publisher: hero.publisher,
        alignment: hero.alignment,

        //Trabalho:
        occupation: hero.occupation,
        base: hero.base,

        //Conexões:
        groupAffiliation: hero.groupAffiliation,
        relatives: hero.relatives,
      );
    } catch (e) {
      //Erro durante a conversão:
      throw MapperException<HeroDatabaseEntity, Hero>(
        e.toString(),
      );
    }
  }

  //Converte uma lista de Hero para HeroDatabaseEntity:
  List<HeroDatabaseEntity> toHeroDatabaseEntities(
      List<Hero> heroes,
      ) {
    final List<HeroDatabaseEntity> entities = [];

    for (var hero in heroes) {
      entities.add(
        toHeroDatabaseEntity(hero),
      );
    }

    return entities;
  }
}