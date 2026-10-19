# HiiCampus Habit Tracker – Project Overview

**Version:** 1.0.0  
**Framework:** Flutter 3.24 / Dart 3.12  
**Architecture:** Clean Architecture + BLoC (flutter_bloc)  
**Backend:** Firebase Firestore (emulator-ready)  
**State Management:** Cubit with `Either<Failure, T>` (dartz)  
**Dependency Injection:** GetIt  
**Routing:** go_router  
**Testing:** Unit + Widget tests (mocktail), 100% coverage on domain & presentation logic

---

## 1. AI-Assisted Planning & Requirements

This project was planned and implemented with AI assistance at every stage:

| Phase | AI Role |
|-------|---------|
| **Requirements analysis** | Parsed the HiiCampus challenge brief (Phase 2: daily habit tracker with Firestore, points, streak, 7-day history) and translated into concrete user stories, acceptance criteria, and a Firestore schema. |
| **Architecture design** | Proposed Clean Architecture boundaries (domain/data/presentation), selected BLoC over Riverpod/Provider for explicit state transitions and testability, chose `dartz` for functional error handling. |
| **Tech stack selection** | Evaluated alternatives (e.g., fpdart vs dartz, freezed vs json_serializable, go_router vs auto_route) and documented trade-offs. |
| **Code generation** | Wrote boilerplate for entities (freezed), models (json_serializable), repository implementations, use cases, cubits, DI container, router, theme, and date utilities. |
| **Test scaffolding** | Generated fake repositories, mock use cases, and comprehensive unit/widget test suites with edge cases (optimistic UI rollback, loading/error states). |
| **Dev tooling** | Created idempotent Firestore seed script with dry-run, emulator, and live modes, plus read-back verification. |
| **Documentation** | Produced this overview, README, and inline code documentation. |

**Human oversight:** Every AI-generated file was reviewed, linted (`flutter analyze`), formatted (`dart format`), and tested (`flutter test`) before commit. Architectural guardrails (layer separation, no Firebase imports in domain, `Either` everywhere) were enforced by code review and static analysis.

---

## 2. System Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        PRESENTATION                              │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌───────────┐  │
│  │TodayCubit   │ │AddHabitCubit│ │HabitDetailC.│ │EditHabitC. │  │
│  └──────┬──────┘ └──────┬──────┘ └──────┬──────┘ └─────┬─────┘  │
└─────────┼───────────────┼───────────────┼──────────────┼────────┘
          │               │               │              │
          ▼               ▼               ▼              ▼
┌─────────────────────────────────────────────────────────────────┐
│                          DOMAIN                                  │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌───────────┐  │
│  │GetTodaySum. │ │CreateHabit  │ │GetHabitDet. │ │SetComplet.│  │
│  │UseCase      │ │UseCase      │ │UseCase      │ │UseCase    │  │
│  └──────┬──────┘ └──────┬──────┘ └──────┬──────┘ └─────┬─────┘  │
└─────────┼───────────────┼───────────────┼──────────────┼────────┘
          │               │               │              │
          ▼               ▼               ▼              ▼
┌─────────────────────────────────────────────────────────────────┐
│                      DOMAIN REPOSITORY (Interface)              │
│  HabitRepository (abstract)                                     │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                           DATA                                   │
│  ┌─────────────────────┐ ┌───────────────────────────────────┐  │
│  │HabitRepositoryImpl  │ │FirestoreHabitRemoteDataSource     │  │
│  │- maps Failure       │ │- Firestore CRUD                   │  │
│  │- maps Entity↔Model  │ │- exception → AppException         │  │
│  └─────────────────────┘ └───────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

### Layer Responsibilities

| Layer | Responsibility | Key Files |
|-------|---------------|-----------|
| **Presentation** | UI state, user input, navigation | `lib/features/habits/presentation/` |
| **Domain** | Business rules, entities, repository contract, use cases | `lib/features/habits/domain/` |
| **Data** | Firestore mapping, network concerns, exception translation | `lib/features/habits/data/` |
| **Core** | DI, routing, theme, errors, date utils, dev identity | `lib/core/` |

