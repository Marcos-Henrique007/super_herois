import 'dart:math';

import 'package:flutter/material.dart' hide Hero;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/repository/hero_repository_impl.dart';
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

  //Chaves utilizadas no SharedPreferences:
  static const String _heroIdKey =
      'daily_hero_id';

  static const String _heroDateKey =
      'daily_hero_date';

  //Quantidade de heróis disponíveis:
  static const int _totalHeroes = 563;

  //Repositório:
  late final HeroRepositoryImpl heroesRepo;

  //Herói sorteado:
  Hero? dailyHero;

  //Controle de carregamento:
  bool isLoading = true;

  //Mensagem de erro:
  String? errorMessage;

  @override
  void initState() {
    super.initState();

    //Recupera o repository pelo Provider:
    heroesRepo =
        Provider.of<HeroRepositoryImpl>(
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

      //Busca os dados salvos:
      final savedDate =
      preferences.getString(
        _heroDateKey,
      );

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

      if (!mounted) {
        return;
      }

      //Atualiza a tela:
      setState(() {
        dailyHero = hero;
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
        child: Text(
          'Erro ao carregar o contrato.\n$errorMessage',
          textAlign: TextAlign.center,
        ),
      );
    }

    //Exibe o herói sorteado:
    if (dailyHero != null) {
      return Padding(
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

            HeroCard(
              hero: dailyHero!,
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