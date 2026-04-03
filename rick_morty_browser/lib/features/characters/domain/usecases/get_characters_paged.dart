import 'package:rick_morty_browser/features/characters/domain/entities/character_page_result.dart';
import 'package:rick_morty_browser/features/characters/domain/repositories/character_repository.dart';

class GetCharactersPaged {
  GetCharactersPaged(this._repository);

  final CharacterRepository _repository;

  Future<CharacterPageResult> call(int page) => _repository.getCharactersPage(page);
}