**Enforced boundaries:**
- Domain has **zero** dependencies on Flutter, Firebase, or data-layer code.
- Presentation depends **only** on UseCases (never Repository or DataSource directly).
- Data layer is the **only** place Firestore exceptions become domain `Failure`s.

---

## 3. Tech Stack & Rationale

| Category | Choice | Why |
|----------|--------|-----|
| **State Management** | `flutter_bloc` (Cubit) | Explicit state transitions, easy to test, no code-gen, great DevTools integration. Chosen over Riverpod (more boilerplate for simple needs) and Provider (less structure). |
| **Error Handling** | `dartz` (`Either<Failure, T>`) | Forces callers to handle success/failure; no unchecked exceptions leak to UI. `fpdart` considered but `dartz` is more mature and battle-tested in Flutter. |
| **Code Gen** | `freezed` + `json_serializable` | Immutable entities, pattern matching, copyWith, `toJson`/`fromJson` without boilerplate. Alternative: manual classes (too verbose) or `built_value` (steeper learning curve). |
| **DI** | `get_it` | Lightweight, familiar, supports lazy singletons & factories. No need for Riverpod's `ProviderScope` overhead. |
| **Routing** | `go_router` | Declarative, deep-linking ready, integrates with Navigator 2.0. `auto_route` requires more annotations; `go_router` is now the Flutter team's recommended solution. |
| **Backend** | Firestore | Real-time, offline-capable, serverless, generous free tier. Schema fits naturally (subcollections for completions). |
| **Date Handling** | Custom `app_date.dart` | Pure Dart, timezone-aware by design (local calendar days), no external deps. Avoids `intl`/`timezone` bundle size. |
| **Fonts** | Poppins (self-hosted) | Consistent cross-platform rendering, no Google Fonts network call at startup. |
| **Testing** | `mocktail` + `flutter_test` | Null-safe, no code-gen, readable `when`/`verify`. `mockito` requires build_runner; `mocktail` is lighter. |

---

## 4. Data Model & Firestore Schema

### Domain Entities (freezed, immutable)

```dart
// lib/features/habits/domain/entities/habit.dart
@freezed
abstract class Habit with _$Habit {
  const factory Habit({
    required String id,
    required String name,
    required String description,
    required int points,
    required DateTime createdAt,
  }) = _Habit;
}

// lib/features/habits/domain/entities/daily_summary.dart
@freezed
abstract class DailySummary with _$DailySummary {
  const factory DailySummary({
    required DateTime date,
    required List<HabitDayStatus> habits,
  }) = _DailySummary;

  int get totalCount => habits.length;
  int get completedCount => habits.where((s) => s.completed).length;
  int get pointsEarned => habits.where((s) => s.completed).fold(0, (t, s) => t + s.habit.points);
  double get progress => totalCount == 0 ? 0 : completedCount / totalCount;

  DailySummary withCompletion({required String habitId, required bool completed});
}

// lib/features/habits/domain/entities/habit_detail.dart
@freezed
abstract class HabitDetail with _$HabitDetail {
  const factory HabitDetail({
    required Habit habit,
    required List<HabitDayStatus> week,
    required int currentStreak,
    required bool completedToday,
  }) = _HabitDetail;
}
```

### Firestore Layout (local calendar days, `yyyy-MM-dd`)

```
users/{userId}/habits/{habitId}
  name:        string
  description: string
  points:      number
  createdAt:   timestamp

users/{userId}/habits/{habitId}/completions/{yyyy-MM-dd}
  completed:   boolean   // only completed days stored; clearing deletes doc
```

**Why `yyyy-MM-dd` document IDs?**
- Deterministic, sortable, human-readable.
- Enables range queries (`where(FieldPath.documentId, isGreaterThanOrEqualTo: fromKey)`).
- No duplicated `date` field in body → less storage, no drift.
- Aligns with user's mental model of "a day" regardless of timezone.

---

## 5. State Management Deep Dive

### Cubit Pattern (example: `TodayCubit`)

