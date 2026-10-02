import 'dart:math';

import 'package:flutter/material.dart' hide Hero;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/repository/hero_repository_impl.dart';
import '../../data/repository/squad_repository_impl.dart';
import '../../domain/hero.dart';
import '../widgets/hero_card.dart';

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

  //Quantidade de heróis disponíveis:
  static const int _totalHeroes = 563;

  //Repositório dos heróis:
  late final HeroRepositoryImpl heroesRepo;

  //Repositório do esquadrão:
  late final SquadRepositoryImpl squadRepo;

  //Herói sorteado:
  Hero? dailyHero;

  //Indica se o herói já foi recrutado:
  bool isRecruited = false;

  //Controle de carregamento:
  bool isLoading = true;

  //Controle do recrutamento:
  bool isRecruiting = false;

  //Mensagem de erro:
  String? errorMessage;

  @override
  void initState() {
    super.initState();

    //Recupera o repositório dos heróis:
    heroesRepo =
        Provider.of<HeroRepositoryImpl>(
          context,
          listen: false,
        );

    //Recupera o repositório do esquadrão:
    squadRepo =
        Provider.of<SquadRepositoryImpl>(
          context,
          listen: false,
        );

    //Carrega o herói do dia:
    _loadDailyHero();
  }

  //Carrega ou sorteia o herói diário:
  Future<void> _loadDailyHero() async {
    try {
      final preferences =
      await SharedPreferences.getInstance();

      //Obtém a data atual:
      final today =
          DateTime.now()
              .toIso8601String()
              .split('T')
              .first;

      //Busca a data salva:
      final savedDate =
      preferences.getString(
        _heroDateKey,
      );

      //Busca o ID salvo:
      final savedHeroId =
      preferences.getInt(
        _heroIdKey,
      );

      int heroId;

      //Verifica se já existe sorteio para hoje:
      if (savedDate == today &&
          savedHeroId != null) {

        //Mantém o mesmo herói:
        heroId = savedHeroId;
      } else {

        //Sorteia um novo herói:
        heroId =
            Random().nextInt(
              _totalHeroes,
            ) +
                1;

        //Salva a data do sorteio:
        await preferences.setString(
          _heroDateKey,
          today,
        );

        //Salva o ID sorteado:
        await preferences.setInt(
          _heroIdKey,
          heroId,
        );
      }

      //Busca os dados completos do herói:
      final hero =
      await heroesRepo.getHeroById(
        id: heroId,
      );

      //Verifica se o agente já foi recrutado:
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

      //Exibe o erro:
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

    //Inicia o recrutamento:
    setState(() {
      isRecruiting = true;
    });

    try {
      //Verifica se já foi recrutado:
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

      //Busca a quantidade de agentes:
      final count =
      await squadRepo.getSquadCount();

      //Verifica o limite do esquadrão:
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

      //Atualiza o estado do botão:
      setState(() {
        isRecruited = true;
        isRecruiting = false;
      });

      //Confirma o recrutamento:
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //Título da tela:
        title: const Text(
          'Contrato Diário',
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
          padding: const EdgeInsets.all(16),
          child: Text(
            'Erro ao carregar o contrato.\n$errorMessage',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    //Exibe o herói sorteado:
    if (dailyHero != null) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Agente disponível hoje',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 16,
            ),

            //Exibe o agente sorteado:
            HeroCard(
              hero: dailyHero!,
            ),

            const SizedBox(
              height: 20,
            ),

            //Botão de recrutamento:
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                isRecruited ||
                    isRecruiting
                    ? null
                    : _recruitHero,

                child: isRecruiting
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child:
                  CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
                    : Text(
                  isRecruited
                      ? 'Agente recrutado'
                      : 'Recrutar',
                ),
              ),
            ),
          ],
        ),
      );
    }

    //Caso nenhum herói seja encontrado:
    return const Center(
      child: Text(
        'Nenhum agente encontrado.',
      ),
    );
  }
}