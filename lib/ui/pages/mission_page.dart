import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide Hero;
import 'package:provider/provider.dart';

import '../../data/repository/hero_repository_impl.dart';
import '../../data/repository/squad_repository_impl.dart';
import '../../domain/hero.dart';

class MissionPage extends StatefulWidget {
  const MissionPage({
    super.key,
  });

  @override
  State<MissionPage> createState() =>
      _MissionPageState();
}

class _MissionPageState
    extends State<MissionPage> {
  //Repositórios:
  late final SquadRepositoryImpl squadRepo;
  late final HeroRepositoryImpl heroesRepo;

  //Esquadrão:
  List<Hero> squadHeroes = [];

  //Agentes utilizados:
  final Set<int> usedHeroIds = {};

  //Agentes vencedores:
  final List<Hero> winningHeroes = [];

  //Rodadas:
  int totalRounds = 0;
  int currentRound = 0;

  //Placar:
  int wins = 0;
  int losses = 0;
  int draws = 0;

  //Dados da rodada:
  String? dominantAttribute;
  Hero? enemyHero;

  //Resultado:
  bool missionSuccess = false;

  Hero? rewardedHero;
  String? rewardedAttribute;

  int? oldAttributeValue;
  int? newAttributeValue;

  //Estados:
  bool isLoading = true;
  bool isPreparingRound = false;
  bool missionStarted = false;
  bool missionFinished = false;
  bool roundFinished = false;

  String? errorMessage;

  //Atributos:
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

    //Recupera os repositórios:
    squadRepo =
        Provider.of<SquadRepositoryImpl>(
          context,
          listen: false,
        );

    heroesRepo =
        Provider.of<HeroRepositoryImpl>(
          context,
          listen: false,
        );

    //Carrega o esquadrão:
    _loadSquad();
  }

  //Carrega o esquadrão:
  Future<void> _loadSquad() async {
    try {
      final heroes =
      await squadRepo.getSquad();

      if (!mounted) {
        return;
      }

      setState(() {
        squadHeroes = heroes;
        isLoading = false;
        errorMessage = null;
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

  //Inicia a missão:
  Future<void> _startMission() async {
    //Exige cinco agentes:
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

    //Limpa os dados:
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
      //Sorteia o atributo:
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

      setState(() {
        dominantAttribute = attribute;
        enemyHero = enemy;
        isPreparingRound = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        errorMessage = e.toString();
        isPreparingRound = false;
      });
    }
  }

  //Sorteia um inimigo:
  Future<Hero> _drawEnemy() async {
    final random = Random();

    //IDs do esquadrão:
    final squadIds =
    squadHeroes
        .map(
          (hero) => hero.id,
    )
        .toSet();

    //Procura um inimigo válido:
    for (
    int attempt = 0;
    attempt < 20;
    attempt++
    ) {
      //Sorteia uma página:
      final page =
          random.nextInt(57) + 1;

      //Busca a página:
      final heroes =
      await heroesRepo.getHeroes(
        page: page,
        limit: 10,
      );

      //Remove membros do esquadrão:
      final possibleEnemies =
      heroes
          .where(
            (hero) =>
        !squadIds.contains(
          hero.id,
        ),
      )
          .toList();

      //Escolhe um inimigo:
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

  //Obtém o atributo:
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

  //Aumenta um atributo:
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

    //Impede reutilização:
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

    //Marca como utilizado:
    usedHeroIds.add(
      hero.id,
    );

    //Valor do agente:
    final heroValue =
    _getAttributeValue(
      hero,
      dominantAttribute!,
    );

    //Valor do inimigo:
    final enemyValue =
    _getAttributeValue(
      enemyHero!,
      dominantAttribute!,
    );

    String title;
    String message;
    DialogType type;

    //Vitória:
    if (heroValue > enemyValue) {
      wins++;

      winningHeroes.add(
        hero,
      );

      title = 'Vitória!';

      message =
      '${hero.name} venceu ${enemyHero!.name}.\n\n'
          '$dominantAttribute\n'
          '${hero.name}: $heroValue\n'
          '${enemyHero!.name}: $enemyValue';

      type =
          DialogType.success;

      //Derrota:
    } else if (heroValue < enemyValue) {
      losses++;

      title = 'Derrota!';

      message =
      '${hero.name} perdeu para ${enemyHero!.name}.\n\n'
          '$dominantAttribute\n'
          '${hero.name}: $heroValue\n'
          '${enemyHero!.name}: $enemyValue';

      type =
          DialogType.error;

      //Empate:
    } else {
      draws++;

      title = 'Empate!';

      message =
      '${hero.name} empatou com ${enemyHero!.name}.\n\n'
          '$dominantAttribute\n'
          '${hero.name}: $heroValue\n'
          '${enemyHero!.name}: $enemyValue';

      type =
          DialogType.info;
    }

    setState(() {
      roundFinished = true;
    });

    //Exibe o resultado:
    AwesomeDialog(
      context: context,
      dialogType: type,
      animType: AnimType.scale,
      title: title,
      desc: message,
      btnOkText: 'Continuar',

      btnOkOnPress: () {
        _nextRound();
      },
    ).show();
  }

  //Avança a rodada:
  Future<void> _nextRound() async {
    //Finaliza a missão:
    if (currentRound >= totalRounds) {
      await _finishMission();
      return;
    }

    //Avança:
    setState(() {
      currentRound++;
    });

    await _prepareRound();
  }

  //Finaliza a missão:
  Future<void> _finishMission() async {
    try {
      //Exige mais da metade:
      final success =
          wins > totalRounds / 2;

      //Missão cumprida:
      if (success &&
          winningHeroes.isNotEmpty) {
        final random =
        Random();

        //Sorteia um vencedor:
        final hero =
        winningHeroes[
        random.nextInt(
          winningHeroes.length,
        )
        ];

        //Sorteia o atributo:
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

        //Salva no SQLite:
        await squadRepo.updateHero(
          hero: upgradedHero,
        );

        //Atualiza a lista local:
        final index =
        squadHeroes.indexWhere(
              (item) =>
          item.id ==
              upgradedHero.id,
        );

        if (index != -1) {
          squadHeroes[index] =
              upgradedHero;
        }

        if (!mounted) {
          return;
        }

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

        //Feedback de sucesso:
        AwesomeDialog(
          context: context,
          dialogType:
          DialogType.success,
          animType:
          AnimType.scale,

          body: Column(
            children: [
              Text(
                'Missão Cumprida!',
                style:
                Theme.of(context)
                    .textTheme
                    .titleLarge,
              ),

              const SizedBox(
                height: 16,
              ),

              //Imagem do premiado:
              ClipRRect(
                borderRadius:
                BorderRadius.circular(
                  12,
                ),
                child:
                CachedNetworkImage(
                  imageUrl:
                  upgradedHero.image,
                  width: 120,
                  height: 150,
                  fit: BoxFit.cover,

                  placeholder:
                      (context, url) =>
                  const SizedBox(
                    width: 120,
                    height: 150,
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
                  const Icon(
                    Icons.person,
                    size: 80,
                  ),
                ),
              ),

              const SizedBox(
                height: 12,
              ),

              Text(
                upgradedHero.name,
                style:
                const TextStyle(
                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 8,
              ),

              Text(
                '$attribute: '
                    '$oldValue → $newValue',
              ),
            ],
          ),

          btnOkText:
          'Continuar',

          btnOkOnPress:
              () {},
        ).show();

        return;
      }

      if (!mounted) {
        return;
      }

      //Missão fracassada:
      setState(() {
        missionSuccess = false;
        missionFinished = true;
      });

      //Feedback de falha:
      AwesomeDialog(
        context: context,
        dialogType:
        DialogType.error,
        animType:
        AnimType.scale,

        body: Column(
          children: [
            Text(
              'Operação Fracassada!',
              style:
              Theme.of(context)
                  .textTheme
                  .titleLarge,
            ),

            const SizedBox(
              height: 16,
            ),

            //Imagem da derrota:
            if (enemyHero != null)
              ClipRRect(
                borderRadius:
                BorderRadius.circular(
                  12,
                ),
                child:
                CachedNetworkImage(
                  imageUrl:
                  enemyHero!.image,
                  width: 120,
                  height: 150,
                  fit: BoxFit.cover,

                  errorWidget:
                      (
                      context,
                      url,
                      error,
                      ) =>
                  const Icon(
                    Icons.warning,
                    size: 80,
                  ),
                ),
              )
            else
              const Icon(
                Icons
                    .sentiment_very_dissatisfied,
                size: 90,
              ),

            const SizedBox(
              height: 12,
            ),

            const Text(
              'Seu esquadrão não venceu a maioria das rodadas.',
              textAlign:
              TextAlign.center,
            ),
          ],
        ),

        btnOkText:
        'Continuar',

        btnOkOnPress:
            () {},
      ).show();
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        errorMessage =
            e.toString();
      });
    }
  }

  //Card do inimigo:
  Widget _buildEnemyCard() {
    if (enemyHero == null) {
      return const SizedBox();
    }

    return Card(
      elevation: 5,
      child: Padding(
        padding:
        const EdgeInsets.all(
          12,
        ),
        child: Row(
          children: [
            //Imagem:
            ClipRRect(
              borderRadius:
              BorderRadius.circular(
                10,
              ),
              child:
              CachedNetworkImage(
                imageUrl:
                enemyHero!.image,
                width: 100,
                height: 130,
                fit: BoxFit.cover,

                placeholder:
                    (context, url) =>
                const SizedBox(
                  width: 100,
                  height: 130,
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
                  width: 100,
                  height: 130,
                  child: Icon(
                    Icons
                        .image_not_supported,
                  ),
                ),
              ),
            ),

            const SizedBox(
              width: 16,
            ),

            //Somente o nome:
            Expanded(
              child: Text(
                enemyHero!.name,
                style:
                Theme.of(context)
                    .textTheme
                    .titleLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Miniatura de agente:
  Widget _buildAgentTile(
      Hero hero,
      ) {
    return Card(
      child: InkWell(
        borderRadius:
        BorderRadius.circular(
          12,
        ),

        //Seleciona o agente:
        onTap: () {
          _selectHero(
            hero,
          );
        },

        child: Padding(
          padding:
          const EdgeInsets.all(
            8,
          ),
          child: Column(
            children: [
              //Imagem circular:
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: ClipOval(
                    child:
                    CachedNetworkImage(
                      imageUrl:
                      hero.image,
                      fit: BoxFit.cover,

                      placeholder:
                          (
                          context,
                          url,
                          ) =>
                      const Center(
                        child:
                        CircularProgressIndicator(),
                      ),

                      errorWidget:
                          (
                          context,
                          url,
                          error,
                          ) =>
                      const Icon(
                        Icons.person,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 6,
              ),

              //Nome:
              Text(
                hero.name,
                maxLines: 1,
                overflow:
                TextOverflow.ellipsis,
                textAlign:
                TextAlign.center,
              ),
            ],
          ),
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
          'Missões',
        ),
      ),

      body: _buildContent(),
    );
  }

  //Monta o conteúdo:
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
            'Erro ao carregar a missão.\n$errorMessage',
            textAlign:
            TextAlign.center,
          ),
        ),
      );
    }

    if (missionFinished) {
      return _buildMissionResult();
    }

    if (missionStarted) {
      return _buildMission();
    }

    return _buildMissionStart();
  }

  //Início:
  Widget _buildMissionStart() {
    final canStart =
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
              'Agentes disponíveis: '
                  '${squadHeroes.length}/15',
            ),

            const SizedBox(
              height: 8,
            ),

            Text(
              canStart
                  ? 'Seu esquadrão está pronto.'
                  : 'São necessários pelo menos 5 agentes.',
            ),

            const SizedBox(
              height: 24,
            ),

            SizedBox(
              width:
              double.infinity,
              child:
              ElevatedButton(
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

  //Missão:
  Widget _buildMission() {
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

    //Remove agentes usados:
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
            height: 12,
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
                    'Desafio de '
                        '$dominantAttribute',
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
            'Inimigo da Rodada',
            style:
            Theme.of(context)
                .textTheme
                .titleLarge,
          ),

          const SizedBox(
            height: 12,
          ),

          //Não exibe atributos do inimigo:
          _buildEnemyCard(),

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
            'Cada agente só pode participar de uma rodada por missão.',
            textAlign:
            TextAlign.center,
          ),

          const SizedBox(
            height: 16,
          ),

          //Grid 3 colunas:
          GridView.builder(
            shrinkWrap: true,
            physics:
            const NeverScrollableScrollPhysics(),
            itemCount:
            availableHeroes.length,

            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.8,
            ),

            itemBuilder:
                (
                context,
                index,
                ) {
              return _buildAgentTile(
                availableHeroes[index],
              );
            },
          ),
        ],
      ),
    );
  }

  //Resultado:
  Widget _buildMissionResult() {
    return Center(
      child: SingleChildScrollView(
        padding:
        const EdgeInsets.all(
          24,
        ),
        child: Column(
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
                  ? 'Missão Cumprida!'
                  : 'Operação Fracassada!',
              style:
              Theme.of(context)
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

            //Recompensa:
            if (missionSuccess &&
                rewardedHero != null &&
                rewardedAttribute !=
                    null) ...[
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
                //Volta ao início:
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