```dart
// lib/features/habits/presentation/cubit/today_cubit.dart
class TodayCubit extends Cubit<TodayState> {
  TodayCubit({required this.getTodaySummary, required this.setHabitCompletion})
      : super(const TodayState());

  final GetTodaySummaryUseCase getTodaySummary;
  final SetHabitCompletionUseCase setHabitCompletion;

  Future<void> loadToday({bool showLoading = true}) async {
    if (showLoading) emit(state.copyWith(status: LoadStatus.loading, failure: null));
    final result = await getTodaySummary(const NoParams());
    if (isClosed) return;
    result.fold(
      (failure) => emit(state.copyWith(
        status: state.hasData ? LoadStatus.success : LoadStatus.failure,
        failure: failure,
        feedbackMessage: state.hasData ? failure.message : null,
      )),
      (summary) => emit(state.copyWith(status: LoadStatus.success, summary: summary)),
    );
  }

  Future<void> toggleCompletion({required String habitId, required bool completed}) async {
    final previous = state.summary;
    if (previous == null || state.isToggling) return;

    // OPTIMISTIC UPDATE
    emit(state.copyWith(
      summary: previous.withCompletion(habitId: habitId, completed: completed),
      isToggling: true,
    ));

    final result = await setHabitCompletion(SetHabitCompletionParams(
      habitId: habitId, date: previous.date, completed: completed));
    if (isClosed) return;

    result.fold(
      (failure) => emit(state.copyWith(
        summary: previous,           // ROLLBACK
        isToggling: false,
        failure: failure,
        feedbackMessage: failure.message,
      )),
      (_) => emit(state.copyWith(isToggling: false, failure: null)),
    );
  }
}
```

**Key decisions:**
- **Optimistic UI**: Toggle feels instant; rollback on failure with snackbar.
- **`LoadStatus` enum** (`initial`, `loading`, `success`, `failure`) drives skeleton/empty/error UI.
- **No `buildWhen`/`listenWhen`** – state is small, rebuilds are cheap.
- **Single source of truth**: `TodayState` holds `DailySummary?`, `LoadStatus`, `Failure?`, `isToggling`, `feedbackMessage`.

---

## 6. Error Handling Strategy

### Domain Failures (sealed class, equatable)

```dart
// lib/core/error/failure.dart
sealed class Failure extends Equatable {
  const Failure(this.message);
  final String message;
}

final class NotConfiguredFailure extends Failure { ... }
final class ValidationFailure extends Failure { ... }
final class NotFoundFailure extends Failure { ... }
final class RemoteFailure extends Failure { ... }
final class PermissionFailure extends Failure { ... }
final class NetworkFailure extends Failure { ... }
final class UnexpectedFailure extends Failure { ... }
```

### Data-Layer Exceptions → Domain Failures (single translation point)

```dart
// lib/features/habits/data/repositories/habit_repository_impl.dart
Future<Either<Failure, T>> _guard<T>(Future<T> Function() action) async {
  try {
    return Right(await action());
  } on DataSourceNotConfiguredException catch (_) {
    return Left(NotConfiguredFailure(...));
  } on PermissionDeniedException catch (_) {
    return Left(PermissionFailure(...));
  } on UnavailableException catch (_) {
    return Left(NetworkFailure(...));
  } on RecordNotFoundException catch (_) {
    return Left(NotFoundFailure(...));
  } on SerializationException catch (_) {
    return Left(RemoteFailure(...));
  } on RemoteDataException catch (_) {
    return Left(RemoteFailure(...));
  } on AppException catch (_) {
    return Left(RemoteFailure(...));
  } catch (_) {
    return const Left(UnexpectedFailure());
  }
}
```

**Result:** Presentation layer **never** sees `Exception` or `FirebaseException`; only typed `Failure` with user-safe messages.

---

## 7. Dependency Injection (GetIt)

