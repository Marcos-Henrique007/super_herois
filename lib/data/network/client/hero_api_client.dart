import 'dart:convert';

import 'package:http/http.dart' as http;

import '../entity/hero_network_entity.dart';

// URL do backend da API:
class HeroApiClient {
  static const String baseUrl =
      'https://backend-super-herois.onrender.com';

  // Busca uma página de heróis na API:
  Future<List<HeroNetworkEntity>> getHeroes({
    required int page,
    required int limit,
  }) async {
    // Monta a URL com paginação:
    final uri = Uri.parse(
      '$baseUrl/heroes?_page=$page&_per_page=$limit',
    );

    // Faz a requisição para a API
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Erro ao buscar heróis: ${response.statusCode}',
      );
    }

    // Converte o JSON recebido
    final dynamic decoded = jsonDecode(response.body);

    // Pega a lista de heróis da resposta
    final List<dynamic> data;

    if (decoded is List) {
      data = decoded;
    } else if (decoded is Map<String, dynamic>) {
      data = decoded['data'] as List<dynamic>;
    } else {
      throw Exception('Formato de resposta inválido.');
    }

    // Converte cada JSON em HeroNetworkEntity
    return data
        .map(
          (json) => HeroNetworkEntity.fromJson(
        json as Map<String, dynamic>,
      ),
    )
        .toList();
  }
}