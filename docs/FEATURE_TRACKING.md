# Feature Tracking Document

## Journalist News App - Symmetry Assignment

**Last Updated:** 2026-03-26  

---

## Status Legend

| Status | Meaning |
|--------|---------|
| DONE | Fully implemented and working |
| PARTIAL | Stub or incomplete implementation exists |
| PENDING | Not started, planned for implementation |
| DEFERRED | Blocked on external dependency (e.g. billing) |

---

## 1. Current Features (Existing in Starter Project)

### 1.1 Core Features

| # | Feature | Description | Status | Location |
|---|---------|-------------|--------|----------|
| F-001 | Fetch Remote Articles | Fetches top US headlines from NewsAPI via Retrofit + Dio | DONE | `news_api_service.dart`, `article_repository_impl.dart` |
| F-002 | Display Article List | Scrollable list of articles with image, title, description, date | DONE | `pages/home/daily_news.dart`, `widgets/article_tile.dart` |
| F-003 | Article Detail View | Full-screen view with title, date, image, description, and content | DONE | `pages/article_detail/article_detail.dart` |
| F-004 | Save Article Locally | Save article to local SQLite database from detail view | DONE | `article_dao.dart`, `save_article.dart` use case |
| F-005 | View Saved Articles | Dedicated page listing locally saved articles | DONE | `pages/saved_article/saved_article.dart` |
| F-006 | Remove Saved Article | Remove article from local storage via icon button | DONE | `remove_article.dart` use case, `local_article_bloc.dart` |
| F-007 | Article Image Caching | Network images cached locally with loading/error states | DONE | `article_tile.dart` (CachedNetworkImage) |

### 1.2 Architecture & Infrastructure

| # | Feature | Description | Status | Location |
|---|---------|-------------|--------|----------|
| A-001 | Clean Architecture | 3-layer separation: data, domain, presentation | DONE | `lib/features/daily_news/` |
| A-002 | BLoC State Management | Remote and Local BLoCs with events and states | DONE | `bloc/article/remote/`, `bloc/article/local/` |
| A-003 | Dependency Injection | GetIt service locator with all deps registered | DONE | `injection_container.dart` |
| A-004 | Named Routing | Route handler for `/`, `/ArticleDetails`, `/SavedArticles`, `/CreateArticle`, `/EditArticle`, `/MyArticles`, `/Login`, `/SignUp` | DONE | `config/routes/routes.dart` |
| A-005 | Custom Theme | Muli font, white scaffold, styled AppBar | DONE | `config/theme/app_themes.dart` |
| A-006 | Local Database (Floor) | SQLite ORM with ArticleModel entity and ArticleDao | DONE | `data_sources/local/` |
| A-007 | REST API Client (Retrofit) | Code-generated HTTP client for NewsAPI | DONE | `data_sources/remote/` |
| A-008 | Data State Wrapper | Generic success/failure wrapper with AppException | DONE | `core/resources/data_state.dart` |
| A-009 | Abstract Use Case | Base use case pattern with generic types | DONE | `core/usecase/usecase.dart` |

---

## 2. New Features (Required by Assignment)

### 2.1 Backend / Firebase