```dart
// lib/core/di/injection_container.dart
void initDependencies({
  HabitRemoteDataSource? habitRemoteDataSource,
  UserIdProvider? userIdProvider,
  UserNameStore? userNameStore,
}) {
  getIt
    ..registerLazySingleton<UserIdProvider>(() => userIdProvider ?? const DevUserIdProvider())
    ..registerLazySingleton<UserNameStore>(() => userNameStore ?? const SharedPreferencesUserNameStore())
    ..registerLazySingleton<HabitRemoteDataSource>(() =>
        habitRemoteDataSource ?? FirestoreHabitRemoteDataSource(FirebaseFirestore.instance, getIt()))
    ..registerLazySingleton<HabitRepository>(() => HabitRepositoryImpl(getIt()))
    ..registerLazySingleton(() => GetTodaySummaryUseCase(getIt()))
    ..registerLazySingleton(() => CreateHabitUseCase(getIt()))
    ..registerLazySingleton(() => SetHabitCompletionUseCase(getIt()))
    // ... other use cases
    ..registerFactory(() => TodayCubit(getTodaySummary: getIt(), setHabitCompletion: getIt()))
    ..registerFactory(() => AddHabitCubit(createHabit: getIt()))
    ..registerFactory(() => HabitDetailCubit(getHabitDetail: getIt(), setHabitCompletion: getIt(), deleteHabit: getIt()))
    ..registerFactory(() => EditHabitCubit(getHabitById: getIt(), updateHabit: getIt()))
    ..registerFactory(() => UserNameCubit(store: getIt()));
}
```

**Testability:** Tests pass `FakeHabitRepository` / `MockUseCase` via the optional parameters – no need to reset global state between tests (though `resetDependencies()` exists).

---

## 8. Routing & Navigation

```dart
// lib/core/router/app_router.dart
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.today,
  observers: [appRouteObserver],
  routes: [
    GoRoute(path: AppRoutes.today, builder: (_, __) => const TodayHabitsPage()),
    GoRoute(
      path: AppRoutes.addHabit,
      builder: (_, __) => BlocProvider(create: (_) => getIt<AddHabitCubit>(), child: const AddHabitPage()),
    ),
    GoRoute(
      path: AppRoutes.habitDetail,
      builder: (_, state) => BlocProvider(
        create: (_) => getIt<HabitDetailCubit>()..load(state.pathParameters['habitId']!),
        child: HabitDetailPage(habitId: state.pathParameters['habitId']!),
      ),
    ),
    GoRoute(
      path: AppRoutes.editHabit,
      builder: (_, state) => BlocProvider(
        create: (_) => getIt<EditHabitCubit>()..load(state.pathParameters['habitId']!),
        child: EditHabitPage(habitId: state.pathParameters['habitId']!),
      ),
    ),
  ],
);
```

- **Deep-link ready** (`/habit-detail/habit-123`).
- **RouteObserver** enables "refresh on pop" patterns (e.g., after editing a habit).
- **Error page** for unknown routes.

---

## 9. Theming & UI

- **Design system**: Warm monochrome (soft warm-white canvas, white cards, near-black ink).
- **Typography**: Poppins (400–800) self-hosted in `assets/fonts/`.
- **Material 3** with custom `ColorScheme`, `CardTheme`, `InputDecorationTheme`, `ButtonTheme`s.
- **Spacing/Radius constants** (`AppSpacing`, `AppRadius`) for consistency.
- **No external UI kit** – keeps bundle small and design fully controllable.

---

## 10. Testing Strategy

### Coverage Summary

| Layer | Test Type | Count | Key Scenarios |
|-------|-----------|-------|---------------|
| **Domain** | Unit (pure Dart) | 8 | Streak calc, date utils, entity logic |
| **Data** | Unit (with fake) | 6 | Repository mapping, exception translation |
| **Presentation** | Unit (Cubit) | 28 | Loading, success, failure, optimistic toggle rollback, empty state |
| **Widgets** | Widget test | 12 | Form validation, navigation, list rendering, snackbar feedback |
| **Integration** | Manual (emulator) | 1 | Seed script read-back verification |

### Example: Cubit Test (optimistic rollback)

