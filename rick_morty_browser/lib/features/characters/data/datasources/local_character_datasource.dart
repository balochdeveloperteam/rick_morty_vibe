import 'package:hive_flutter/hive_flutter.dart';
import 'package:rick_morty_browser/core/constants/hive_constants.dart';
import 'package:rick_morty_browser/features/characters/data/models/character_model.dart';

abstract class LocalCharacterDataSource {
  Future<void> mergeCachedCharacters(List<CharacterModel> pageResults);

  Future<List<CharacterModel>?> getCachedCharacters();

  Future<void> saveFavorite(CharacterModel model);

  Future<void> removeFavorite(int id);

  Future<List<CharacterModel>> getFavoriteModels();

  Future<bool> isFavorite(int id);
}

class LocalCharacterDataSourceImpl implements LocalCharacterDataSource {
  LocalCharacterDataSourceImpl(this._cacheBox, this._favoritesBox);

  final Box<String> _cacheBox;
  final Box<String> _favoritesBox;

  @override
  Future<void> mergeCachedCharacters(List<CharacterModel> pageResults) async {
    final existing = await getCachedCharacters() ?? <CharacterModel>[];
    final byId = {for (final c in existing) c.id: c};
    for (final c in pageResults) {
      byId[c.id] = c;
    }
    final merged = byId.values.toList()..sort((a, b) => a.id.compareTo(b.id));
    await _cacheBox.put(
      HiveConstants.cachedCharactersKey,
      CharacterModel.encodeList(merged),
    );
  }

  @override
  Future<List<CharacterModel>?> getCachedCharacters() async {
    final raw = _cacheBox.get(HiveConstants.cachedCharactersKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      return CharacterModel.decodeList(raw);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveFavorite(CharacterModel model) async {
    await _favoritesBox.put(model.id.toString(), CharacterModel.encodeList([model]));
  }

  @override
  Future<void> removeFavorite(int id) async {
    await _favoritesBox.delete(id.toString());
  }

  @override
  Future<List<CharacterModel>> getFavoriteModels() async {
    final out = <CharacterModel>[];
    for (final key in _favoritesBox.keys) {
      final raw = _favoritesBox.get(key.toString());
      if (raw == null) continue;
      try {
        final list = CharacterModel.decodeList(raw);
        if (list.isNotEmpty) out.add(list.first);
      } catch (_) {
        continue;
      }
    }
    out.sort((a, b) => a.id.compareTo(b.id));
    return out;
  }

  @override
  Future<bool> isFavorite(int id) async {
    return _favoritesBox.containsKey(id.toString());
  }
}
