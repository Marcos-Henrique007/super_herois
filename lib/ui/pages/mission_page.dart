import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart' hide Hero;
import 'package:provider/provider.dart';

import '../../data/repository/hero_repository_impl.dart';
import '../../data/repository/squad_repository_impl.dart';
import '../../domain/hero.dart';
import '../widgets/hero_card.dart';

class MissionPage extends StatefulWidget {
  const MissionPage({
    super.key,
  });

  @override
  State<MissionPage> createState() =>
      _MissionPageState();
}

class _MissionPageState extends State<MissionPage> {
  //Repositório do esquadrão:
  late final SquadRepositoryImpl squadRepo;

  //Repositório dos heróis:
  late final HeroRepositoryImpl heroesRepo;

  //Agentes disponíveis:
  List<Hero> squadHeroes = [];

  //IDs dos agentes já utilizados:
  final Set<int> usedHeroIds = {};

  //Quantidade total de rodadas:
  int totalRounds = 0;

  //Rodada atual:
  int currentRound = 0;

  //Vitórias:
  int wins = 0;

  //Derrotas:
  int losses = 0;

  //Empates:
  int draws = 0;

  //Atributo da rodada:
  String? dominantAttribute;

  //Inimigo da rodada:
  Hero? enemyHero;

  //Controle de carregamento:
  bool isLoading = true;

  //Controle da preparação da rodada:
  bool isPreparingRound = false;

  //Indica se a missão foi iniciada:
  bool missionStarted = false;

  //Indica se a missão terminou:
  bool missionFinished = false;

  //Impede selecionar dois agentes:
  bool roundFinished = false;

  //Mensagem de erro:
  String? errorMessage;

  //Atributos disponíveis:
  final List<String> attributes = [
    'Inteligência',
    'Força',
    'Velocidade',
    'Durabilidade',
    'Poder',
    'Combate',
  ];

  @override
  void initState() {
    super.initState();

    //Recupera o repositório do esquadrão:
    squadRepo =
        Provider.of<SquadRepositoryImpl>(
          context,
          listen: false,
        );

    //Recupera o repositório dos heróis:
    heroesRepo =
        Provider.of<HeroRepositoryImpl>(
          context,
          listen: false,
        );

    //Carrega o esquadrão:
    _loadSquad();
  }

  //Carrega os agentes disponíveis:
  Future<void> _loadSquad() async {
    try {
      final heroes =
      await squadRepo.getSquad();

      if (!mounted) {
        return;
      }

      //Atualiza os agentes:
      setState(() {
        squadHeroes = heroes;
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

  //Inicia uma nova missão:
  Future<void> _startMission() async {
    //Exige pelo menos cinco agentes:
    if (squadHeroes.length < 5) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Você precisa de pelo menos 5 agentes para iniciar uma missão.',
          ),
        ),
      );

      return;
    }

    //Sorteia entre três e cinco rodadas:
    final rounds =
        Random().nextInt(3) + 3;

    //Reinicia os dados da missão:
    usedHeroIds.clear();

    setState(() {
      totalRounds = rounds;
      currentRound = 1;

      wins = 0;
      losses = 0;
      draws = 0;

      missionStarted = true;
      missionFinished = false;
      roundFinished = false;
    });

    //Prepara a primeira rodada:
    await _prepareRound();
  }

