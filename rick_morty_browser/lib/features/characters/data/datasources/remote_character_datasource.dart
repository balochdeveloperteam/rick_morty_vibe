import 'package:dio/dio.dart';
import 'package:rick_morty_browser/core/constants/api_constants.dart';
import 'package:rick_morty_browser/features/characters/data/models/character_model.dart';

abstract class RemoteCharacterDataSource {
  Future<RemoteCharacterPage> fetchCharacters(int page);
}

class RemoteCharacterPage {
  const RemoteCharacterPage({
    required this.results,
    required this.nextPageUrl,
  });

  final List<CharacterModel> results;
  final String? nextPageUrl;
}

class RemoteCharacterDataSourceImpl implements RemoteCharacterDataSource {
  RemoteCharacterDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<RemoteCharacterPage> fetchCharacters(int page) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '${ApiConstants.baseUrl}${ApiConstants.charactersPath}',
      queryParameters: {'page': page},
    );
    final data = response.data;
    if (data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        message: 'Empty response',
      );
    }
    final info = data['info'] as Map<String, dynamic>?;
    final results = data['results'] as List<dynamic>? ?? [];
    final next = info?['next'] as String?;
    final models = results
        .map((e) => CharacterModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
    return RemoteCharacterPage(results: models, nextPageUrl: next);
  }
}
