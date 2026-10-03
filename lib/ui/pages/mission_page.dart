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

  //Agentes do esquadrão:
  List<Hero> squadHeroes = [];

  //IDs dos agentes já utilizados:
  final Set<int> usedHeroIds = {};

  //Agentes que venceram rodadas:
  final List<Hero> winningHeroes = [];

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

  //Resultado final:
  bool missionSuccess = false;

  //Agente que recebeu recompensa:
  Hero? rewardedHero;

  //Atributo melhorado:
  String? rewardedAttribute;

  //Valor anterior:
  int? oldAttributeValue;

  //Novo valor:
  int? newAttributeValue;

  //Controle de carregamento:
  bool isLoading = true;

  //Controle da preparação:
  bool isPreparingRound = false;

  //Indica se a missão iniciou:
  bool missionStarted = false;

  //Indica se a missão terminou:
  bool missionFinished = false;

  //Impede duas escolhas na rodada:
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

      //Atualiza o esquadrão:
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

    //Limpa os dados anteriores:
    usedHeroIds.clear();
    winningHeroes.clear();

    setState(() {
      totalRounds = rounds;
      currentRound = 1;

      wins = 0;
      losses = 0;
      draws = 0;

      missionSuccess = false;

      rewardedHero = null;
      rewardedAttribute = null;
      oldAttributeValue = null;
      newAttributeValue = null;

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

      //Atualiza a rodada:
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

    //Tenta encontrar um inimigo:
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

      //Remove integrantes do esquadrão:
      final possibleEnemies =
      heroes
          .where(
            (hero) =>
        !squadIds.contains(
          hero.id,
        ),
      )
          .toList();

      //Retorna um inimigo:
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

  //Retorna o valor de um atributo:
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

  //Cria um herói com atributo melhorado:
  Hero _upgradeAttribute(
      Hero hero,
      String attribute,
      ) {
    switch (attribute) {
      case 'Inteligência':
        return hero.copyWith(
          intelligence:
          hero.intelligence + 1,
        );

      case 'Força':
        return hero.copyWith(
          strength:
          hero.strength + 1,
        );

      case 'Velocidade':
        return hero.copyWith(
          speed:
          hero.speed + 1,
        );

      case 'Durabilidade':
        return hero.copyWith(
          durability:
          hero.durability + 1,
        );

      case 'Poder':
        return hero.copyWith(
          power:
          hero.power + 1,
        );

      case 'Combate':
        return hero.copyWith(
          combat:
          hero.combat + 1,
        );

      default:
        return hero;
    }
  }

  //Seleciona um agente:
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

    //Obtém os valores:
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

      //Guarda quem venceu:
      winningHeroes.add(
        hero,
      );

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

    //Finaliza a rodada:
    setState(() {
      roundFinished = true;
    });

    //Exibe o resultado:
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

  //Avança a missão:
  void _nextRound() {
    //Verifica se era a última:
    if (currentRound >= totalRounds) {
      _finishMission();

      return;
    }

    //Avança a rodada:
    setState(() {
      currentRound++;
    });

    //Prepara o próximo confronto:
    _prepareRound();
  }

  //Finaliza a missão:
  Future<void> _finishMission() async {
    //Vitória exige mais da metade das rodadas:
    final success =
        wins > totalRounds / 2;

    if (success &&
        winningHeroes.isNotEmpty) {
      final random = Random();

      //Sorteia um agente vencedor:
      final hero =
      winningHeroes[
      random.nextInt(
        winningHeroes.length,
      )
      ];

      //Sorteia um atributo:
      final attribute =
      attributes[
      random.nextInt(
        attributes.length,
      )
      ];

      //Valor antigo:
      final oldValue =
      _getAttributeValue(
        hero,
        attribute,
      );

      //Aplica a melhoria:
      final upgradedHero =
      _upgradeAttribute(
        hero,
        attribute,
      );

      //Valor novo:
      final newValue =
      _getAttributeValue(
        upgradedHero,
        attribute,
      );

      //Salva a melhoria no banco:
      await squadRepo.updateHero(
        hero: upgradedHero,
      );

      //Atualiza o herói na lista local:
      final index =
      squadHeroes.indexWhere(
            (item) =>
        item.id == upgradedHero.id,
      );

      if (index != -1) {
        squadHeroes[index] =
            upgradedHero;
      }

      if (!mounted) {
        return;
      }

      //Guarda a recompensa:
      setState(() {
        missionSuccess = true;

        rewardedHero =
            upgradedHero;

        rewardedAttribute =
            attribute;

        oldAttributeValue =
            oldValue;

        newAttributeValue =
            newValue;

        missionFinished = true;
      });

      //Exibe sucesso:
      AwesomeDialog(
        context: context,
        dialogType:
        DialogType.success,
        animType:
        AnimType.scale,
        title:
        'Missão concluída!',
        desc:
        'Seu esquadrão venceu a missão.\n\n'
            '${upgradedHero.name} recebeu uma melhoria!\n'
            '$attribute: $oldValue → $newValue',
        btnOkText:
        'Continuar',
        btnOkOnPress: () {},
      ).show();

      return;
    }

    if (!mounted) {
      return;
    }

    //Finaliza como derrota:
    setState(() {
      missionSuccess = false;
      missionFinished = true;
    });

    //Exibe falha:
    AwesomeDialog(
      context: context,
      dialogType:
      DialogType.error,
      animType:
      AnimType.scale,
      title:
      'Missão fracassada',
      desc:
      'Seu esquadrão não venceu a maioria das rodadas.',
      btnOkText:
      'Continuar',
      btnOkOnPress: () {},
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //Título:
        title: const Text(
          'Missões',
        ),
      ),

      body: _buildContent(),
    );
  }

  //Monta o conteúdo:
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
            'Erro ao carregar a missão.\n$errorMessage',
            textAlign:
            TextAlign.center,
          ),
        ),
      );
    }

    //Resultado final:
    if (missionFinished) {
      return _buildMissionResult();
    }

    //Missão em andamento:
    if (missionStarted) {
      return _buildMission();
    }

    //Início:
    return _buildMissionStart();
  }

  //Monta o início:
  Widget _buildMissionStart() {
    final canStartMission =
        squadHeroes.length >= 5;

    return Center(
      child: Padding(
        padding:
        const EdgeInsets.all(
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
              style:
              Theme.of(context)
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
              width:
              double.infinity,
              child:
              ElevatedButton(
                //Inicia a missão:
                onPressed:
                _startMission,

                child:
                const Text(
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

    //Agentes disponíveis:
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
      padding:
      const EdgeInsets.all(
        16,
      ),
      child: Column(
        children: [
          //Rodada:
          Text(
            'Rodada $currentRound de $totalRounds',
            style:
            Theme.of(context)
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

          //Atributo:
          Card(
            child: Padding(
              padding:
              const EdgeInsets.all(
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
                    style:
                    Theme.of(context)
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
            style:
            Theme.of(context)
                .textTheme
                .titleLarge,
          ),

          const SizedBox(
            height: 12,
          ),

          //Inimigo:
          if (enemyHero != null)
            HeroCard(
              hero:
              enemyHero!,
            ),

          const SizedBox(
            height: 24,
          ),

          Text(
            'Escolha seu agente',
            style:
            Theme.of(context)
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

  //Monta o resultado:
  Widget _buildMissionResult() {
    return Center(
      child: SingleChildScrollView(
        padding:
        const EdgeInsets.all(
          24,
        ),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Icon(
              missionSuccess
                  ? Icons
                  .emoji_events
                  : Icons.close,
              size: 80,
            ),

            const SizedBox(
              height: 24,
            ),

            Text(
              missionSuccess
                  ? 'Missão concluída!'
                  : 'Missão fracassada',
              style:
              Theme.of(context)
                  .textTheme
                  .headlineSmall,
            ),

            const SizedBox(
              height: 24,
            ),

            //Resumo:
            Text(
              'Vitórias: $wins',
            ),

            Text(
              'Derrotas: $losses',
            ),

            Text(
              'Empates: $draws',
            ),

            //Recompensa:
            if (missionSuccess &&
                rewardedHero != null &&
                rewardedAttribute != null) ...[
              const SizedBox(
                height: 24,
              ),

              const Text(
                'Recompensa',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 12,
              ),

              Text(
                '${rewardedHero!.name} recebeu +1 em $rewardedAttribute',
                textAlign:
                TextAlign.center,
              ),

              const SizedBox(
                height: 8,
              ),

              Text(
                '$oldAttributeValue → $newAttributeValue',
              ),
            ],

            const SizedBox(
              height: 32,
            ),

            SizedBox(
              width:
              double.infinity,
              child:
              ElevatedButton(
                //Inicia outra missão:
                onPressed: () {
                  setState(() {
                    missionStarted =
                    false;

                    missionFinished =
                    false;
                  });
                },

                child:
                const Text(
                  'Voltar',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}