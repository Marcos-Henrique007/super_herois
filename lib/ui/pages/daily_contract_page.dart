import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide Hero;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/repository/hero_repository_impl.dart';
import '../../data/repository/squad_repository_impl.dart';
import '../../domain/hero.dart';

class DailyContractPage
    extends StatefulWidget {
  const DailyContractPage({
    super.key,
  });

  @override
  State<DailyContractPage> createState() =>
      _DailyContractPageState();
}

class _DailyContractPageState
    extends State<DailyContractPage> {
  //Chaves do SharedPreferences:
  static const String _heroIdKey =
      'daily_hero_id';

  static const String _heroDateKey =
      'daily_hero_date';

  //Quantidade de heróis:
  static const int _totalHeroes = 563;

  //Repositório dos heróis:
  late final HeroRepositoryImpl heroesRepo;

  //Repositório do esquadrão:
  late final SquadRepositoryImpl squadRepo;

  //Herói do dia:
  Hero? dailyHero;

  //Indica se já foi recrutado:
  bool isRecruited = false;

  //Carregamento:
  bool isLoading = true;

  //Recrutamento:
  bool isRecruiting = false;

  //Erro:
  String? errorMessage;

  @override
  void initState() {
    super.initState();

    //Recupera os repositórios:
    heroesRepo =
        Provider.of<HeroRepositoryImpl>(
          context,
          listen: false,
        );

    squadRepo =
        Provider.of<SquadRepositoryImpl>(
          context,
          listen: false,
        );

    //Carrega o contrato:
    _loadDailyHero();
  }

  //Carrega ou sorteia o herói:
  Future<void> _loadDailyHero() async {
    try {
      final preferences =
      await SharedPreferences
          .getInstance();

      //Data atual:
      final today =
          DateTime.now()
              .toIso8601String()
              .split('T')
              .first;

      //Dados salvos:
      final savedDate =
      preferences.getString(
        _heroDateKey,
      );

      final savedHeroId =
      preferences.getInt(
        _heroIdKey,
      );

      int heroId;

      //Mantém o sorteio do dia:
      if (savedDate == today &&
          savedHeroId != null) {
        heroId = savedHeroId;
      } else {
        //Sorteia um novo herói:
        heroId =
            Random().nextInt(
              _totalHeroes,
            ) +
                1;

        //Salva a data:
        await preferences.setString(
          _heroDateKey,
          today,
        );

        //Salva o ID:
        await preferences.setInt(
          _heroIdKey,
          heroId,
        );
      }

      //Busca o herói:
      final hero =
      await heroesRepo.getHeroById(
        id: heroId,
      );

      //Verifica se já foi recrutado:
      final recruited =
      await squadRepo.isRecruited(
        heroId: hero.id,
      );

      if (!mounted) {
        return;
      }

      //Atualiza a tela:
      setState(() {
        dailyHero = hero;
        isRecruited = recruited;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  //Recruta o agente:
  Future<void> _recruitHero() async {
    if (dailyHero == null ||
        isRecruiting) {
      return;
    }

    setState(() {
      isRecruiting = true;
    });

    try {
      //Verifica duplicidade:
      final recruited =
      await squadRepo.isRecruited(
        heroId: dailyHero!.id,
      );

      if (recruited) {
        if (!mounted) {
          return;
        }

        setState(() {
          isRecruited = true;
          isRecruiting = false;
        });

        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              'Este agente já está no esquadrão.',
            ),
          ),
        );

        return;
      }

      //Verifica o limite:
      final count =
      await squadRepo
          .getSquadCount();

      if (count >= 15) {
        if (!mounted) {
          return;
        }

        setState(() {
          isRecruiting = false;
        });

        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              'Seu esquadrão já possui 15 agentes.',
            ),
          ),
        );

        return;
      }

      //Recruta:
      await squadRepo.recruit(
        hero: dailyHero!,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        isRecruited = true;
        isRecruiting = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            '${dailyHero!.name} foi recrutado!',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        isRecruiting = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'Erro ao recrutar agente: $e',
          ),
        ),
      );
    }
  }

  //Cria um atributo:
  Widget _buildStat(
      String name,
      int value,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
        ),
        borderRadius:
        BorderRadius.circular(
          10,
        ),
      ),
      child: Text(
        '$name: $value',
      ),
    );
  }

  //Cria o card diário:
  Widget _buildDailyCard(
      Hero hero,
      ) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(
          16,
        ),
        child: Column(
          children: [
            //Imagem:
            ClipRRect(
              borderRadius:
              BorderRadius.circular(
                12,
              ),
              child:
              CachedNetworkImage(
                imageUrl:
                hero.largeImage,
                width: 220,
                height: 280,
                fit: BoxFit.cover,

                placeholder:
                    (context, url) =>
                const SizedBox(
                  width: 220,
                  height: 280,
                  child: Center(
                    child:
                    CircularProgressIndicator(),
                  ),
                ),

                errorWidget:
                    (
                    context,
                    url,
                    error,
                    ) =>
                const SizedBox(
                  width: 220,
                  height: 280,
                  child: Icon(
                    Icons
                        .image_not_supported,
                    size: 70,
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 16,
            ),

            //Nome:
            Text(
              hero.name,
              style:
              Theme.of(context)
                  .textTheme
                  .headlineSmall,
            ),

            const SizedBox(
              height: 16,
            ),

            //Powerstats:
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment:
              WrapAlignment.center,
              children: [
                _buildStat(
                  'Inteligência',
                  hero.intelligence,
                ),
                _buildStat(
                  'Força',
                  hero.strength,
                ),
                _buildStat(
                  'Velocidade',
                  hero.speed,
                ),
                _buildStat(
                  'Durabilidade',
                  hero.durability,
                ),
                _buildStat(
                  'Poder',
                  hero.power,
                ),
                _buildStat(
                  'Combate',
                  hero.combat,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(
      BuildContext context,
      ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Contrato Diário',
        ),
      ),

      body: _buildContent(),
    );
  }

  //Monta a tela:
  Widget _buildContent() {
    if (isLoading) {
      return const Center(
        child:
        CircularProgressIndicator(),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding:
          const EdgeInsets.all(
            16,
          ),
          child: Text(
            'Erro ao carregar o contrato.\n$errorMessage',
            textAlign:
            TextAlign.center,
          ),
        ),
      );
    }

    if (dailyHero != null) {
      return SingleChildScrollView(
        padding:
        const EdgeInsets.all(
          16,
        ),
        child: Column(
          children: [
            const Text(
              'Agente disponível hoje',
              style: TextStyle(
                fontSize: 20,
                fontWeight:
                FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 16,
            ),

            //Card do contrato:
            _buildDailyCard(
              dailyHero!,
            ),

            const SizedBox(
              height: 20,
            ),

            //Recrutamento:
            SizedBox(
              width:
              double.infinity,
              child:
              ElevatedButton(
                onPressed:
                isRecruited ||
                    isRecruiting
                    ? null
                    : _recruitHero,

                child:
                isRecruiting
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child:
                  CircularProgressIndicator(
                    strokeWidth:
                    2,
                  ),
                )
                    : Text(
                  isRecruited
                      ? 'Agente recrutado'
                      : 'Recrutar para o Esquadrão',
                ),
              ),
            ),
          ],
        ),
      );
    }

    return const Center(
      child: Text(
        'Nenhum agente encontrado.',
      ),
    );
  }
}