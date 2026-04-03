import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_morty_browser/features/characters/domain/entities/character.dart';
import 'package:rick_morty_browser/features/characters/presentation/cubit/characters_cubit.dart';
import 'package:rick_morty_browser/features/characters/presentation/cubit/characters_state.dart';
import 'package:rick_morty_browser/features/characters/presentation/cubit/favorites_cubit.dart';
import 'package:rick_morty_browser/features/characters/presentation/widgets/character_card.dart';
import 'package:rick_morty_browser/features/characters/presentation/widgets/character_list_shimmer.dart';
import 'package:rick_morty_browser/features/characters/presentation/widgets/empty_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 360) {
      context.read<CharactersCubit>().loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onFavorite(Character character) async {
    final charactersCubit = context.read<CharactersCubit>();
    final favoritesCubit = context.read<FavoritesCubit>();
    await charactersCubit.toggleFavorite(character);
    await favoritesCubit.loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CharactersCubit, CharactersState>(
      listenWhen: (prev, curr) =>
          curr.snackbarMessage != null && curr.snackbarMessage != prev.snackbarMessage,
      listener: (context, state) {
        final msg = state.snackbarMessage;
        if (msg != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(msg)),
          );
          context.read<CharactersCubit>().clearSnackbarMessage();
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Characters'),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (state.fromCache && state.characters.isNotEmpty)
                MaterialBanner(
                  content: const Text(
                    'Showing cached data — network unavailable.',
                  ),
                  leading: const Icon(Icons.cloud_off_outlined),
                  backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                  actions: [
                    TextButton(
                      onPressed: () => context.read<CharactersCubit>().fetchInitial(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              Expanded(
                child: _buildBody(context, state),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, CharactersState state) {
    if (state.isInitialLoading) {
      return const CharacterListShimmer();
    }

    if (state.fatalError != null && state.characters.isEmpty) {
      return Column(
        children: [
          Expanded(
            child: EmptyState(
              title: 'Could not load characters',
              subtitle: state.fatalError!,
              icon: Icons.wifi_off_outlined,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: FilledButton.icon(
              onPressed: () => context.read<CharactersCubit>().fetchInitial(),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ),
        ],
      );
    }

    if (state.characters.isEmpty) {
      return EmptyState(
        title: 'No characters',
        subtitle: 'Pull to refresh or check your connection.',
        icon: Icons.search_off_outlined,
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<CharactersCubit>().fetchInitial(),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: state.characters.length + (state.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= state.characters.length) {
            return const CharacterPaginationShimmer();
          }
          final character = state.characters[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: CharacterCard(
              character: character,
              onFavoriteTap: () => _onFavorite(character),
            ),
          );
        },
      ),
    );
  }
}
