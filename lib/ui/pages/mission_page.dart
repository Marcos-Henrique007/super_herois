import 'dart:math';

import 'package:flutter/material.dart' hide Hero;
import 'package:provider/provider.dart';

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

class _MissionPageState extends State<MissionPage> {
  //Repositório do esquadrão:
  late final SquadRepositoryImpl squadRepo;

  //Agentes disponíveis:
  List<Hero> squadHeroes = [];

  //Quantidade total de rodadas:
  int totalRounds = 0;

  //Rodada atual:
  int currentRound = 0;

  //Controle de carregamento:
  bool isLoading = true;

  //Indica se a missão foi iniciada:
  bool missionStarted = false;

  //Mensagem de erro:
  String? errorMessage;

  @override
  void initState() {
    super.initState();

    //Recupera o repositório do esquadrão:
    squadRepo =
        Provider.of<SquadRepositoryImpl>(
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
  void _startMission() {
    //Exige pelo menos cinco agentes:
    if (squadHeroes.length < 5) {
      ScaffoldMessenger.of(context).showSnackBar(
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

    //Inicia a missão:
    setState(() {
      totalRounds = rounds;
      currentRound = 1;
      missionStarted = true;
    });
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

    //Exibe a missão iniciada:
    if (missionStarted) {
      return _buildMission();
    }

    //Exibe a tela inicial da missão:
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

            //Quantidade de agentes:
            Text(
              'Agentes disponíveis: ${squadHeroes.length}/15',
            ),

            const SizedBox(
              height: 8,
            ),

            //Informa o requisito:
            Text(
              canStartMission
                  ? 'Seu esquadrão está pronto.'
                  : 'São necessários pelo menos 5 agentes.',
              textAlign: TextAlign.center,
            ),

            const SizedBox(
              height: 24,
            ),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                //Inicia a missão:
                onPressed: _startMission,

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

  //Monta a missão em andamento:
  Widget _buildMission() {
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
              Icons.local_fire_department,
              size: 80,
            ),

            const SizedBox(
              height: 24,
            ),

            //Rodada atual:
            Text(
              'Rodada $currentRound de $totalRounds',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall,
            ),

            const SizedBox(
              height: 16,
            ),

            Text(
              'A missão terá $totalRounds rodadas.',
              textAlign: TextAlign.center,
            ),

            const SizedBox(
              height: 16,
            ),

            const Text(
              'O inimigo e o atributo da rodada serão sorteados na próxima etapa.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}