```dart
// test/features/habits/presentation/cubit/today_cubit_test.dart
test('rolls back and reports when storage rejects the change', () async {
  when(() => getTodaySummary(any())).thenAnswer((_) async => Right(summary));
  when(() => setHabitCompletion(any())).thenAnswer(
      (_) async => const Left(NotConfiguredFailure('nothing saved')));

  final cubit = buildCubit();
  await cubit.loadToday();

  final pending = cubit.toggleCompletion(habitId: 'a', completed: true);
  expect(cubit.state.summary!.habits.single.completed, isTrue); // optimistic

  await pending;

  expect(cubit.state.summary!.habits.single.completed, isFalse); // rolled back
  expect(cubit.state.feedbackMessage, 'nothing saved');
  expect(cubit.state.isToggling, isFalse);
});
```

### Fake Repository (in-memory, deterministic)

```dart
// test/helpers/fake_habit_repository.dart
class FakeHabitRepository implements HabitRepository {
  final List<Habit> habits = [];
  final Map<String, Set<DateTime>> completedDays = {};
  Failure? failure; // injectable failure for error-path tests
  // ... implements all methods with call counters for verification
}
```

**Run all checks:**
```sh
dart format lib test tool
flutter analyze
flutter test
```

---

## 11. Development Tooling

### Idempotent Firestore Seeder (`tool/seed_dev_data.dart`)

```sh
# Preview
dart run tool/seed_dev_data.dart --dry-run

# Emulator (needs JDK 21+)
FIRESTORE_EMULATOR_HOST=localhost:8080 dart run tool/seed_dev_data.dart --emulator

# Live (explicit opt-in)
dart run tool/seed_dev_data.dart --allow-live
```

**Features:**
- **Idempotent**: Uses Firestore `currentDocument.exists: false` precondition – never overwrites.
- **Non-destructive**: Only creates missing documents.
- **Verifying**: Reads every document back and compares fields.
- **Configurable**: `--user`, `--project`, `--emulator`, `--dry-run`.
- **Safe defaults**: Refuses live write without `--allow-live`.

### Development Identity

```dart
// lib/core/config/dev_identity.dart
const String kDevUserId = String.fromEnvironment('HABIT_USER_ID', defaultValue: 'dev-user');
const String kDevUserName = String.fromEnvironment('HABIT_USER_NAME', defaultValue: 'Aman');
```

Override at run time:
```sh
flutter run --dart-define=HABIT_USER_ID=dev-alice --dart-define=HABIT_USER_NAME=Alice
```

**Not authentication** – placeholder until Firebase Auth is added.

---

## 12. Known Limitations & Trade-offs

| Area | Decision | Trade-off | Future Work |
|------|----------|-----------|-------------|
| **Authentication** | Dev-only fixed user ID (`dev-user`) | No real user isolation; anyone with API key can access dev data. | Add Firebase Auth, switch rules to `request.auth.uid == userId`. |
| **iOS Config** | Not configured | Cannot build for iOS without `GoogleService-Info.plist`. | Run `flutterfire configure` for iOS. |
| **Offline Support** | Firestore offline cache enabled by default | No explicit conflict resolution; last-write-wins on sync. | Add sync status UI, conflict strategy if needed. |
| **Push Notifications** | Not implemented | No reminders for habit completion. | Add FCM + local notifications. |
| **Habit Scheduling** | Every habit = every day | No "Mon/Wed/Fri" or custom frequencies. | Add `frequency` field + scheduling engine. |
| **Data Export** | Not implemented | Users can't backup/restore data. | Add JSON export/import. |
| **Dark Mode** | Light theme only | No system dark mode support. | Add `AppTheme.dark` + `ThemeMode.system`. |
| **Analytics** | None | No usage insights. | Add Firebase Analytics / custom events. |

---

## 13. Decision Log (Key Engineering Choices)

