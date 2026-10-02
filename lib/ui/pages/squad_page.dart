import 'package:flutter/material.dart' hide Hero;
import 'package:provider/provider.dart';

import '../../data/repository/squad_repository_impl.dart';
import '../../domain/hero.dart';
import '../widgets/hero_card.dart';
import 'hero_details_page.dart';

class SquadPage extends StatefulWidget {
  const SquadPage({
    super.key,
  });

  @override
  State<SquadPage> createState() =>
      _SquadPageState();
}

class _SquadPageState extends State<SquadPage> {
  //Repositório do esquadrão:
  late final SquadRepositoryImpl squadRepo;

  //Agentes recrutados:
  List<Hero> heroes = [];

  //Controle de carregamento:
  bool isLoading = true;

  //Mensagem de erro:
  String? errorMessage;

  @override
  void initState() {
    super.initState();

    //Recupera o repositório pelo Provider:
    squadRepo =
        Provider.of<SquadRepositoryImpl>(
          context,
          listen: false,
        );

    //Carrega o esquadrão:
    _loadSquad();
  }

  //Carrega os agentes recrutados:
  Future<void> _loadSquad() async {
    try {
      //Busca o esquadrão:
      final squadHeroes =
      await squadRepo.getSquad();

      if (!mounted) {
        return;
      }

      //Atualiza a tela:
      setState(() {
        heroes = squadHeroes;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //Título da tela:
        title: const Text(
          'Meu Esquadrão',
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
            'Erro ao carregar o esquadrão.\n$errorMessage',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    //Verifica se está vazio:
    if (heroes.isEmpty) {
      return const Center(
        child: Text(
          'Nenhum agente recrutado.',
        ),
      );
    }

    return Column(
      children: [
        //Quantidade de agentes:
        Padding(
          padding: const EdgeInsets.all(
            16,
          ),
          child: Text(
            'Agentes recrutados: ${heroes.length}/15',
            style: Theme.of(context)
                .textTheme
                .titleMedium,
          ),
        ),

        //Lista de agentes:
        Expanded(
          child: ListView.builder(
            itemCount: heroes.length,
            itemBuilder: (
                context,
                index,
                ) {
              final hero = heroes[index];

              return HeroCard(
                hero: hero,

                //Abre os detalhes do agente:
                onTap: () async {
                  final dismissed =
                  await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          HeroDetailsPage(
                            hero: hero,
                            canDismiss: true,
                          ),
                    ),
                  );

                  if (!mounted) {
                    return;
                  }

                  //Atualiza após uma dispensa:
                  if (dismissed == true) {
                    await _loadSquad();
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }
}