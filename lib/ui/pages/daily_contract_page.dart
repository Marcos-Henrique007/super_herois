import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide Hero;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/repository/hero_repository_impl.dart';
import '../../data/repository/squad_repository_impl.dart';
import '../../domain/hero.dart';

class DailyContractPage extends StatefulWidget {
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

  //Sorteia um herói que realmente existe:
  Future<Hero> _drawHero() async {
    //Busca o catálogo salvo:
    final heroes =
    await heroesRepo.getHeroes(
      page: 1,
      limit: 1000,
    );

    //Verifica se existem heróis:
    if (heroes.isEmpty) {
      throw Exception(
        'Nenhum herói disponível.',
      );
    }

    //Sorteia uma posição da lista:
    final index =
    Random().nextInt(
      heroes.length,
    );

    //Retorna um herói real:
    return heroes[index];
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

      //Data salva:
      final savedDate =
      preferences.getString(
        _heroDateKey,
      );

      //ID salvo:
      final savedHeroId =
      preferences.getInt(
        _heroIdKey,
      );

      Hero hero;

      //Mantém o herói sorteado no mesmo dia:
      if (savedDate == today &&
          savedHeroId != null) {
        try {
          //Busca o herói salvo:
          hero =
          await heroesRepo
              .getHeroById(
            id: savedHeroId,
          );
        } catch (e) {
          //Corrige um ID antigo inválido:
          hero = await _drawHero();

          //Salva o novo ID válido:
          await preferences.setInt(
            _heroIdKey,
            hero.id,
          );
        }
      } else {
        //Sorteia um novo herói:
        hero = await _drawHero();

        //Salva a data:
        await preferences.setString(
          _heroDateKey,
          today,
        );

        //Salva o ID:
        await preferences.setInt(
          _heroIdKey,
          hero.id,
        );
      }

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
        errorMessage = null;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      //Exibe o erro:
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  //Recruta o agente:
  Future<void> _recruitHero() async {
    //Evita operações inválidas:
    if (dailyHero == null ||
        isRecruiting) {
      return;
    }

    //Inicia o carregamento:
    setState(() {
      isRecruiting = true;
    });

    try {
      //Verifica duplicidade:
      final recruited =
      await squadRepo.isRecruited(
        heroId: dailyHero!.id,
      );

      //Caso já esteja recrutado:
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

      //Conta os integrantes:
      final count =
      await squadRepo
          .getSquadCount();

      //Verifica o limite:
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

      //Recruta o agente:
      await squadRepo.recruit(
        hero: dailyHero!,
      );

      if (!mounted) {
        return;
      }

      //Atualiza o estado:
      setState(() {
        isRecruited = true;
        isRecruiting = false;
      });

      //Exibe a confirmação:
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

      //Finaliza o carregamento:
      setState(() {
        isRecruiting = false;
      });

      //Exibe o erro:
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
      padding:
      const EdgeInsets.symmetric(
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
        padding:
        const EdgeInsets.all(
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

                //Carregamento:
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

                //Erro:
                errorWidget: (
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
        //Título:
        title: const Text(
          'Contrato Diário',
        ),
      ),

      //Conteúdo:
      body: _buildContent(),
    );
  }

  //Monta a tela:
  Widget _buildContent() {
    //Carregamento:
    if (isLoading) {
      return const Center(
        child:
        CircularProgressIndicator(),
      );
    }

    //Erro:
    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding:
          const EdgeInsets.all(
            16,
          ),
          child: Text(
            'Erro ao carregar o contrato.\n'
                '$errorMessage',
            textAlign:
            TextAlign.center,
          ),
        ),
      );
    }

    //Herói encontrado:
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

            //Botão de recrutamento:
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

    //Nenhum herói:
    return const Center(
      child: Text(
        'Nenhum agente encontrado.',
      ),
    );
  }
}