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
| A-004 | Named Routing | Route handler for `/`, `/ArticleDetails`, `/SavedArticles` | DONE | `config/routes/routes.dart` |
| A-005 | Custom Theme | Muli font, white scaffold, styled AppBar | DONE | `config/theme/app_themes.dart` |
| A-006 | Local Database (Floor) | SQLite ORM with ArticleModel entity and ArticleDao | DONE | `data_sources/local/` |
| A-007 | REST API Client (Retrofit) | Code-generated HTTP client for NewsAPI | DONE | `data_sources/remote/` |
| A-008 | Data State Wrapper | Generic success/failure wrapper for API responses | DONE | `core/resources/data_state.dart` |
| A-009 | Abstract Use Case | Base use case pattern with generic types | DONE | `core/usecase/usecase.dart` |

---

## 2. New Features (Required by Assignment) -- PENDING

### 2.1 Backend / Firebase

| # | Feature | Description | Status | Priority |
|---|---------|-------------|--------|----------|
| N-001 | Firebase Project Setup | Create Firebase project, configure `.firebaserc` with project ID | PENDING | High |
| N-002 | FlutterFire Integration | Run FlutterFire CLI, generate `firebase_options.dart`, call `Firebase.initializeApp()` | PENDING | High |
| N-003 | Firestore Schema Design | Design NoSQL schema for articles collection, document in `backend/docs/DB_SCHEMA.md` | PENDING | High |
| N-004 | Firestore Schema Implementation | Create collections, fields, and documents in Firestore | PENDING | High |
| N-005 | Firestore Security Rules | Write access control rules in `backend/firestore.rules` | PENDING | High |
| N-006 | Cloud Storage Rules | Write upload rules for `media/articles/` path in `backend/storage.rules` | PENDING | High |
| N-007 | Firebase Emulator Configuration | Configure and test with Firebase Emulator Suite locally | PENDING | Medium |

### 2.2 Frontend -- Domain Layer

| # | Feature | Description | Status | Priority |
|---|---------|-------------|--------|----------|
| N-008 | Firebase Article Entity | New domain entity for journalist-created articles (with `thumbnailURL`) | PENDING | High |
| N-009 | Create Article Use Case | Use case to create and store a new article in Firestore | PENDING | High |
| N-010 | Upload Image Use Case | Use case to upload thumbnail image to Cloud Storage | PENDING | High |
| N-011 | Create Article Repository (Abstract) | Abstract repository interface for article creation | PENDING | High |
| N-012 | Mock Data Implementation | Start with mock data in use cases before connecting Firebase | PENDING | High |

### 2.3 Frontend -- Presentation Layer

| # | Feature | Description | Status | Priority |
|---|---------|-------------|--------|----------|
| N-013 | Create Article BLoC/Cubit | State management for article creation flow (loading, success, error) | PENDING | High |
| N-014 | Add Article Page | Form UI with title, description, content fields and image picker | PENDING | High |
| N-015 | Image Picker Widget | Widget to select and preview thumbnail image from device | PENDING | High |
| N-016 | Form Validation | Client-side validation for required fields | PENDING | High |
| N-017 | Upload Progress Indicator | Visual feedback during image upload and article submission | PENDING | Medium |
| N-018 | FAB Navigation to Add Article | Replace TODO on home page FAB with navigation to Add Article page | PENDING | High |
| N-019 | Success/Error Feedback | SnackBar or dialog on article creation success or failure | PENDING | Medium |

### 2.4 Frontend -- Data Layer

| # | Feature | Description | Status | Priority |
|---|---------|-------------|--------|----------|
| N-020 | Firestore Article Data Source | Data source class for Firestore CRUD operations | PENDING | High |
| N-021 | Cloud Storage Data Source | Data source class for image upload to `media/articles/` | PENDING | High |
| N-022 | Firebase Article Model | Model extending entity with Firestore serialization (`fromJson`, `toJson`) | PENDING | High |
| N-023 | Create Article Repository Impl | Concrete repository connecting data sources to domain interface | PENDING | High |
| N-024 | DI Registration (New Feature) | Register new services, repository, use cases, and BLoC in GetIt | PENDING | High |

### 2.5 Documentation

