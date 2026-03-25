# Feature Tracking Document

## Journalist News App - Symmetry Assignment

**Last Updated:** 2026-03-25  

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
| A-004 | Named Routing | Route handler for `/`, `/ArticleDetails`, `/SavedArticles`, `/CreateArticle` | DONE | `config/routes/routes.dart` |
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
| N-008 | Firebase Article Entity | `FirebaseArticleEntity` — Equatable, pure Dart, 7 fields | DONE | High |
| N-009 | Create Article Use Case | `CreateArticleUseCase` — delegates to repository | DONE | High |
| N-010 | Upload Image Use Case | `UploadArticleImageUseCase` — delegates to repository | DONE | High |
| N-011 | Create Article Repository (Abstract) | `CreateArticleRepository` — 2 methods (createArticle, uploadImage) | DONE | High |
| N-012 | Param Classes | `CreateArticleParams`, `UploadArticleImageParams` — Equatable | DONE | High |

### 2.3 Frontend — Presentation Layer

| # | Feature | Description | Status | Priority |
|---|---------|-------------|--------|----------|
| N-013 | Create Article Cubit | `CreateArticleCubit` — 6 states, 3 methods (uploadImage, submitArticle, reset) | DONE | High |
| N-014 | Add Article Page | `CreateArticlePage` — full form with image, 4 text fields, submit | DONE | High |
| N-015 | Image Picker Widget | `ImagePickerWidget` — placeholder, upload, preview, change states | DONE | High |
| N-016 | Form Validation | Client-side required field validation matching Firestore schema lengths | DONE | High |
| N-017 | Upload Progress Indicator | `CupertinoActivityIndicator` during image upload and article submission | DONE | Medium |
| N-018 | FAB Navigation to Add Article | FAB wired to `Navigator.pushNamed(context, '/CreateArticle')` | DONE | High |
| N-019 | Success/Error Feedback | SnackBar for errors/upload success, AlertDialog for publish success | DONE | Medium |

### 2.4 Frontend — Data Layer

| # | Feature | Description | Status | Priority |
|---|---------|-------------|--------|----------|
| N-020 | Firestore Article Data Source | `FirestoreArticleDataSourceImpl` — add() + read-back for server timestamp | DONE | High |
| N-021 | Cloud Storage Data Source | `StorageArticleDataSourceImpl` — upload with timestamp-prefixed filenames | DONE | High |
| N-022 | Firebase Article Model | `FirebaseArticleModel` — fromRawData, toJson, toEntity, fromEntity | DONE | High |
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
| T-014 | Rename `pages` to `screens` | Architecture doc specifies `screens` folder | PENDING | Low | `presentation/pages/` |
| T-015 | Add `shared` Folder | Architecture doc specifies a `shared` folder | PENDING | Low | `lib/` |
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
| T-021 | Add Unit Tests for New Use Cases | 6 tests covering create + upload use cases | DONE | High | `test/features/create_article/domain/usecases/` |
| T-022 | Add Unit Tests for Cubit | 11 tests covering all state transitions and edge cases | DONE | High | `test/features/create_article/presentation/cubit/` |
| T-023 | Add Unit Tests for Repository | 5 tests covering success/failure/model conversion | DONE | Medium | `test/features/create_article/data/repository/` |
| T-024 | Add Model Tests | 8 tests covering serialization, entity conversion | DONE | Medium | `test/features/create_article/data/models/` |
| T-025 | Add Entity Tests | 4 tests covering equality, nullable fields, props | DONE | Medium | `test/features/create_article/domain/entities/` |
| T-026 | Add Widget Tests | 21 widget tests for ArticleTextField (7), ImagePickerWidget (7), SubmitArticleButton (7) | DONE | Medium | `test/features/create_article/presentation/widgets/` |

---

## 4. UI Improvements

| # | Improvement | Description | Status | Priority |
|---|------------|-------------|--------|----------|
| U-001 | Pull-to-Refresh | Added `RefreshIndicator` wrapping `ListView.builder` on home page | DONE | Medium |
| U-002 | Shimmer Loading | Replace activity indicator with skeleton loading | PENDING | Low |
| U-003 | Category Filters | Add horizontal chip bar for categories | PENDING | Low |
| U-004 | Search Functionality | Add search bar in AppBar | PENDING | Low |
| U-005 | Hero Image Animation | Add hero animation from list to detail | PENDING | Low |
| U-006 | Empty State Illustration | Add illustration for empty saved articles | PENDING | Low |
| U-007 | Dark Mode Support | Add dark theme variant | PENDING | Low |
| U-008 | Bottom Navigation | Add bottom nav for Home / Saved / Create | PENDING | Low |
| U-009 | Splash Screen | Implement proper splash screen | PENDING | Low |
| U-010 | Error Retry on Home | Made error icon tappable with `GestureDetector`, shows "Tap to retry" text, dispatches `GetArticles` | DONE | Medium |

---

## 5. Overdelivery Features

| # | Feature | Description | Status | Priority |
|---|---------|-------------|--------|----------|
| O-001 | User Authentication | Firebase Auth for journalist sign-in | PENDING | Low |
| O-002 | Article Editing | Edit previously uploaded articles | PENDING | Low |
| O-003 | Article Categories/Tags | Categorize uploaded articles with tags | PENDING | Low |
| O-004 | Rich Text Editor | `flutter_quill` for formatted content | PENDING | Low |
| O-005 | Article Drafts | Save articles as drafts before publishing | PENDING | Low |
| O-006 | Multi-Image Gallery | Upload multiple images per article | PENDING | Low |
| O-007 | Article Sharing | Share articles via deep links or social media | PENDING | Low |
| O-008 | Push Notifications | FCM for new article alerts | PENDING | Low |
| O-009 | Offline Support | Read cached articles offline, queue uploads | PENDING | Low |
| O-010 | Pagination / Infinite Scroll | Paginate article list | PENDING | Low |
| O-011 | CI/CD Pipeline | GitHub Actions for automated testing | PENDING | Low |
| O-012 | User Research Document | JTBD analysis, competitive benchmarks, 21 sources | DONE | Medium |
| O-013 | Product Requirements Document | PRD v2.0 with research-informed requirements | DONE | Medium |
| O-014 | Codebase Refactoring Report | 10 issues documented with root cause analysis | DONE | Medium |
| O-015 | Image Source Selection | Gallery + Camera via bottom sheet dialog | DONE | Medium |
| O-016 | Stateful Error Recovery | Error state preserves uploaded image URL for retry | DONE | Medium |

---

## Summary Statistics

| Category | Total | Done | Partial | Pending | Deferred |
|----------|-------|------|---------|---------|----------|
| Core Features (Existing) | 7 | 7 | 0 | 0 | 0 |
| Architecture (Existing) | 9 | 9 | 0 | 0 | 0 |
| New Features (Required) | 27 | 27 | 0 | 0 | 0 |
| Technical Improvements | 26 | 22 | 0 | 4 | 0 |
| UI Improvements | 10 | 2 | 0 | 8 | 0 |
| Overdelivery Features | 16 | 5 | 0 | 11 | 0 |
| **Total** | **95** | **72** | **0** | **23** | **0** |
