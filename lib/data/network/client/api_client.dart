import 'package:dio/dio.dart';

import '../../../domain/exception/network_exception.dart';
import '../entity/http_paged_result.dart';

class ApiClient {
  late final Dio _dio;

  // Configura o cliente responsável pelas requisições HTTP.
  ApiClient({required String baseUrl}) {
    _dio = Dio()
      ..options.baseUrl = baseUrl
      ..interceptors.add(
        LogInterceptor(
          // Exibe informações das requisições no terminal.
          requestBody: true,
          responseBody: true,
        ),
      );
  }

  // Busca uma página de heróis no servidor.
  Future<List<HeroEntity>> getHeroes({
    required int page,
    required int limit,
  }) async {
    final response = await _dio.get(
      '/heroes',
      queryParameters: {
        // Número da página solicitada.
        '_page': page,

        // Quantidade de heróis por página.
        '_per_page': limit,
      },
    );

    // Verifica se o servidor retornou algum erro HTTP.
    if (response.statusCode != null && response.statusCode! >= 400) {
      throw NetworkException(
        statusCode: response.statusCode!,
        message: response.statusMessage,
      );
    }

    // Se recebeu uma resposta válida, converte o JSON.
    if (response.statusCode != null) {
      final HttpPagedResult receivedData =
      HttpPagedResult.fromJson(
        response.data as Map<String, dynamic>,
      );

      return receivedData.data;
    }

    // Caso não exista código de resposta.
    throw Exception('Erro desconhecido.');
  }
}