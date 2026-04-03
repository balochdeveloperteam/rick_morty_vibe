import 'package:equatable/equatable.dart';
import 'package:rick_morty_browser/features/characters/domain/entities/character.dart';

class CharacterPageResult extends Equatable {
  const CharacterPageResult({
    required this.characters,
    required this.hasNextPage,
    this.fromCache = false,
  });

  final List<Character> characters;
  final bool hasNextPage;
  final bool fromCache;

  @override
  List<Object?> get props => [characters, hasNextPage, fromCache];
}
