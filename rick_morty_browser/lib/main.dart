import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rick_morty_browser/core/di/injection_container.dart';
import 'package:rick_morty_browser/core/theme/app_theme.dart';
import 'package:rick_morty_browser/features/characters/presentation/cubit/characters_cubit.dart';
import 'package:rick_morty_browser/features/characters/presentation/cubit/favorites_cubit.dart';
import 'package:rick_morty_browser/features/characters/presentation/pages/main_shell_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await configureDependencies();
  runApp(const RickMortyApp());
}

class RickMortyApp extends StatelessWidget {
  const RickMortyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<CharactersCubit>()..fetchInitial(),
        ),
        BlocProvider(
          create: (_) => sl<FavoritesCubit>()..loadFavorites(),
        ),
      ],
      child: MaterialApp(
        title: 'Rick & Morty',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        home: const MainShellPage(),
      ),
    );
  }
}