| # | Feature | Description | Status | Priority |
|---|---------|-------------|--------|----------|
| N-025 | DB Schema Document | Write `backend/docs/DB_SCHEMA.md` with full schema documentation | PENDING | High |
| N-026 | Project Report | Write `docs/REPORT.md` following `REPORT_INSTRUCTIONS.md` template | PENDING | High |

---

## 3. Technical Improvements -- PENDING

### 3.1 Security Fixes

| # | Improvement | Description | Status | Priority | File(s) |
|---|------------|-------------|--------|----------|---------|
| T-001 | Remove Hardcoded API Key | Move NewsAPI key to environment variables (`.env` + `flutter_dotenv` or `--dart-define`) | PENDING | Critical | `core/constants/constants.dart` |
| T-002 | Fix Default Image URL | Replace Google Images search URL with a proper bundled asset fallback | PENDING | High | `core/constants/constants.dart` |

### 3.2 Null Safety Fixes

| # | Improvement | Description | Status | Priority | File(s) |
|---|------------|-------------|--------|----------|---------|
| T-003 | Fix Force-Unwrap in Article Tile | Replace `article!.title!`, `article!.urlToImage!` etc. with null-safe patterns (`??`, `?.`) | PENDING | High | `widgets/article_tile.dart` |
| T-004 | Fix Force-Unwrap in Article Detail | Replace `article!.title!` etc. with null guards | PENDING | High | `pages/article_detail/article_detail.dart` |
| T-005 | Fix Force-Unwrap in Daily News | Replace `state.articles!` with null-safe access | PENDING | High | `pages/home/daily_news.dart` |
| T-006 | Fix Equatable Props Crash | `RemoteArticlesState.props` calls `articles!` and `error!` which crash on null; override per subclass | PENDING | Critical | `bloc/article/remote/remote_article_state.dart` |

### 3.3 Deprecation Fixes

| # | Improvement | Description | Status | Priority | File(s) |
|---|------------|-------------|--------|----------|---------|
| T-007 | Replace `DioError` with `DioException` | Update to Dio 5.x API; `DioError` is deprecated | PENDING | Medium | `data_state.dart`, `remote_article_state.dart`, `article_repository_impl.dart` |
| T-008 | Replace `DioErrorType.response` | Update deprecated error type enum | PENDING | Medium | `article_repository_impl.dart` |
| T-009 | Update Dart SDK Constraint | Change `>=2.16.1 <3.0.0` to match actual requirement `>=3.3.0` | PENDING | Medium | `pubspec.yaml` |

### 3.4 Architecture Improvements

| # | Improvement | Description | Status | Priority | File(s) |
|---|------------|-------------|--------|----------|---------|
| T-010 | Remove Dio from DataState | `DataState` imports Dio, leaking HTTP implementation into core; use a custom error type | PENDING | High | `core/resources/data_state.dart` |
| T-011 | Remove Dio from Presentation States | `remote_article_state.dart` imports Dio directly; use domain-level error type | PENDING | High | `bloc/article/remote/remote_article_state.dart` |
| T-012 | Add LocalArticlesError State | No error state exists for local BLoC; DB failures are silently ignored | PENDING | Medium | `bloc/article/local/local_article_state.dart` |
| T-013 | Implement `toEntity()` on Models | Architecture doc requires models have `toEntity()` method; not implemented | PENDING | Medium | `data/models/article.dart` |
| T-014 | Rename `pages` to `screens` | Architecture doc specifies `screens` folder, not `pages` | PENDING | Low | `presentation/pages/` |
| T-015 | Add `shared` Folder | Architecture doc specifies a `shared` folder for cross-feature code; doesn't exist | PENDING | Low | `lib/` |
| T-016 | Create Proper Params Classes | Use typed Params classes for use cases instead of nullable generic | PENDING | Medium | `core/usecase/usecase.dart`, all use cases |

### 3.5 Code Quality Improvements

