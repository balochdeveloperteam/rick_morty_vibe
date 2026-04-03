import 'package:dio/dio.dart';
import 'package:rick_morty_browser/features/characters/data/datasources/local_character_datasource.dart';
import 'package:rick_morty_browser/features/characters/data/datasources/remote_character_datasource.dart';
import 'package:rick_morty_browser/features/characters/data/models/character_model.dart';
import 'package:rick_morty_browser/features/characters/domain/entities/character.dart';
import 'package:rick_morty_browser/features/characters/domain/entities/character_page_result.dart';
import 'package:rick_morty_browser/features/characters/domain/repositories/character_repository.dart';

class CharacterRepositoryImpl implements CharacterRepository {
  CharacterRepositoryImpl(this._remote, this._local);

  final RemoteCharacterDataSource _remote;
  final LocalCharacterDataSource _local;

  @override
  Future<CharacterPageResult> getCharactersPage(int page) async {
    try {
      final remote = await _remote.fetchCharacters(page);
      await _local.mergeCachedCharacters(remote.results);
      final characters = await _mapWithFavorites(remote.results);
      return CharacterPageResult(
        characters: characters,
        hasNextPage: remote.nextPageUrl != null,
        fromCache: false,
      );
    } on DioException catch (_) {
      if (page == 1) {
        final cached = await _local.getCachedCharacters();
        if (cached != null && cached.isNotEmpty) {
          final characters = await _mapWithFavorites(cached);
          return CharacterPageResult(
            characters: characters,
            hasNextPage: false,
            fromCache: true,
          );
        }
      }
      rethrow;
    } catch (_) {
      if (page == 1) {
        final cached = await _local.getCachedCharacters();
        if (cached != null && cached.isNotEmpty) {
          final characters = await _mapWithFavorites(cached);
          return CharacterPageResult(
            characters: characters,
            hasNextPage: false,
            fromCache: true,
          );
        }
      }
      rethrow;
    }
  }

  Future<List<Character>> _mapWithFavorites(List<CharacterModel> models) async {
    final out = <Character>[];
    for (final m in models) {
      final fav = await _local.isFavorite(m.id);
      out.add(m.toEntity(isFavorite: fav));
    }
    return out;
  }

  @override
  Future<void> toggleFavorite(Character character) async {
    final model = CharacterModel.fromEntity(character);
    if (await _local.isFavorite(character.id)) {
      await _local.removeFavorite(character.id);
    } else {
      await _local.saveFavorite(model);
    }
  }

  @override
  Future<List<Character>> getFavoriteCharacters() async {
    final models = await _local.getFavoriteModels();
    return models.map((m) => m.toEntity(isFavorite: true)).toList();
  }

  @override
  Future<bool> isFavorite(int id) => _local.isFavorite(id);
}