| # | Feature | Description | Status | Priority |
|---|---------|-------------|--------|----------|
| N-001 | Firebase Project Setup | Created `symmetry-news-app-dac91`, configured `.firebaserc` | DONE | High |
| N-002 | FlutterFire Integration | Generated `firebase_options.dart`, added `Firebase.initializeApp()` | DONE | High |
| N-003 | Firestore Schema Design | Full schema in `backend/docs/DB_SCHEMA.md` with field types and constraints | DONE | High |
| N-004 | Firestore Schema Implementation | Firestore enabled (nam5 region), collections ready | DONE | High |
| N-005 | Firestore Security Rules | Field presence, type, length validation, server timestamp enforcement deployed | DONE | High |
| N-006 | Cloud Storage Rules | Rules deployed for `media/articles/` path (image/*, 5MB max) | DONE | High |
| N-007 | Firebase Emulator Configuration | Configured in `firebase.json` (Firestore:8080, Storage:9199, UI:4000), documented in `backend/docs/EMULATOR_SETUP.md` | DONE | Medium |

### 2.2 Frontend — Domain Layer

| # | Feature | Description | Status | Priority |
|---|---------|-------------|--------|----------|
| N-008 | Firebase Article Entity | `FirebaseArticleEntity` — Equatable, pure Dart, 8 fields (including `ownerUid`) | DONE | High |
| N-009 | Create Article Use Case | `CreateArticleUseCase` — delegates to repository | DONE | High |
| N-010 | Upload Image Use Case | `UploadArticleImageUseCase` — delegates to repository | DONE | High |
| N-011 | Create Article Repository (Abstract) | `CreateArticleRepository` — 4 methods (createArticle, updateArticle, uploadImage, getArticlesByOwner) | DONE | High |
| N-012 | Param Classes | `CreateArticleParams`, `UploadArticleImageParams` — Equatable | DONE | High |

### 2.3 Frontend — Presentation Layer

| # | Feature | Description | Status | Priority |
|---|---------|-------------|--------|----------|
| N-013 | Create Article Cubit | `CreateArticleCubit` — 6 states, 3 methods (uploadImage, submitArticle, reset) | DONE | High |
| N-014 | Add Article Page | `CreateArticlePage` — full form with image, 4 text fields, submit | DONE | High |
| N-015 | Image Picker Widget | `ImagePickerWidget` — placeholder, upload, preview, change states | DONE | High |
| N-016 | Form Validation | Client-side required field validation matching Firestore schema lengths | DONE | High |
| N-017 | Upload Progress Indicator | `CupertinoActivityIndicator` during image upload and article submission | DONE | Medium |
| N-018 | FAB Navigation to Add Article | FAB on home screen wired to `Navigator.pushNamed(context, '/CreateArticle')` | DONE | High |
| N-019 | Success/Error Feedback | SnackBar for errors/upload success, AlertDialog for publish success | DONE | Medium |

### 2.4 Frontend — Data Layer

| # | Feature | Description | Status | Priority |
|---|---------|-------------|--------|----------|
| N-020 | Firestore Article Data Source | `FirestoreArticleDataSourceImpl` — add() + read-back for server timestamp | DONE | High |
| N-021 | Cloud Storage Data Source | `StorageArticleDataSourceImpl` — upload with timestamp-prefixed filenames | DONE | High |
| N-022 | Firebase Article Model | `FirebaseArticleModel` — fromRawData, toJson, toUpdateJson, toEntity, fromEntity (includes `ownerUid` and `category`) | DONE | High |
| N-023 | Create Article Repository Impl | `CreateArticleRepositoryImpl` — orchestrates data sources, catches → AppException | DONE | High |
| N-024 | DI Registration (New Feature) | All new classes registered in `injection_container.dart` via GetIt | DONE | High |

### 2.5 Documentation

| # | Feature | Description | Status | Priority |
|---|---------|-------------|--------|----------|
| N-025 | DB Schema Document | `backend/docs/DB_SCHEMA.md` — full schema with field types, constraints | DONE | High |
| N-026 | Project Report | `docs/REPORT.md` — 7-section report per REPORT_INSTRUCTIONS template | DONE | High |

---

## 3. Technical Improvements

### 3.1 Security Fixes

| # | Improvement | Description | Status | Priority | File(s) |
|---|------------|-------------|--------|----------|---------|
| T-001 | Remove Hardcoded API Key | Move NewsAPI key to `--dart-define` env variable | DONE | Critical | `core/constants/constants.dart`, `.env.example` |
| T-002 | Fix Default Image URL | Replace Google Images search URL with `placehold.co` placeholder | DONE | High | `core/constants/constants.dart` |

### 3.2 Null Safety Fixes

| # | Improvement | Description | Status | Priority | File(s) |
|---|------------|-------------|--------|----------|---------|
| T-003 | Fix Force-Unwrap in Article Tile | Replace `article!.title!` with `?.` and `?? ''` / `?? kDefaultImage` patterns | DONE | High | `widgets/article_tile.dart` |
| T-004 | Fix Force-Unwrap in Article Detail | Replace `article!.title!` with null guards, add `errorBuilder` to Image.network | DONE | High | `pages/article_detail/article_detail.dart` |
| T-005 | Fix Force-Unwrap in Daily News | Replace `state.articles!` with `?? []`, add return type annotations | DONE | High | `pages/home/daily_news.dart` |
| T-006 | Fix Equatable Props Crash | Override props per subclass instead of force-unwrap nullable | DONE | Critical | `remote_article_state.dart`, `local_article_state.dart`, `local_article_event.dart` |

### 3.3 Deprecation Fixes

| # | Improvement | Description | Status | Priority | File(s) |
|---|------------|-------------|--------|----------|---------|
| T-007 | Replace `DioError` in Domain/Presentation | Replaced with `AppException` at repository boundary | DONE | Medium | `data_state.dart`, `remote_article_state.dart`, `article_repository_impl.dart` |
| T-008 | Replace `DioErrorType.response` | Caught at repository boundary, converted to AppException | DONE | Medium | `article_repository_impl.dart` |
| T-009 | Update Dart SDK Constraint | Changed `>=2.16.1 <3.0.0` to `>=3.3.0 <4.0.0` | DONE | Medium | `pubspec.yaml` |

### 3.4 Architecture Improvements

| # | Improvement | Description | Status | Priority | File(s) |
|---|------------|-------------|--------|----------|---------|
| T-010 | Remove Dio from DataState | Created `AppException`, removed Dio import from core | DONE | High | `core/resources/data_state.dart`, `core/resources/app_exception.dart` |
| T-011 | Remove Dio from Presentation States | States now use `AppException` not `DioError` | DONE | High | `bloc/article/remote/remote_article_state.dart` |
| T-012 | Add LocalArticlesError State | Added `LocalArticlesError` state, try/catch in BLoC, error UI with retry | DONE | Medium | `local_article_state.dart`, `local_article_bloc.dart`, `saved_article.dart` |
| T-013 | Implement `toEntity()` on Models | Added `toEntity()` to `ArticleModel` | DONE | Medium | `data/models/article.dart` |
| T-014 | Rename `pages` to `screens` | Architecture doc specifies `screens` folder | DONE | Low | `presentation/screens/` |
| T-015 | Add `shared` Folder | Architecture doc specifies a `shared` folder with reusable widgets | DONE | Low | `lib/shared/widgets/` |
| T-016 | Fix Force-Unwrap in Use Case Params | Replaced `params!` with `ArgumentError.notNull` guard in `save_article.dart` and `remove_article.dart` | DONE | Medium | `domain/usecases/save_article.dart`, `domain/usecases/remove_article.dart` |

### 3.5 Code Quality Improvements

| # | Improvement | Description | Status | Priority | File(s) |
|---|------------|-------------|--------|----------|---------|
| T-017 | Use ListView.builder | Replaced eager ListView with lazy ListView.builder | DONE | Medium | `pages/home/daily_news.dart` |
| T-018 | Add `const` Constructors | Added const constructors to article_tile widgets | DONE | Low | `widgets/article_tile.dart` |
| T-019 | Add Return Type Annotations | Added `PreferredSizeWidget` and `Widget` return types | DONE | Low | `pages/home/daily_news.dart` |
| T-020 | Remove Unused `intl` Dependency | Removed `intl` package from `pubspec.yaml` (zero usages in `lib/`) | DONE | Low | `pubspec.yaml` |

### 3.6 Testing

| # | Improvement | Description | Status | Priority | File(s) |
|---|------------|-------------|--------|----------|---------|
| T-021 | Add Unit Tests for New Use Cases | 13 tests covering create + upload + update + getByOwner use cases | DONE | High | `test/features/create_article/domain/usecases/` |
| T-022 | Add Unit Tests for Cubit | 17 tests covering all state transitions (create, update, upload, reset) | DONE | High | `test/features/create_article/presentation/cubit/` |
| T-023 | Add Unit Tests for Repository | 7 tests covering success/failure/model conversion/getArticlesByOwner | DONE | Medium | `test/features/create_article/data/repository/` |
| T-024 | Add Model Tests | 8 tests covering serialization, entity conversion | DONE | Medium | `test/features/create_article/data/models/` |
| T-025 | Add Entity Tests | 6 tests covering equality, nullable fields, props, category, ownerUid | DONE | Medium | `test/features/create_article/domain/entities/` |
| T-026 | Add Widget Tests | 23 widget tests for ArticleTextField (9 incl. readOnly), ImagePickerWidget (7), SubmitArticleButton (7) | DONE | Medium | `test/features/create_article/presentation/widgets/` |
| T-027 | Add Auth Tests | 32 tests for UserEntity (4), UserModel (5), auth use cases (10), AuthCubit (13) | DONE | High | `test/features/auth/` |
| T-028 | Add MyArticlesCubit Tests | 6 tests for my articles fetch/error/empty/exception handling | DONE | Medium | `test/features/create_article/presentation/cubit/` |
| T-029 | Add Daily News Use Case Tests | 13 tests: GetArticle (4), SaveArticle (3), RemoveArticle (3), GetSavedArticle (3) | DONE | High | `test/features/daily_news/domain/usecases/` |
| T-030 | Add RemoteArticlesBloc Tests | 5 tests: initial state, success, error, params passing, pagination/hasReachedMax | DONE | High | `test/features/daily_news/presentation/bloc/` |
| T-031 | Add LocalArticleBloc Tests | 6 tests: getSaved success/error, save+reload, remove+reload, save error, remove error | DONE | High | `test/features/daily_news/presentation/bloc/` |
| T-032 | Add AI Insight Tests | 53 tests: entity (5), params (10), model (14), use case (4), repository (10), cubit (12) — includes politicalLeaning coverage | DONE | High | `test/features/ai_insight/` |

### 3.7 Compliance Fixes

| # | Improvement | Description | Status | Priority | File(s) |
|---|------------|-------------|--------|----------|---------|
| T-032 | Remove flutter_hooks Dead Import | Removed `flutter_hooks` import; changed `HookWidget` → `StatelessWidget` | DONE | Low | `article_detail.dart`, `saved_article.dart` |
| T-033 | Add Equatable to RemoteArticlesEvent | Added `extends Equatable` and `props` for consistency with `LocalArticlesEvent` | DONE | Low | `remote_article_event.dart` |
| T-034 | Isolate Firebase from Auth Repository | Moved `FirebaseAuthException` handling into data source; repo catches `AppException` only | DONE | Medium | `firebase_auth_data_source_impl.dart`, `auth_repository_impl.dart` |
| T-035 | Register DraftService in DI | Added `DraftService` singleton to `injection_container.dart`; presentation uses `sl<DraftService>()` | DONE | Medium | `injection_container.dart`, `create_article_page.dart` |
| T-036 | Fix List<dynamic> Type in RemoteArticlesBloc | Added explicit `<ArticleEntity>` type annotations and import | DONE | Medium | `remote_article_bloc.dart` |
| T-037 | Fix AiInsightModel Inheritance | Changed `extends Equatable` → `extends AiInsightEntity` with `super()` constructor; removed redundant fields/props | DONE | Medium | `ai_insight_model.dart` |
| T-038 | Remove Dead flutter_hooks Dependency | Removed `flutter_hooks: ^0.18.3` from `pubspec.yaml` (zero imports in lib/) | DONE | Low | `pubspec.yaml` |
| T-039 | Remove Dead Muli Font Assets | Removed `fonts:` section from `pubspec.yaml` (all typography uses google_fonts) | DONE | Low | `pubspec.yaml` |
| T-040 | Make Author Field Read-Only | Author field `readOnly: true` with lock icon, pre-filled from AuthCubit; `_resolveAuthorName()` fallback chain | DONE | Medium | `create_article_page.dart`, `article_text_field.dart` |
| T-041 | Add politicalLeaning to AI Insight | Added field to entity, model, Gemini prompt, Firestore cache, UI panel; political leaning badge in bottom sheet | DONE | Medium | `ai_insight/` (all layers) |
| T-042 | Fix Firestore rules: allow owner-based updates | Rewrote `firestore.rules` with `ownerUid == request.auth.uid` for create/update, immutability for `ownerUid`/`createdAt` | DONE | High | `backend/firestore.rules` |
| T-043 | Add `category` to Firestore rules | Added `category` to `hasOnly` whitelist with type/length validation | DONE | High | `backend/firestore.rules` |
| T-044 | Add `ownerUid` through full stack | Added `ownerUid` field to entity, params, model, data sources, repository, cubit, UI; queries by UID instead of display name | DONE | High | `create_article/` (all layers) |
| T-045 | Fix AI insight cache rules | Added `politicalLeaning` to allowed fields in `ai_insights` Firestore rules | DONE | Medium | `backend/firestore.rules` |
| T-046 | Add FAB to home screen | Added `FloatingActionButton` with `Icons.add` to `daily_news.dart` navigating to `/CreateArticle` | DONE | High | `daily_news.dart` |
| T-047 | Strengthen integration smoke test | Added `Scaffold` and `BottomNavigationBar` assertions to `app_smoke_test.dart` | DONE | Low | `integration_test/app_smoke_test.dart` |

### 3.8 AI Insight Feature

| # | Improvement | Description | Status | Priority | File(s) |
|---|------------|-------------|--------|----------|---------|
| AI-001 | AI Insight Entity | `AiInsightEntity` — Equatable, 6 fields (summaryBullets, tone, toneExplanation, politicalLeaning, sourceContext, emphasisAnalysis) | DONE | High | `domain/entities/ai_insight_entity.dart` |
| AI-002 | Get Insight Params | `GetInsightParams` — Equatable, cacheKey getter (URL hash) | DONE | High | `domain/params/get_insight_params.dart` |
| AI-003 | AI Insight Repository (Abstract) | `AiInsightRepository` — getArticleInsight() method | DONE | High | `domain/repository/ai_insight_repository.dart` |
| AI-004 | Get Article Insight Use Case | `GetArticleInsightUseCase` — delegates to repository | DONE | High | `domain/usecases/get_article_insight_usecase.dart` |
| AI-005 | Data Source Interfaces | `GeminiDataSource` + `InsightCacheDataSource` abstractions | DONE | High | `data/data_sources/ai_insight_data_sources.dart` |
| AI-006 | Gemini Data Source Impl | Structured prompt requesting summary + tone + politicalLeaning + sourceContext + emphasisAnalysis, JSON parsing, `gemini-2.0-flash` model | DONE | High | `data/data_sources/gemini_data_source_impl.dart` |
| AI-007 | Firestore Insight Cache | Cache read/write in `ai_insights` Firestore collection | DONE | High | `data/data_sources/firestore_insight_cache_impl.dart` |
| AI-008 | AI Insight Model | `AiInsightModel extends AiInsightEntity` — fromJson/toJson/toEntity/fromEntity | DONE | High | `data/models/ai_insight_model.dart` |
| AI-009 | AI Insight Repository Impl | Cache-first: Firestore → Gemini → cache → return | DONE | High | `data/repository/ai_insight_repository_impl.dart` |
| AI-010 | AI Insight Cubit | `AiInsightCubit` — getInsight() method, 4 states | DONE | High | `presentation/cubit/ai_insight_cubit.dart` |
| AI-011 | AI Insight State | Initial/Loading/Loaded/Error via Equatable | DONE | High | `presentation/cubit/ai_insight_state.dart` |
| AI-012 | AI Insight Panel Widget | Collapsible card with tone badge, political leaning badge, bullets, expandable sections, "Read original" link, disclaimer | DONE | High | `presentation/widgets/ai_insight_panel.dart` |
| AI-013 | Article Detail Integration | MultiBlocProvider + AiInsightPanel in article detail body | DONE | High | `article_detail.dart` |
| AI-014 | DI Registration | All AI Insight classes registered in injection_container.dart | DONE | High | `injection_container.dart` |
| AI-015 | Gemini API Key Security | Key via `--dart-define=GEMINI_API_KEY=...` | DONE | High | `constants.dart` |

---

## 4. UI Improvements

| # | Improvement | Description | Status | Priority |
|---|------------|-------------|--------|----------|
| U-001 | Pull-to-Refresh | Added `RefreshIndicator` wrapping `ListView.builder` on home page | DONE | Medium |
| U-002 | Shimmer Loading | Replace activity indicator with skeleton shimmer loading | DONE | Low |
| U-003 | Category Filters | Horizontal chip bar for category filtering (7 categories) | DONE | Low |
| U-004 | Search Functionality | Debounced search bar in AppBar with clear button | DONE | Low |
| U-005 | Hero Image Animation | Hero animation wrapping images from list to detail | DONE | Low |
| U-006 | Empty State Illustration | EmptyStateWidget for empty saved articles | DONE | Low |
| U-007 | Dark Mode Support | ThemeCubit with light/dark/system modes, persisted to SharedPreferences | DONE | Low |
| U-008 | Bottom Navigation | 4-tab bottom nav (Home/Saved/Create/Profile) with IndexedStack | DONE | Low |
| U-009 | Splash Screen | Animated splash with fade-in + scale, 2-second transition | DONE | Low |
| U-010 | Error Retry on Home | Made error icon tappable with `GestureDetector`, shows "Tap to retry" text, dispatches `GetArticles` | DONE | Medium |

---

## 5. Overdelivery Features

| # | Feature | Description | Status | Priority |
|---|---------|-------------|--------|----------|
| O-001 | User Authentication | Firebase Auth with email/password sign-in, sign-up, sign-out, auth gate | DONE | Low |
| O-002 | Article Editing | Edit previously uploaded articles — My Articles screen, edit mode in CreateArticlePage | DONE | Low |
| O-003 | Article Categories/Tags | Optional category field on article creation with dropdown | DONE | Low |
| O-004 | Rich Text Editor | `flutter_quill` for formatted content | DEFERRED | Low |
| O-005 | Article Drafts | Auto-save drafts to SharedPreferences, restore on next visit | DONE | Low |
| O-006 | Multi-Image Gallery | Upload multiple images per article | DEFERRED | Low |
| O-007 | Article Sharing | Share article title + URL via share_plus | DONE | Low |
| O-008 | Push Notifications | FCM for new article alerts | DEFERRED | Low |
| O-009 | Offline Support | Connectivity detection with fallback to local cached articles | DONE | Low |
| O-010 | Pagination / Infinite Scroll | Page/pageSize params through full stack, load-more on scroll | DONE | Low |
| O-011 | CI/CD Pipeline | GitHub Actions for automated testing — not implemented (see note below) | DEFERRED | Low |
| O-012 | User Research Document | JTBD analysis, competitive benchmarks, 21 sources | DONE | Medium |
| O-013 | Product Requirements Document | PRD v2.0 with research-informed requirements | DONE | Medium |
| O-014 | Codebase Refactoring Report | 10 issues documented with root cause analysis | DONE | Medium |
| O-015 | Image Source Selection | Gallery + Camera via bottom sheet dialog | DONE | Medium |
| O-016 | Stateful Error Recovery | Error state preserves uploaded image URL for retry | DONE | Medium |
| O-017 | AI Insight — Perspective Context | Gemini-powered article summary + tone analysis + political leaning + source context + emphasis analysis with Firestore caching | DONE | High |

---

## Summary Statistics

| Category | Total | Done | Partial | Pending | Deferred |
|----------|-------|------|---------|---------|----------|
| Core Features (Existing) | 7 | 7 | 0 | 0 | 0 |
| Architecture (Existing) | 9 | 9 | 0 | 0 | 0 |
| New Features (Required) | 27 | 27 | 0 | 0 | 0 |
| Technical Improvements | 48 | 48 | 0 | 0 | 0 |
| AI Insight Feature | 15 | 15 | 0 | 0 | 0 |
| UI Improvements | 10 | 10 | 0 | 0 | 0 |
| Overdelivery Features | 17 | 13 | 0 | 0 | 4 |
| **Total** | **133** | **129** | **0** | **0** | **4** |

> **Note on deferred items**: O-004 (Rich Text Editor), O-006 (Multi-Image Gallery), and O-008 (Push Notifications) were deferred as low-ROI for the assignment scope — they would add complexity without demonstrating additional architectural skill. O-011 (CI/CD Pipeline) is not relevant for this assignment submission but would be essential in a production environment. A GitHub Actions workflow running `flutter analyze`, `flutter test`, and `flutter build apk` on every push to `main` would be the standard setup.
> 
> **Test counts**: 242 total tests — auth (42), create_article (91), daily_news (50), ai_insight (53). All passing.