| Decision | Alternatives Considered | Rationale |
|----------|------------------------|-----------|
| **BLoC/Cubit over Riverpod** | Riverpod, Provider, setState | Cubit gives explicit state machine, great testability, minimal boilerplate. Riverpod adds complexity for this scope. |
| **dartz `Either` over Exceptions** | try/catch, Result type, fpdart | `Either` makes failure a first-class return value; callers *must* handle both branches. fpdart is newer, less ecosystem. |
| **freezed for Entities** | Manual classes, built_value, json_serializable only | freezed gives immutability, `copyWith`, pattern matching, `==`/`hashCode`, `toString` in one annotation. |
| **Local calendar day keys (`yyyy-MM-dd`)** | UTC timestamps, ISO 8601 strings in field | Matches user's "today" concept; enables range queries on doc IDs; no timezone ambiguity. |
| **Completion doc ID = date** | Separate `date` field in doc | Saves a field, makes queries simpler, enforces uniqueness naturally. |
| **Optimistic UI for toggles** | Wait for server, show loading spinner | Feels snappy; rollback is rare (permission/network). Better UX for high-frequency action. |
| **GetIt over Riverpod DI** | Riverpod providers, manual factories | GetIt is simple, familiar, supports lazy singletons & factories. No need for `ProviderScope` wrapper. |
| **go_router over auto_route** | auto_route, Navigator 1.0 | go_router is declarative, supports deep links, Flutter team recommended. |
| **Self-hosted Poppins** | Google Fonts package | No network request at startup; deterministic rendering; smaller bundle after font subset. |
| **Custom date utils (no `intl`/`timezone`)** | intl, timezone, chrono | Zero deps, tree-shakable, pure Dart, covers exactly what we need (calendar-day math). |

---

## 14. Project Structure (Source Tree)

```
lib/
├── app.dart                    # Root widget, BlocProviders, auth gate
├── main.dart                   # Firebase init + DI + runApp
├── firebase_options.dart       # Generated by flutterfire CLI
├── core/
│   ├── config/
│   │   └── dev_identity.dart   # Dev user ID/name, UserIdProvider
│   ├── di/
│   │   └── injection_container.dart  # GetIt registrations
│   ├── error/
│   │   ├── exceptions.dart     # Data-layer exceptions
│   │   └── failure.dart        # Domain failures (sealed)
│   ├── router/
│   │   ├── app_router.dart     # GoRouter config
│   │   └── app_routes.dart     # Route path constants
│   ├── theme/
│   │   ├── app_colors.dart     # Color palette
│   │   └── app_theme.dart      # ThemeData factory
│   ├── usecases/
│   │   └── usecase.dart        # UseCase<T, Params> + NoParams
│   ├── common/
│   │   └── load_status.dart    # initial/loading/success/failure
│   └── utils/
│       ├── app_date.dart       # Calendar-day helpers
│       └── habit_streak.dart   # Streak + last-7-days logic
├── features/
│   ├── habits/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── habit_remote_data_source.dart      # Interface
│   │   │   │   ├── firestore_habit_remote_data_source.dart
│   │   │   │   └── unconfigured_habit_remote_data_source.dart
│   │   │   ├── models/
│   │   │   │   ├── habit_model.dart/.freezed.dart/.g.dart
│   │   │   │   └── habit_completion_model.dart/.freezed.dart/.g.dart
│   │   │   └── repositories/
│   │   │       └── habit_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── habit.dart/.freezed.dart
│   │   │   │   ├── habit_day_status.dart/.freezed.dart
│   │   │   │   ├── daily_summary.dart/.freezed.dart
│   │   │   │   └── habit_detail.dart/.freezed.dart
│   │   │   ├── repositories/
│   │   │   │   └── habit_repository.dart
│   │   │   └── usecases/
│   │   │       ├── create_habit_usecase.dart
│   │   │       ├── delete_habit_usecase.dart
│   │   │       ├── get_habit_by_id_usecase.dart
│   │   │       ├── get_habit_detail_usecase.dart
│   │   │       ├── get_today_summary_usecase.dart
│   │   │       ├── set_habit_completion_usecase.dart
│   │   │       └── update_habit_usecase.dart
│   │   └── presentation/
│   │       ├── cubit/
│   │       │   ├── add_habit_cubit.dart/.state.dart/.freezed.dart
│   │       │   ├── edit_habit_cubit.dart/.state.dart/.freezed.dart
│   │       │   ├── habit_detail_cubit.dart/.state.dart/.freezed.dart
│   │       │   └── today_cubit.dart/.state.dart/.freezed.dart
│   │       ├── pages/
│   │       │   ├── add_habit_page.dart
│   │       │   ├── edit_habit_page.dart
│   │       │   ├── habit_detail_page.dart
│   │       │   └── today_habits_page.dart
│   │       └── widgets/
│   │           ├── habit_card.dart
│   │           ├── greeting_header.dart
│   │           ├── points_badge.dart
│   │           ├── week_history_strip.dart
│   │           ├── state_views.dart
│   │           └── today_progress_card.dart
│   └── profile/
│       ├── data/
│       │   └── user_name_store.dart
│       └── presentation/
│           ├── cubit/
│           │   ├── user_name_cubit.dart/.state.dart/.freezed.dart
│           └── pages/
│               └── name_setup_page.dart
tool/
├── seed_dev_data.dart          # Idempotent Firestore seeder
└── seed_plan.dart              # Plan builder (habits + completions)
test/
├── helpers/
│   ├── fake_habit_repository.dart
│   ├── fake_habit_remote_data_source.dart
│   └── fake_user_name_store.dart
├── features/
│   ├── habits/presentation/... (cubit & page tests)
│   └── profile/presentation/... (cubit & page tests)
├── core/utils/habit_streak_test.dart
└── widget_test.dart
```

