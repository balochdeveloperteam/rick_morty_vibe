import 'package:equatable/equatable.dart';
import 'package:rick_morty_browser/features/characters/domain/entities/character.dart';

class CharactersState extends Equatable {
  const CharactersState({
    this.characters = const [],
    this.currentPage = 0,
    this.hasReachedMax = false,
    this.isInitialLoading = false,
    this.isLoadingMore = false,
    this.fatalError,
    this.fromCache = false,
    this.snackbarMessage,
  });

  final List<Character> characters;
  final int currentPage;
  final bool hasReachedMax;
  final bool isInitialLoading;
  final bool isLoadingMore;
  final String? fatalError;
  final bool fromCache;
  final String? snackbarMessage;

  CharactersState copyWith({
    List<Character>? characters,
    int? currentPage,
    bool? hasReachedMax,
    bool? isInitialLoading,
    bool? isLoadingMore,
    String? fatalError,
    bool? fromCache,
    String? snackbarMessage,
    bool clearFatalError = false,
    bool clearSnackbar = false,
  }) {
    return CharactersState(
      characters: characters ?? this.characters,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      fatalError: clearFatalError ? null : (fatalError ?? this.fatalError),
      fromCache: fromCache ?? this.fromCache,
      snackbarMessage: clearSnackbar ? null : (snackbarMessage ?? this.snackbarMessage),
    );
  }

  @override
  List<Object?> get props => [
        characters,
        currentPage,
        hasReachedMax,
        isInitialLoading,
        isLoadingMore,
        fatalError,
        fromCache,
        snackbarMessage,
      ];
}
