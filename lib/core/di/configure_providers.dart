import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../data/database/dao/hero_dao.dart';
import '../../data/database/database_mapper.dart';
import '../../data/network/client/api_client.dart';
import '../../data/network/network_mapper.dart';
import '../../data/repository/hero_repository_impl.dart';

class ConfigureProviders {
  final List<SingleChildWidget> providers;

  ConfigureProviders({
    required this.providers,
  });

  static Future<ConfigureProviders> createDependencyTree() async {

    //Cliente da API:
    final api_client = ApiClient(
      baseUrl: "https://backend-super-herois.onrender.com",
    );

    //Mappers:
    final network_mapper = NetworkMapper();
    final database_mapper = DatabaseMapper();

    //Acesso ao banco:
    final hero_dao = HeroDao();

    //Repositório:
    final heroes_repository = HeroRepositoryImpl(
      apiClient: api_client,
      networkMapper: network_mapper,
      databaseMapper: database_mapper,
      heroDao: hero_dao,
    );

    //Providers da aplicação:
    return ConfigureProviders(
      providers: [
        Provider<ApiClient>.value(
          value: api_client,
        ),
        Provider<NetworkMapper>.value(
          value: network_mapper,
        ),
        Provider<DatabaseMapper>.value(
          value: database_mapper,
        ),
        Provider<HeroDao>.value(
          value: hero_dao,
        ),
        Provider<HeroRepositoryImpl>.value(
          value: heroes_repository,
        ),
      ],
    );
  }
}