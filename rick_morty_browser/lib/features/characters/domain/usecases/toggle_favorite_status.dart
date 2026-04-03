import 'package:rick_morty_browser/features/characters/domain/entities/character.dart';
import 'package:rick_morty_browser/features/characters/domain/repositories/character_repository.dart';

class ToggleFavoriteStatus {
  ToggleFavoriteStatus(this._repository);

  final CharacterRepository _repository;

  Future<void> call(Character character) => _repository.toggleFavorite(character);
}
