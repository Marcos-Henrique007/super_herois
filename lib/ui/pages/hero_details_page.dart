import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide Hero;
import 'package:primer_progress_bar/primer_progress_bar.dart';
import 'package:provider/provider.dart';

import '../../data/repository/squad_repository_impl.dart';
import '../../domain/hero.dart';

class HeroDetailsPage extends StatelessWidget {
  final Hero hero;

  //Define se pode dispensar o agente:
  final bool canDismiss;

  const HeroDetailsPage({
    super.key,
    required this.hero,
    this.canDismiss = false,
  });

  //Cria a barra de atributo:
  Widget _buildPowerStat(
      BuildContext context,
      String name,
      int value,
      ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 12,
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          //Nome e valor do atributo:
          Text(
            '$name: $value',
            style: Theme.of(context)
                .textTheme
                .titleSmall,
          ),

          const SizedBox(
            height: 5,
          ),

          //Barra do atributo:
          PrimerProgressBar(
            maxTotalValue: 100,
            showLegend: false,
            segments: [
              Segment(
                value: value,
                color: Theme.of(context)
                    .colorScheme
                    .primary,
                label: Text(name),
                valueLabel: Text(
                  '$value',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //Cria uma informação de texto:
  Widget _buildInformation(
      String title,
      String value,
      ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 8,
      ),
      child: Text(
        '$title: $value',
      ),
    );
  }

  //Confirma a dispensa do agente:
  void _showDismissDialog(
      BuildContext context,
      ) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.scale,
      title: 'Dispensar agente',
      desc:
      'Deseja realmente dispensar ${hero.name}?',
      btnCancelText: 'Cancelar',
      btnOkText: 'Dispensar',

      //Cancela a operação:
      btnCancelOnPress: () {},

      //Dispensa o agente:
      btnOkOnPress: () async {
        final squadRepo =
        Provider.of<SquadRepositoryImpl>(
          context,
          listen: false,
        );

        //Remove o agente do esquadrão:
        await squadRepo.dismiss(
          heroId: hero.id,
        );

        if (!context.mounted) {
          return;
        }

        //Retorna informando a remoção:
        Navigator.pop(
          context,
          true,
        );
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //Nome do herói:
        title: Text(
          hero.name,
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(
          16,
        ),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            //Imagem principal:
            Center(
              child: ClipRRect(
                borderRadius:
                BorderRadius.circular(
                  12,
                ),
                child: CachedNetworkImage(
                  imageUrl:
                  hero.largeImage,
                  width: 250,
                  height: 350,
                  fit: BoxFit.cover,

                  //Carregamento da imagem:
                  placeholder:
                      (context, url) =>
                  const SizedBox(
                    width: 250,
                    height: 350,
                    child: Center(
                      child:
                      CircularProgressIndicator(),
                    ),
                  ),

                  //Erro ao carregar a imagem:
                  errorWidget:
                      (
                      context,
                      url,
                      error,
                      ) =>
                  const SizedBox(
                    width: 250,
                    height: 350,
                    child: Icon(
                      Icons
                          .image_not_supported,
                      size: 80,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            //Nome:
            Text(
              hero.name,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium,
            ),

            const SizedBox(
              height: 20,
            ),

            //Atributos:
            Text(
              'Atributos',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge,
            ),

            const SizedBox(
              height: 12,
            ),

            _buildPowerStat(
              context,
              'Inteligência',
              hero.intelligence,
            ),

            _buildPowerStat(
              context,
              'Força',
              hero.strength,
            ),

            _buildPowerStat(
              context,
              'Velocidade',
              hero.speed,
            ),

            _buildPowerStat(
              context,
              'Durabilidade',
              hero.durability,
            ),

            _buildPowerStat(
              context,
              'Poder',
              hero.power,
            ),

            _buildPowerStat(
              context,
              'Combate',
              hero.combat,
            ),

            const Divider(
              height: 32,
            ),

            //Aparência:
            Text(
              'Aparência',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge,
            ),

            const SizedBox(
              height: 12,
            ),

            _buildInformation(
              'Gênero',
              hero.gender,
            ),

            _buildInformation(
              'Raça',
              hero.race,
            ),

            _buildInformation(
              'Altura',
              hero.height.join(
                ' / ',
              ),
            ),

            _buildInformation(
              'Peso',
              hero.weight.join(
                ' / ',
              ),
            ),

            _buildInformation(
              'Cor dos olhos',
              hero.eyeColor,
            ),

            _buildInformation(
              'Cor do cabelo',
              hero.hairColor,
            ),

            const Divider(
              height: 32,
            ),

            //Biografia:
            Text(
              'Biografia',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge,
            ),

            const SizedBox(
              height: 12,
            ),

            _buildInformation(
              'Nome completo',
              hero.fullName,
            ),

            _buildInformation(
              'Alter egos',
              hero.alterEgos,
            ),

            _buildInformation(
              'Apelidos',
              hero.aliases.join(
                ', ',
              ),
            ),

            _buildInformation(
              'Local de nascimento',
              hero.placeOfBirth,
            ),

            _buildInformation(
              'Primeira aparição',
              hero.firstAppearance,
            ),

            _buildInformation(
              'Editora',
              hero.publisher,
            ),

            _buildInformation(
              'Alinhamento',
              hero.alignment,
            ),

            const Divider(
              height: 32,
            ),

            //Trabalho:
            Text(
              'Trabalho',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge,
            ),

            const SizedBox(
              height: 12,
            ),

            _buildInformation(
              'Ocupação',
              hero.occupation,
            ),

            _buildInformation(
              'Base',
              hero.base,
            ),

            const Divider(
              height: 32,
            ),

            //Conexões:
            Text(
              'Conexões',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge,
            ),

            const SizedBox(
              height: 12,
            ),

            _buildInformation(
              'Grupos',
              hero.groupAffiliation,
            ),

            _buildInformation(
              'Parentes',
              hero.relatives,
            ),

            //Botão de dispensa:
            if (canDismiss) ...[
              const SizedBox(
                height: 24,
              ),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  //Solicita a dispensa do agente:
                  onPressed: () {
                    _showDismissDialog(
                      context,
                    );
                  },

                  child: const Text(
                    'Dispensar agente',
                  ),
                ),
              ),

              const SizedBox(
                height: 16,
              ),
            ],
          ],
        ),
      ),
    );
  }
}