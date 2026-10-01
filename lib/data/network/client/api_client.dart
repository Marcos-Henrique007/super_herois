import 'package:dio/dio.dart';

import '../../../domain/exception/network_exception.dart';
import '../entity/http_paged_result.dart';

class ApiClient {
  late final Dio _dio;

  //Configura o cliente das requisições:
  ApiClient({
    required String baseUrl,
  }) {
    _dio = Dio()
      ..options.baseUrl = baseUrl
      ..interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
        ),
      );
  }

  //Busca uma página de heróis:
  Future<List<HeroEntity>> getHeroes({
    required int page,
    required int limit,
  }) async {
    final response = await _dio.get(
      '/heroes',
      queryParameters: {
        '_page': page,
        '_per_page': limit,
      },
    );

    if (response.statusCode != null &&
        response.statusCode! >= 400) {
      throw NetworkException(
        statusCode: response.statusCode!,
        message: response.statusMessage,
      );
    } else if (response.statusCode != null) {
      final HttpPagedResult receivedData =
      HttpPagedResult.fromJson(
        response.data as Map<String, dynamic>,
      );

      return receivedData.data;
    } else {
      throw Exception(
        'Erro desconhecido.',
      );
    }
  }

  //Busca um herói pelo ID:
  Future<HeroEntity> getHeroById({
    required int id,
  }) async {
    final response = await _dio.get(
      '/heroes/$id',
    );

    if (response.statusCode != null &&
        response.statusCode! >= 400) {
      throw NetworkException(
        statusCode: response.statusCode!,
        message: response.statusMessage,
      );
    } else if (response.statusCode != null) {
      return HeroEntity.fromJson(
        response.data as Map<String, dynamic>,
      );
    } else {
      throw Exception(
        'Erro desconhecido.',
      );
    }
  }
}