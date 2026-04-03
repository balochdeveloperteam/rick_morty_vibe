import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_morty_browser/features/characters/domain/entities/character.dart';
import 'package:rick_morty_browser/features/characters/presentation/cubit/characters_cubit.dart';
import 'package:rick_morty_browser/features/characters/presentation/cubit/favorites_cubit.dart';
import 'package:rick_morty_browser/features/characters/presentation/cubit/favorites_state.dart';
import 'package:rick_morty_browser/features/characters/presentation/widgets/character_card.dart';
import 'package:rick_morty_browser/features/characters/presentation/widgets/character_list_shimmer.dart';
import 'package:rick_morty_browser/features/characters/presentation/widgets/empty_state.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  Future<void> _onFavorite(BuildContext context, Character character) async {
    final charactersCubit = context.read<CharactersCubit>();
    final favoritesCubit = context.read<FavoritesCubit>();
    await charactersCubit.toggleFavorite(character);
    await favoritesCubit.loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Favorites'),
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, FavoritesState state) {
    if (state.isLoading && state.characters.isEmpty) {
      return const CharacterListShimmer(itemCount: 6);
    }

    if (state.errorMessage != null && state.characters.isEmpty) {
      return EmptyState(
        title: 'Something went wrong',
        subtitle: state.errorMessage!,
        icon: Icons.error_outline,
      );
    }

    if (state.characters.isEmpty) {
      return const EmptyState(
        title: 'No favorites yet',
        subtitle: 'Tap the star on a character to save them here.',
        icon: Icons.star_border,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: state.characters.length,
      itemBuilder: (context, index) {
        final character = state.characters[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: CharacterCard(
            character: character,
            onFavoriteTap: () => _onFavorite(context, character),
          ),
        );
      },
    );
  }
}
