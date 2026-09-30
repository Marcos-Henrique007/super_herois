import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/di/configure_providers.dart';
import 'ui/pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Cria a árvore de dependências:
  final data =
  await ConfigureProviders.createDependencyTree();

  runApp(
    AppRoot(data: data),
  );
}

class AppRoot extends StatelessWidget {
  final ConfigureProviders data;

  const AppRoot({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: data.providers,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Super Heroes',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
          ),
          useMaterial3: true,
        ),

        //Tela inicial do aplicativo:
        home: const HomePage(),
      ),
    );
  }
}