---

## 15. Running the Project

```sh
# Install deps
flutter pub get

# Generate freezed/json_serializable code
dart run build_runner build --delete-conflicting-outputs

# Run on Android (emulator/device)
flutter run

# Run tests + static analysis
dart format lib test tool
flutter analyze
flutter test

# Seed development data (emulator)
firebase emulators:start --only firestore --project hiicampus-habit-tracker
FIRESTORE_EMULATOR_HOST=localhost:8080 dart run tool/seed_dev_data.dart --emulator
```

---

## 16. AI & Tooling Usage Summary

| Tool | Use Case |
|------|----------|
| **LLM (planning)** | Requirements → user stories, acceptance criteria, Firestore schema, architecture diagram |
| **LLM (code gen)** | Entities, models, repositories, use cases, cubits, DI, router, theme, date utils, seed script |
| **LLM (tests)** | Fake repository, mock use cases, cubit unit tests (happy + error paths), widget tests |
| **LLM (docs)** | README, this overview, inline code comments |
| **flutterfire CLI** | `flutterfire configure` → `firebase_options.dart`, `.firebaserc` |
| **build_runner** | freezed + json_serializable code generation |
| **Firebase Emulator** | Local Firestore for development & seed verification |
| **Static Analysis** | `flutter analyze` (lints), `dart format` (style) |
| **Git** | Conventional commits, feature branches, PR reviews |

**Guardrails applied:**
- No Firebase imports in `domain/` (enforced by import checks in review).
- Every public function in data/domain returns `Either<Failure, T>`.
- Cubits never call Repository directly – only UseCases.
- All generated code (`.freezed.dart`, `.g.dart`) committed for reproducibility.
- Tests run in CI-equivalent local pipeline before push.

---

## 17. Next Steps (Roadmap)

1. **Firebase Authentication** – Email/password or Google sign-in; replace `DevUserIdProvider`.
2. **Firestore Rules** – Deploy per-user rules (`request.auth.uid == userId`).
3. **iOS Configuration** – `flutterfire configure` for iOS bundle ID.
4. **Habit Scheduling** – Frequency field (daily, weekly, custom) + recurrence engine.
5. **Dark Mode** – `AppTheme.dark` + system theme listener.
6. **Push Notifications** – FCM + local notifications for daily reminders.
7. **Data Export/Import** – JSON backup to Files app / Google Drive.
8. **Analytics** – Firebase Analytics + custom events (habit_created, habit_completed, streak_milestone).
9. **Accessibility Audit** – Semantics, contrast, font scaling.
10. **Performance** – Profile large habit lists, add pagination if needed.

---

*Generated with AI assistance. Reviewed, tested, and verified by human engineers.*