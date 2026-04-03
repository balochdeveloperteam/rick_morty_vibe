import 'package:equatable/equatable.dart';
import 'package:rick_morty_browser/features/characters/domain/entities/character.dart';

class FavoritesState extends Equatable {
  const FavoritesState({
    this.characters = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  final List<Character> characters;
  final bool isLoading;
  final String? errorMessage;

  FavoritesState copyWith({
    List<Character>? characters,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return FavoritesState(
      characters: characters ?? this.characters,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [characters, isLoading, errorMessage];
}
