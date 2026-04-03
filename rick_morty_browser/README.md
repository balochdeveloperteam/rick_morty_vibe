# Rick & Morty Character Browser

**Developer:** Azeem Adeel

A production-style Flutter app that browses characters from the [Rick and Morty API](https://rickandmortyapi.com/), with offline cache, favorites, and Material 3 UI.

---

## English

### Architecture

- **Clean Architecture** — Three layers:
  - **Data:** `CharacterModel`, `RemoteCharacterDataSource` (Dio), `LocalCharacterDataSource` (Hive), `CharacterRepositoryImpl`.
  - **Domain:** `Character` entity, `CharacterRepository` contract, use cases (`GetCharactersPaged`, `ToggleFavoriteStatus`, `GetFavoriteCharacters`).
  - **Presentation:** `CharactersCubit`, `FavoritesCubit`, pages, and widgets.
- **State management:** `flutter_bloc` (Cubit).
- **Dependency injection:** `get_it` (`configureDependencies` in `lib/core/di/injection_container.dart`).
- **Networking:** `dio` with `LogInterceptor` for request/response logging.
- **Local storage:** `hive_flutter` — one box for merged character cache (JSON), one box for favorites (per-character JSON).

### Features

- Paginated character list with infinite scroll.
- Star toggle on each card; favorites stored in Hive.
- If the API fails on the first page, the app loads the last merged cache from Hive.
- Shimmer placeholders for initial and pagination loading.
- Bottom navigation: **Characters** and **Favorites**.

### Setup

```bash
cd rick_morty_browser
flutter pub get
flutter run
```

Use a connected device, emulator, or `flutter run -d chrome` for web.

### Project structure (`lib/`)

```
core/           # DI, theme, constants
features/characters/
  data/         # models, datasources, repository impl
  domain/       # entities, repository interface, use cases
  presentation/ # cubits, pages, widgets
```

---

## Русский

### Архитектура

- **Чистая архитектура (Clean Architecture)** — три слоя:
  - **Data:** модели, удалённый источник (Dio), локальный источник (Hive), реализация репозитория.
  - **Domain:** сущность `Character`, контракт репозитория, сценарии использования (use cases).
  - **Presentation:** Cubit-ы, экраны, виджеты.
- **Управление состоянием:** `flutter_bloc` (Cubit).
- **Внедрение зависимостей:** `get_it`.
- **Сеть:** `dio` с логированием через перехватчики.
- **Локальное хранилище:** `hive_flutter` — кэш списка персонажей и избранное.

### Возможности

- Постраничная загрузка и бесконечная прокрутка.
- Избранное (звезда на карточке), данные в Hive.
- При ошибке API на первой странице — показ последнего кэша из Hive.
- Shimmer при первой загрузке и при подгрузке страниц.
- Нижняя навигация: **Персонажи** и **Избранное**.

### Запуск

```bash
cd rick_morty_browser
flutter pub get
flutter run
```

Укажите устройство или эмулятор; для веба: `flutter run -d chrome`.

### Разработчик

**Azeem Adeel**