| # | Improvement | Description | Status | Priority | File(s) |
|---|------------|-------------|--------|----------|---------|
| T-017 | Use ListView.builder | Home page creates all article widgets eagerly in a loop; switch to `ListView.builder` for lazy rendering | PENDING | Medium | `pages/home/daily_news.dart` |
| T-018 | Add `const` Constructors | Missing `const` on `CupertinoActivityIndicator()`, `Icon(Icons.error)`, and other static widgets | PENDING | Low | Multiple files |
| T-019 | Add Return Type Annotations | `_buildAppbar()` and `_buildPage()` missing return types | PENDING | Low | `pages/home/daily_news.dart` |
| T-020 | Remove Unused `intl` Import | `intl` package is a dependency but never used for date formatting | PENDING | Low | `pubspec.yaml` |

### 3.6 Testing

| # | Improvement | Description | Status | Priority | File(s) |
|---|------------|-------------|--------|----------|---------|
| T-021 | Add Unit Tests for Use Cases | Test all 4 existing use cases + new ones | PENDING | High | `test/` (to create) |
| T-022 | Add Unit Tests for BLoCs | Test Remote and Local article BLoCs | PENDING | High | `test/` (to create) |
| T-023 | Add Unit Tests for Repository | Test `ArticleRepositoryImpl` with mocked data sources | PENDING | Medium | `test/` (to create) |
| T-024 | Add Widget Tests | Test key UI components (ArticleWidget, pages) | PENDING | Medium | `test/` (to create) |

---

## 4. UI Improvements -- PENDING

| # | Improvement | Description | Status | Priority |
|---|------------|-------------|--------|----------|
| U-001 | Pull-to-Refresh | Add pull-to-refresh on home page instead of static error icon | PENDING | Medium |
| U-002 | Shimmer Loading | Replace `CupertinoActivityIndicator` with skeleton/shimmer loading placeholders | PENDING | Low |
| U-003 | Category Filters | Add horizontal chip bar at top of home page for article categories | PENDING | Low |
| U-004 | Search Functionality | Add search bar in AppBar to search articles by keyword | PENDING | Low |
| U-005 | Hero Image Animation | Add hero animation for image transition from list to detail | PENDING | Low |
| U-006 | Empty State Illustration | Add proper illustration for empty saved articles instead of plain text | PENDING | Low |
| U-007 | Dark Mode Support | Add dark theme variant (Android night styles exist but Flutter theme has no dark mode) | PENDING | Low |
| U-008 | Bottom Navigation | Add bottom nav bar for Home / Saved / Create Article sections | PENDING | Low |
| U-009 | Splash Screen | Implement a proper splash screen (current launch backgrounds are white stubs) | PENDING | Low |
| U-010 | Error Retry on Home | Make error icon tappable to retry fetching articles | PENDING | Medium |

---

## 5. Overdelivery Features -- PENDING

| # | Feature | Description | Status | Priority |
|---|---------|-------------|--------|----------|
| O-001 | User Authentication | Firebase Auth for journalist sign-in and article ownership | PENDING | Low |
| O-002 | Article Editing | Edit previously uploaded articles | PENDING | Low |
| O-003 | Article Categories/Tags | Categorize uploaded articles with tags | PENDING | Low |
| O-004 | Rich Text Editor | Use `flutter_quill` or similar for formatted article content | PENDING | Low |
| O-005 | Article Drafts | Save articles as drafts before publishing | PENDING | Low |
| O-006 | Multi-Image Gallery | Upload multiple images per article | PENDING | Low |
| O-007 | Article Sharing | Share articles via deep links or social media | PENDING | Low |
| O-008 | Push Notifications | Firebase Cloud Messaging for new article alerts | PENDING | Low |
| O-009 | Offline Support | Read cached articles offline, queue uploads for when online | PENDING | Low |
| O-010 | Pagination / Infinite Scroll | Paginate article list instead of loading all at once | PENDING | Low |
| O-011 | CI/CD Pipeline | GitHub Actions for automated testing and deployment | PENDING | Low |

---

## Summary Statistics

| Category | Total | Done | Partial | Pending |
|----------|-------|------|---------|---------|
| Core Features (Existing) | 7 | 7 | 0 | 0 |
| Architecture (Existing) | 9 | 9 | 0 | 0 |
| New Features (Required) | 26 | 0 | 0 | 26 |
| Technical Improvements | 24 | 0 | 0 | 24 |
| UI Improvements | 10 | 0 | 0 | 10 |
| Overdelivery Features | 11 | 0 | 0 | 11 |
| **Total** | **87** | **16** | **0** | **71** |
