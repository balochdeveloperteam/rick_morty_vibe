import 'package:rick_morty_browser/features/characters/domain/entities/character.dart';
import 'package:rick_morty_browser/features/characters/domain/repositories/character_repository.dart';

class GetFavoriteCharacters {
  GetFavoriteCharacters(this._repository);

  final CharacterRepository _repository;

  Future<List<Character>> call() => _repository.getFavoriteCharacters();
}