  //Prepara uma rodada:
  Future<void> _prepareRound() async {
    setState(() {
      isPreparingRound = true;
      roundFinished = false;
      enemyHero = null;
      dominantAttribute = null;
    });

    try {
      //Sorteia o atributo dominante:
      final attribute =
      attributes[
      Random().nextInt(
        attributes.length,
      )
      ];

      //Sorteia o inimigo:
      final enemy =
      await _drawEnemy();

      if (!mounted) {
        return;
      }

      //Atualiza os dados da rodada:
      setState(() {
        dominantAttribute = attribute;
        enemyHero = enemy;
        isPreparingRound = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      //Exibe o erro:
      setState(() {
        errorMessage = e.toString();
        isPreparingRound = false;
      });
    }
  }

  //Sorteia um inimigo fora do esquadrão:
  Future<Hero> _drawEnemy() async {
    final random = Random();

    //IDs dos agentes recrutados:
    final squadIds =
    squadHeroes
        .map(
          (hero) => hero.id,
    )
        .toSet();

    //Tenta encontrar um inimigo válido:
    for (
    int attempt = 0;
    attempt < 20;
    attempt++
    ) {
      //Sorteia uma página:
      final page =
          random.nextInt(57) + 1;

      //Busca os heróis:
      final heroes =
      await heroesRepo.getHeroes(
        page: page,
        limit: 10,
      );

      //Remove quem pertence ao esquadrão:
      final possibleEnemies =
      heroes
          .where(
            (hero) =>
        !squadIds.contains(
          hero.id,
        ),
      )
          .toList();

      //Retorna um inimigo válido:
      if (possibleEnemies.isNotEmpty) {
        return possibleEnemies[
        random.nextInt(
          possibleEnemies.length,
        )
        ];
      }
    }

    throw Exception(
      'Não foi possível sortear um inimigo.',
    );
  }

  //Retorna o valor do atributo:
  int _getAttributeValue(
      Hero hero,
      String attribute,
      ) {
    switch (attribute) {
      case 'Inteligência':
        return hero.intelligence;

      case 'Força':
        return hero.strength;

      case 'Velocidade':
        return hero.speed;

      case 'Durabilidade':
        return hero.durability;

      case 'Poder':
        return hero.power;

      case 'Combate':
        return hero.combat;

      default:
        return 0;
    }
  }

  //Seleciona um agente para a rodada:
  void _selectHero(
      Hero hero,
      ) {
    if (roundFinished ||
        enemyHero == null ||
        dominantAttribute == null) {
      return;
    }

    //Impede reutilizar o mesmo agente:
    if (usedHeroIds.contains(hero.id)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Este agente já participou desta missão.',
          ),
        ),
      );

      return;
    }

    //Marca o agente como utilizado:
    usedHeroIds.add(
      hero.id,
    );

    //Obtém os valores da rodada:
    final heroValue =
    _getAttributeValue(
      hero,
      dominantAttribute!,
    );

    final enemyValue =
    _getAttributeValue(
      enemyHero!,
      dominantAttribute!,
    );

    String resultTitle;
    String resultMessage;
    DialogType dialogType;

    //Compara os atributos:
    if (heroValue > enemyValue) {
      wins++;

      resultTitle =
      'Vitória!';

      resultMessage =
      '${hero.name} venceu ${enemyHero!.name}.\n\n'
          '$dominantAttribute\n'
          '${hero.name}: $heroValue\n'
          '${enemyHero!.name}: $enemyValue';

      dialogType =
          DialogType.success;
    } else if (heroValue < enemyValue) {
      losses++;

      resultTitle =
      'Derrota!';

      resultMessage =
      '${hero.name} perdeu para ${enemyHero!.name}.\n\n'
          '$dominantAttribute\n'
          '${hero.name}: $heroValue\n'
          '${enemyHero!.name}: $enemyValue';

      dialogType =
          DialogType.error;
    } else {
      draws++;

      resultTitle =
      'Empate!';

      resultMessage =
      '${hero.name} empatou com ${enemyHero!.name}.\n\n'
          '$dominantAttribute\n'
          '${hero.name}: $heroValue\n'
          '${enemyHero!.name}: $enemyValue';

      dialogType =
          DialogType.info;
    }

    //Impede outra escolha:
    setState(() {
      roundFinished = true;
    });

