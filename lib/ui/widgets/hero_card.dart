import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide Hero;

import '../../domain/hero.dart';

class HeroCard extends StatelessWidget {
  final Hero hero;

  const HeroCard({
    super.key,
    required this.hero,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Row(
        children: [
          //Imagem do herói:
          Container(
            alignment: Alignment.center,
            child: SizedBox(
              width: 100,
              height: 150,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: hero.image,

                  //Exibe carregamento enquanto busca a imagem:
                  placeholder: (context, url) =>
                  const Center(
                    child: CircularProgressIndicator(),
                  ),

                  //Exibe ícone caso a imagem falhe:
                  errorWidget: (context, url, error) =>
                  const Icon(
                    Icons.image_not_supported,
                    size: 60,
                  ),

                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          //Informações do herói:
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  //Nome:
                  Text(
                    hero.name,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  //Principais atributos:
                  Text(
                    'Força: ${hero.strength}',
                  ),

                  Text(
                    'Inteligência: ${hero.intelligence}',
                  ),

                  Text(
                    'Poder: ${hero.power}',
                  ),

                  const SizedBox(height: 8),

                  //Informações de aparência:
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
    );
  }
}