import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_morty_browser/features/characters/domain/entities/character.dart';
import 'package:rick_morty_browser/features/characters/domain/usecases/get_characters_paged.dart';
import 'package:rick_morty_browser/features/characters/domain/usecases/toggle_favorite_status.dart';
import 'package:rick_morty_browser/features/characters/presentation/cubit/characters_state.dart';

class CharactersCubit extends Cubit<CharactersState> {
  CharactersCubit(
    this._getCharactersPaged,
    this._toggleFavoriteStatus,
  ) : super(const CharactersState());

  final GetCharactersPaged _getCharactersPaged;
  final ToggleFavoriteStatus _toggleFavoriteStatus;

  Future<void> fetchInitial() async {
    emit(
      state.copyWith(
        isInitialLoading: true,
        clearFatalError: true,
        characters: const [],
        currentPage: 0,
        hasReachedMax: false,
        fromCache: false,
        clearSnackbar: true,
      ),
    );
    try {
      final result = await _getCharactersPaged(1);
      emit(
        state.copyWith(
          characters: result.characters,
          currentPage: 1,
          hasReachedMax: !result.hasNextPage,
          isInitialLoading: false,
          fromCache: result.fromCache,
          clearFatalError: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isInitialLoading: false,
          fatalError: _mapError(e),
          characters: const [],
          clearFatalError: false,
        ),
      );
    }
  }

  Future<void> loadMore() async {
    if (state.hasReachedMax || state.isLoadingMore || state.isInitialLoading) {
      return;
    }
    emit(state.copyWith(isLoadingMore: true, clearSnackbar: true));
    try {
      final nextPage = state.currentPage + 1;
      final result = await _getCharactersPaged(nextPage);
      final merged = [...state.characters];
      final ids = merged.map((c) => c.id).toSet();
      for (final c in result.characters) {
        if (!ids.contains(c.id)) {
          merged.add(c);
          ids.add(c.id);
        }
      }
      emit(
        state.copyWith(
          characters: merged,
          currentPage: nextPage,
          hasReachedMax: !result.hasNextPage,
          isLoadingMore: false,
          clearSnackbar: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoadingMore: false,
          snackbarMessage: _mapError(e),
        ),
      );
    }
  }

  Future<void> toggleFavorite(Character character) async {
    await _toggleFavoriteStatus(character);
    final updated = character.copyWith(isFavorite: !character.isFavorite);
    final newList = state.characters
        .map((c) => c.id == updated.id ? updated : c)
        .toList();
    emit(state.copyWith(characters: newList));
  }

  void clearSnackbarMessage() {
    if (state.snackbarMessage != null) {
      emit(state.copyWith(clearSnackbar: true));
    }
  }

  String _mapError(Object e) {
    if (e is DioException) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return 'Connection timed out. Check your network.';
        case DioExceptionType.connectionError:
          return 'No internet connection.';
        default:
          return e.message ?? 'Network error occurred.';
      }
    }
    return e.toString();
  }
}