    //Exibe o resultado da rodada:
    AwesomeDialog(
      context: context,
      dialogType: dialogType,
      animType: AnimType.scale,
      title: resultTitle,
      desc: resultMessage,
      btnOkText: 'Continuar',

      //Avança a missão:
      btnOkOnPress: () {
        _nextRound();
      },
    ).show();
  }

  //Avança para a próxima rodada:
  void _nextRound() {
    //Verifica se era a última rodada:
    if (currentRound >= totalRounds) {
      setState(() {
        missionFinished = true;
      });

      return;
    }

    //Avança a rodada:
    setState(() {
      currentRound++;
    });

    //Prepara o próximo confronto:
    _prepareRound();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //Título da tela:
        title: const Text(
          'Missões',
        ),
      ),

      body: _buildContent(),
    );
  }

  //Monta o conteúdo da tela:
  Widget _buildContent() {
    //Exibe o carregamento:
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    //Exibe erro:
    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(
            16,
          ),
          child: Text(
            'Erro ao carregar a missão.\n$errorMessage',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    //Exibe o resultado final:
    if (missionFinished) {
      return _buildMissionResult();
    }

    //Exibe a missão:
    if (missionStarted) {
      return _buildMission();
    }

    //Exibe a tela inicial:
    return _buildMissionStart();
  }

  //Monta a tela inicial:
  Widget _buildMissionStart() {
    final canStartMission =
        squadHeroes.length >= 5;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(
          24,
        ),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.shield,
              size: 80,
            ),

            const SizedBox(
              height: 24,
            ),

            Text(
              'Preparar Missão',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall,
            ),

            const SizedBox(
              height: 16,
            ),

            Text(
              'Agentes disponíveis: ${squadHeroes.length}/15',
            ),

            const SizedBox(
              height: 8,
            ),

            Text(
              canStartMission
                  ? 'Seu esquadrão está pronto.'
                  : 'São necessários pelo menos 5 agentes.',
              textAlign:
              TextAlign.center,
            ),

            const SizedBox(
              height: 24,
            ),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                //Inicia a missão:
                onPressed:
                _startMission,

                child: const Text(
                  'Iniciar missão',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Monta a missão:
  Widget _buildMission() {
    //Aguarda a rodada:
    if (isPreparingRound) {
      return const Center(
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),

            SizedBox(
              height: 16,
            ),

            Text(
              'Preparando rodada...',
            ),
          ],
        ),
      );
    }

    //Agentes ainda disponíveis:
    final availableHeroes =
    squadHeroes
        .where(
          (hero) =>
      !usedHeroIds.contains(
        hero.id,
      ),
    )
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(
        16,
      ),
      child: Column(
        children: [
          //Rodada:
          Text(
            'Rodada $currentRound de $totalRounds',
            style: Theme.of(context)
                .textTheme
                .headlineSmall,
          ),

          const SizedBox(
            height: 16,
          ),

          //Placar:
          Text(
            'Vitórias: $wins   '
                'Derrotas: $losses   '
                'Empates: $draws',
          ),

          const SizedBox(
            height: 20,
          ),

          //Atributo dominante:
          Card(
            child: Padding(
              padding: const EdgeInsets.all(
                16,
              ),
              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.bolt,
                  ),

                  const SizedBox(
                    width: 8,
                  ),

                  Text(
                    'Atributo: $dominantAttribute',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          Text(
            'Inimigo',
            style: Theme.of(context)
                .textTheme
                .titleLarge,
          ),

          const SizedBox(
            height: 12,
          ),

          //Inimigo:
          if (enemyHero != null)
            HeroCard(
              hero: enemyHero!,
            ),

          const SizedBox(
            height: 24,
          ),

          Text(
            'Escolha seu agente',
            style: Theme.of(context)
                .textTheme
                .titleLarge,
          ),

          const SizedBox(
            height: 8,
          ),

          const Text(
            'Cada agente só pode participar de uma rodada.',
            textAlign:
            TextAlign.center,
          ),

          const SizedBox(
            height: 16,
          ),

          //Agentes disponíveis:
          ...availableHeroes.map(
                (hero) => HeroCard(
              hero: hero,

              //Seleciona o agente:
              onTap: () {
                _selectHero(
                  hero,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  //Monta o resultado final:
  Widget _buildMissionResult() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(
          24,
        ),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.flag,
              size: 80,
            ),

            const SizedBox(
              height: 24,
            ),

            Text(
              'Missão finalizada',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall,
            ),

            const SizedBox(
              height: 24,
            ),

            Text(
              'Vitórias: $wins',
            ),

            Text(
              'Derrotas: $losses',
            ),

            Text(
              'Empates: $draws',
            ),

            const SizedBox(
              height: 24,
            ),

            const Text(
              'A recompensa da missão será adicionada na próxima etapa.',
              textAlign:
              TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}