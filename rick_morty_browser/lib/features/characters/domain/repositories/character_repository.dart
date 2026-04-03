import 'package:rick_morty_browser/features/characters/domain/entities/character.dart';
import 'package:rick_morty_browser/features/characters/domain/entities/character_page_result.dart';

abstract class CharacterRepository {
  Future<CharacterPageResult> getCharactersPage(int page);

  Future<void> toggleFavorite(Character character);

  Future<List<Character>> getFavoriteCharacters();

  Future<bool> isFavorite(int id);
}
