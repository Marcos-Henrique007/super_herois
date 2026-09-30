import 'package:flutter/material.dart' hide Hero;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../../data/repository/hero_repository_impl.dart';
import '../../domain/hero.dart';
import '../widgets/hero_card.dart';

class AgentsPage extends StatefulWidget {
  const AgentsPage({
    super.key,
  });

  @override
  State<AgentsPage> createState() =>
      _AgentsPageState();
}

class _AgentsPageState extends State<AgentsPage> {

  //Repositório de heróis:
  late final HeroRepositoryImpl heroesRepo;

  //Controla a paginação da lista:
  late final PagingController<int, Hero>
  _pagingController =
  PagingController<int, Hero>(

    //Define qual será a próxima página:
    getNextPageKey: (state) =>
    state.lastPageIsEmpty
        ? null
        : state.nextIntPageKey,

    //Busca os heróis da próxima página:
    fetchPage: (pageKey) =>
        heroesRepo.getHeroes(
          page: pageKey,
          limit: 10,
        ),
  );

  @override
  void initState() {
    super.initState();

    //Recupera o repository através do Provider:
    heroesRepo =
        Provider.of<HeroRepositoryImpl>(
          context,
          listen: false,
        );
  }

  @override
  void dispose() {
    //Libera o controller ao fechar a tela:
    _pagingController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //Título da tela:
        title: const Text(
          'Agentes',
        ),
        backgroundColor:
        Theme.of(context).primaryColorLight,
      ),

      //Escuta o estado da paginação:
      body: PagingListener(
        controller: _pagingController,

        builder: (
            context,
            state,
            fetchNextPage,
            ) =>
            PagedListView<int, Hero>(
              state: state,
              fetchNextPage: fetchNextPage,

              //Cria um card para cada herói:
              builderDelegate:
              PagedChildBuilderDelegate<Hero>(
                itemBuilder: (
                    context,
                    hero,
                    index,
                    ) =>
                    HeroCard(
                      hero: hero,
                    ),
              ),
            ),
      ),
    );
  }
}