import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rick_morty_browser/core/constants/hive_constants.dart';
import 'package:rick_morty_browser/features/characters/data/datasources/local_character_datasource.dart';
import 'package:rick_morty_browser/features/characters/data/datasources/remote_character_datasource.dart';
import 'package:rick_morty_browser/features/characters/data/repositories/character_repository_impl.dart';
import 'package:rick_morty_browser/features/characters/domain/repositories/character_repository.dart';
import 'package:rick_morty_browser/features/characters/domain/usecases/get_characters_paged.dart';
import 'package:rick_morty_browser/features/characters/domain/usecases/get_favorite_characters.dart';
import 'package:rick_morty_browser/features/characters/domain/usecases/toggle_favorite_status.dart';
import 'package:rick_morty_browser/features/characters/presentation/cubit/characters_cubit.dart';
import 'package:rick_morty_browser/features/characters/presentation/cubit/favorites_cubit.dart';

final sl = GetIt.instance;

Future<void> configureDependencies() async {
  final cacheBox = await Hive.openBox<String>(HiveConstants.cacheBoxName);
  final favoritesBox = await Hive.openBox<String>(HiveConstants.favoritesBoxName);

  sl.registerSingleton<Box<String>>(cacheBox, instanceName: 'cacheBox');
  sl.registerSingleton<Box<String>>(favoritesBox, instanceName: 'favoritesBox');

  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      headers: {'Accept': 'application/json'},
    ),
  );
  dio.interceptors.add(
    LogInterceptor(
      requestHeader: true,
      requestBody: true,
      responseHeader: false,
      responseBody: true,
      error: true,
    ),
  );
  sl.registerSingleton<Dio>(dio);

  sl.registerLazySingleton<RemoteCharacterDataSource>(
    () => RemoteCharacterDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<LocalCharacterDataSource>(
    () => LocalCharacterDataSourceImpl(
      sl<Box<String>>(instanceName: 'cacheBox'),
      sl<Box<String>>(instanceName: 'favoritesBox'),
    ),
  );
  sl.registerLazySingleton<CharacterRepository>(
    () => CharacterRepositoryImpl(sl(), sl()),
  );

  sl.registerLazySingleton(() => GetCharactersPaged(sl()));
  sl.registerLazySingleton(() => ToggleFavoriteStatus(sl()));
  sl.registerLazySingleton(() => GetFavoriteCharacters(sl()));

  sl.registerFactory(() => CharactersCubit(sl(), sl()));
  sl.registerFactory(() => FavoritesCubit(sl()));
}
