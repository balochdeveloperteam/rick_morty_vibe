import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_morty_browser/features/characters/domain/usecases/get_favorite_characters.dart';
import 'package:rick_morty_browser/features/characters/presentation/cubit/favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit(this._getFavoriteCharacters) : super(const FavoritesState());

  final GetFavoriteCharacters _getFavoriteCharacters;

  Future<void> loadFavorites() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final list = await _getFavoriteCharacters();
      emit(state.copyWith(characters: list, isLoading: false, clearError: true));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
