import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide Hero;

import '../../domain/hero.dart';
import '../pages/hero_details_page.dart';

class HeroCard extends StatelessWidget {
  final Hero hero;

  //Ação personalizada:
  final VoidCallback? onTap;

  const HeroCard({
    super.key,
    required this.hero,
    this.onTap,
  });

  //Retorna o maior atributo:
  MapEntry<String, int> _getBestAttribute() {
    final attributes = <String, int>{
      'Inteligência': hero.intelligence,
      'Força': hero.strength,
      'Velocidade': hero.speed,
      'Durabilidade': hero.durability,
      'Poder': hero.power,
      'Combate': hero.combat,
    };

    return attributes.entries.reduce(
          (current, next) =>
      current.value >= next.value
          ? current
          : next,
    );
  }

  @override
  Widget build(BuildContext context) {
    //Busca o maior atributo:
    final bestAttribute =
    _getBestAttribute();

    return Card(
      elevation: 5,
      child: InkWell(
        onTap: onTap ??
                () {
              //Abre os detalhes:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      HeroDetailsPage(
                        hero: hero,
                      ),
                ),
              );
            },

        child: Row(
          children: [
            //Imagem:
            SizedBox(
              width: 100,
              height: 160,
              child: ClipRRect(
                borderRadius:
                BorderRadius.circular(
                  10,
                ),
                child: CachedNetworkImage(
                  imageUrl: hero.image,
                  fit: BoxFit.cover,

                  //Carregamento:
                  placeholder:
                      (context, url) =>
                  const Center(
                    child:
                    CircularProgressIndicator(),
                  ),

                  //Erro:
                  errorWidget:
                      (
                      context,
                      url,
                      error,
                      ) =>
                  const Icon(
                    Icons.image_not_supported,
                    size: 60,
                  ),
                ),
              ),
            ),

            //Informações:
            Flexible(
              child: Padding(
                padding:
                const EdgeInsets.all(
                  8,
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    //Nome:
                    Text(
                      hero.name,
                      style:
                      Theme.of(context)
                          .textTheme
                          .titleMedium,
                      overflow:
                      TextOverflow.ellipsis,
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    //Powerstats:
                    Text(
                      'Força: ${hero.strength}',
                    ),

                    Text(
                      'Inteligência: ${hero.intelligence}',
                    ),

                    Text(
                      'Poder: ${hero.power}',
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    //Maior atributo:
                    Text(
                      'Maior atributo: '
                          '${bestAttribute.key} '
                          '(${bestAttribute.value})',
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    //Aparência:
                    Text(
                      'Raça: ${hero.race}',
                    ),

                    Text(
                      'Gênero: ${hero.gender}',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}