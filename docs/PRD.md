# Product Requirements Document (PRD)

## Journalist News App - Symmetry Assignment

**Document Version:** 3.1  
**Date:** 2026-03-26  
**Author:** Diego  
**Status:** Research-Informed Draft  

---

## 1. Vision

Build the **first mobile-native news app where journalists can create and publish articles from their phone** — filling a market gap left by Medium (disabled mobile editing in 2022), Ghost (no mobile app), Substack (read-focused mobile), and WordPress (clunky mobile editor). The app must pass two UX tests simultaneously:

- **Grandmother Test:** A 90-year-old can use every feature without help (large targets, clear labels, predictable navigation)
- **NPC Test:** An 18-year-old uses the app and thinks "this shit goes hard" (dark mode, smooth animations, modern aesthetic)

---

## 2. Mission

Deliver a fully functional, well-architected Flutter application that:

1. Extends the existing news-reading starter project with a complete **article creation and upload pipeline**
2. Integrates a **Firebase backend** (Firestore + Cloud Storage) for persistent, cloud-based article storage
3. Follows **Clean Architecture** principles with strict layer separation and zero architecture violations
4. Demonstrates **code quality, testing, and documentation** that exceeds the assignment's minimum requirements
5. Provides a polished, intuitive **user experience** for both reading and creating articles

---

## 3. Target Users

> See [USER_RESEARCH.md §1-2](./USER_RESEARCH.md) for full JTBD analysis and deep-dive personas.

| User Type | Description | Key Jobs | Key Pain Points |
|-----------|-------------|----------|----------------|
| **Reader** | Browses top headlines, reads details, saves favorites. Age 16-90+. | Stay informed in under 2 minutes; save articles for later; feel in control | Information overload; stale content; context switching to browser |
| **Journalist** | Creates and publishes articles from mobile. Age 22-55. Citizen journalists, freelancers, student reporters. | Publish from the field while story is fresh; never lose a draft; look professional | Every platform's mobile editor is broken or absent; image handling is painful; no feedback loop |

### Critical Behavioral Data

| Metric | Value | Source |
|--------|-------|--------|
| Users expecting mobile form completion | 82% | Tinyform, 2025 |
| Users preferring dark mode | 68% | SanjayDey.com |
| Day 1 app retention rate | 25% average | Adjust, 2025 |
| 18-29 year-olds who prefer *reading* news | 45% | Pew Research, Aug 2025 |
| Abandon threshold for mobile creation | 2 friction points | Journalist behavioral research |

---

## 4. Product Scope

### 4.1 In Scope

- Article creation form with title, description, content, and thumbnail image upload
- Firebase Firestore integration for storing journalist-created articles
- Firebase Cloud Storage integration for article thumbnail images
- Firestore and Storage security rules
- NoSQL schema design and documentation
- Full Clean Architecture implementation for the new feature
- BLoC/Cubit state management for article creation flow
- UI built from the provided Figma prototype
- Proper error handling, loading states, and user feedback
- Comprehensive project report

### 4.2 Out of Scope (Future Considerations)

- Rich text editor for article content (keep it simple — Ghost's success is attributed to simplicity; see [Assumption 11](./USER_RESEARCH.md#assumption-11))
- Push notifications
- Analytics dashboard
- Multi-platform deployment (web, desktop)

### 4.3 Competitive Context

> See [USER_RESEARCH.md §5](./USER_RESEARCH.md) for full competitive benchmark analysis of 7 platforms.

**Key insight:** No major platform offers a good mobile article creation experience. This is our differentiation:

| Competitor | Mobile Writing Score | Our Advantage |
|-----------|---------------------|---------------|
| Medium | 0/5 (disabled in 2022) | We exist |
| Ghost | 0/5 (no mobile app) | We exist |
| Flipboard | 0/5 (curation only) | We create |
| Substack | 2/5 (read-focused) | First-class mobile editor |
| WordPress | 3/5 (clunky blocks) | Dramatically simpler — no blocks |
| LinkedIn | 2/5 (limited) | Focused, not social-first |

---

## 5. Functional Requirements

### FR-1: Browse News Articles (Existing — needs fixes)
- **FR-1.1:** App fetches top headlines from NewsAPI on launch via `RemoteArticlesBloc`
- **FR-1.2:** Articles displayed in a scrollable list with image, title, description, and date
- **FR-1.3:** Tapping an article navigates to detail view with full content
- **FR-1.4:** Loading state shows `CupertinoActivityIndicator`; error state shows refresh icon
- **FR-1.5:** *(Bug fix needed)* Article tiles don't show source/author — entity has the field but UI doesn't render it
- **FR-1.6:** *(Bug fix needed)* `RemoteArticlesState` Equatable props crash on null access
- **FR-1.7:** *(Bug fix needed)* Home uses eager `ListView` — should use `ListView.builder` for performance

### FR-2: Save Articles Locally (Existing — needs fixes)
- **FR-2.1:** User can save any article to local SQLite (Floor) from detail view FAB
- **FR-2.2:** User navigates to Saved Articles via AppBar bookmark icon (push navigation)
- **FR-2.3:** User can remove saved articles by tapping red remove icon
- **FR-2.4:** Saving shows confirmation SnackBar: "Article saved successfully."
- **FR-2.5:** *(Bug)* No duplicate-save check — same article can be saved repeatedly
- **FR-2.6:** *(Bug)* No removal confirmation or undo — articles deleted immediately

### FR-3: Create & Upload Article (New — Assignment Core)
- **FR-3.1:** FAB on home page navigates to "Create Article" page (replaces TODO at `daily_news.dart:74`)
- **FR-3.2:** Form includes: title, description, content, and thumbnail image
- **FR-3.3:** User can select an image from device gallery (via `image_picker`)
- **FR-3.4:** Image compressed client-side before upload ([Assumption 7](./USER_RESEARCH.md#assumption-7): image handling is #1 friction point)
- **FR-3.5:** Image uploaded to Firebase Cloud Storage at path `media/articles/{timestamp}_{filename}`
- **FR-3.6:** Article data (title, description, content, `thumbnailURL`, timestamp, author) stored in Firestore
- **FR-3.7:** Form validates required fields with inline error messages (not toast/dialog)
- **FR-3.8:** Loading indicator with progress displayed during upload
- **FR-3.9:** Success feedback with clear confirmation on completion
- **FR-3.10:** Error handling with user-friendly messages + retry option on failure
- **FR-3.11:** *(Overdelivery)* Preview before publish — reduces publishing anxiety ([Assumption 12](./USER_RESEARCH.md#assumption-12))
- **FR-3.12:** *(Overdelivery)* Local draft autosave — debounced, every 5s after last keystroke ([Assumption 3](./USER_RESEARCH.md#assumption-3))

### FR-4: Firebase Backend (New - Assignment Core)
- **FR-4.1:** Firestore schema designed and documented in `backend/docs/DB_SCHEMA.md`
- **FR-4.2:** Firestore collections and fields created per schema
- **FR-4.3:** Firestore security rules enforce schema and access control
- **FR-4.4:** Cloud Storage security rules enforce path structure and file types
- **FR-4.5:** Firebase Emulator Suite configured for local development

### FR-5: AI Insight — Perspective Context (New — Overdelivery)
- **FR-5.1:** User can request an AI-generated insight for any article from the detail view
- **FR-5.2:** Insight includes: 3-5 key fact summary bullets, tone classification with explanation, political leaning of the article's perspective, source context, and emphasis analysis
- **FR-5.3:** Insights generated via Google Gemini API (`gemini-2.0-flash` model) with structured JSON prompt
- **FR-5.4:** Results cached in Firestore `ai_insights` collection (keyed by URL hash) for deduplication
- **FR-5.5:** Cache-first strategy: check Firestore → on miss, call Gemini → cache result → return
- **FR-5.6:** Lazy-loaded: only triggered when user taps "Get AI Insight" button (no automatic API calls)
- **FR-5.7:** Collapsible card UI with tone badge (color-coded), political leaning badge, summary bullets (always visible when loaded), "Read original article" link, and expandable sections for tone explanation, source context, and emphasis analysis
- **FR-5.8:** Always displays "AI-generated, verify independently" disclaimer
- **FR-5.9:** Graceful error handling: error state with user-friendly message, no crash on API failure
- **FR-5.10:** Gemini API key secured via `--dart-define=GEMINI_API_KEY=...` (same pattern as NewsAPI key)

---

## 6. Non-Functional Requirements

### NFR-1: Architecture
- Strict **Clean Architecture** with 3 layers (data, domain, presentation)
- Domain layer must have **zero framework imports** (pure Dart)
- All cross-layer communication through **abstract repository interfaces**
- **Dependency injection** via GetIt for all services and repositories

### NFR-2: Code Quality
- Follow all 6 **Coding Guidelines** from the docs
- Avoid all **50 Architecture Violations** listed in `ARCHITECTURE_VIOLATIONS.md`
- Meaningful naming, small functions, small classes
- Proper null safety (no force-unwrap crashes)

### NFR-3: State Management
- All UI state managed through **BLoC or Cubit** (no setState)
- Proper loading, success, and error states for every async operation

### NFR-4: Testing
- TDD approach as specified in Coding Guidelines
- Unit tests for use cases and repository implementations
- Widget tests for key UI components
- Test file structure mirrors `lib/` directory

### NFR-5: Performance
- Cached network images with loading placeholders
- Efficient list rendering (`ListView.builder`, not eager list creation)
- Image compression before upload to Cloud Storage (<500KB target)
- All API calls must have timeout handling

### NFR-6: UX Quality
- **Accessibility:** Min 48x48dp touch targets, 4.5:1 contrast ratio, screen reader `Semantics` on all interactive elements (see [USER_RESEARCH.md §7.5](./USER_RESEARCH.md))
- **Microinteractions:** Bookmark animation, publish feedback, form validation feedback (see [USER_RESEARCH.md §7.7](./USER_RESEARCH.md))
- **Error handling:** Every error state has a clear recovery action — never a dead end (see [USER_RESEARCH.md §7.8](./USER_RESEARCH.md))
- **Inline validation:** Real-time field-level validation, not form-level submit-and-fail

### NFR-7: Documentation
- DB schema documented in `backend/docs/DB_SCHEMA.md`
- Project report in `docs/REPORT.md` following the template
- Clean, self-documenting code
- Architecture decisions documented with rationale

---

## 7. Technical Architecture

### 7.1 System Diagram

```
+-------------------+       +-------------------+       +-------------------+
|   Flutter App     |       |   Firebase        |       |   NewsAPI         |
|   (Frontend)      |<----->|   (Backend)       |       |   (External)      |
|                   |       |   - Firestore     |       |                   |
|  Clean Arch:      |       |   - Cloud Storage |       |  GET /top-        |
|  - Presentation   |       |   - Emulator      |       |  headlines        |
|  - Domain         |       +-------------------+       +-------------------+
|  - Data           |               ^                          ^
+-------------------+               |                          |
        |                    Write articles             Read articles
        |                    Cache AI insights
        +--------------------+------+-----------------------+--+
                                                            |
                                                    +-------------------+
                                                    |   Google Gemini   |
                                                    |   (AI API)        |
                                                    |   gemini-2.0-flash|
                                                    +-------------------+
```

### 7.2 Tech Stack

| Component | Technology |
|-----------|-----------|
| Frontend Framework | Flutter (Dart) |
| State Management | flutter_bloc (BLoC/Cubit) |
| Dependency Injection | get_it |
| HTTP Client | Dio + Retrofit (code generation) |
| Local Database | Floor (SQLite ORM) |
| Remote Database | Firebase Firestore |
| File Storage | Firebase Cloud Storage |
| AI/ML API | Google Gemini (`google_generative_ai`) |
| Image Handling | cached_network_image, image_picker |
| Build Tools | build_runner (code gen for Floor, Retrofit) |

### 7.3 Feature Module Structure (New Feature)

```
lib/features/create_article/
├── data/
│   ├── data_sources/
│   │   └── remote/
│   │       ├── firestore_article_service.dart
│   │       └── storage_service.dart
│   ├── models/
│   │   └── firebase_article_model.dart
│   └── repository/
│       └── create_article_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── firebase_article.dart
│   ├── repository/
│   │   └── create_article_repository.dart
│   └── usecases/
│       ├── create_article.dart
│       └── upload_article_image.dart
└── presentation/
    ├── bloc/
    │   └── create_article/
    │       ├── create_article_bloc.dart
    │       ├── create_article_event.dart
    │       └── create_article_state.dart
    ├── pages/
    │   └── create_article/
    │       └── create_article.dart
    └── widgets/
        ├── article_form.dart
        └── image_picker_widget.dart
```

### 7.4 AI Insight Module Structure (New Feature)

```
lib/features/ai_insight/
├── data/
│   ├── data_sources/
│   │   ├── ai_insight_data_sources.dart       # Abstract interfaces
│   │   ├── gemini_data_source_impl.dart       # Gemini API call + JSON parsing
│   │   └── firestore_insight_cache_impl.dart  # Firestore cache read/write
│   ├── models/
│   │   └── ai_insight_model.dart              # Serialization model
│   └── repository/
│       └── ai_insight_repository_impl.dart    # Cache-first strategy
├── domain/
│   ├── entities/
│   │   └── ai_insight_entity.dart             # Domain entity (Equatable)
│   ├── params/
│   │   └── get_insight_params.dart            # Use case params + cacheKey
│   ├── repository/
│   │   └── ai_insight_repository.dart         # Abstract interface
│   └── usecases/
│       └── get_article_insight_usecase.dart
└── presentation/
    ├── cubit/
    │   ├── ai_insight_cubit.dart              # State management
    │   └── ai_insight_state.dart              # Initial/Loading/Loaded/Error
    └── widgets/
        └── ai_insight_panel.dart              # Collapsible card UI
```

---

## 8. User Flows

> Full Mermaid diagrams: see [USER_RESEARCH.md §3](./USER_RESEARCH.md) (current) and [§4](./USER_RESEARCH.md) (proposed).

### 8.1 Read Article (Existing — code-verified)
```
App Launch → DI Init → Home (RemoteArticlesBloc fires GetArticles)
  → Loading: CupertinoActivityIndicator
  → Error: Refresh icon (no retry action)
  → Done: ListView of ArticleWidgets (Image + Title + Description + Date)
    → Tap Card → push /ArticleDetails
      → Detail: Title + Date + Image + Description + Content
      → [Tap Bookmark FAB → SaveArticle event → SnackBar] (no duplicate check)
      → [Tap Back Chevron → Navigator.pop]
```

### 8.2 View Saved Articles (Existing — code-verified)
```
Home → Tap AppBar Bookmark Icon → push /SavedArticles
  → Loading: CupertinoActivityIndicator
  → Done + Empty: "NO SAVED ARTICLES" plain text
  → Done + Has Articles: ListView.builder (ArticleWidget, isRemovable: true)
    → [Tap Article → push /ArticleDetails]
    → [Tap Red Remove Icon → RemoveArticle event → List rebuilds, no animation/undo]
    → [Tap Back Chevron → Navigator.pop]
```

### 8.3 Create Article (New — proposed)
```
Home → Tap FAB (+) → push /CreateArticle
  → Create Article Form:
    → Title Field (required, max 100 chars)
    → Description Field (required, max 200 chars)
    → Content Field (required, expandable)
    → Thumbnail Image (optional — tap area → image_picker → compress → preview)
  → Tap "Publish"
    → Inline Validation:
      → Missing required field → highlight field + inline error
      → No image → warning dialog: "Publish without thumbnail?"
    → All valid:
      → Upload Progress overlay
      → Upload image to Cloud Storage
      → Save article to Firestore
      → Success → confirmation + navigate back to home
      → Failure → friendly error + retry option
```

### 8.4 AI Insight (New — overdelivery)
```
Article Detail → Scroll down → See "Get AI Insight" button
  → Tap "Get AI Insight"
    → AiInsightCubit emits Loading (shimmer indicator)
    → Repository: Check Firestore cache (by URL hash)
      → Cache HIT → Return cached insight → emit Loaded
      → Cache MISS → Call Gemini API → Parse JSON → Cache in Firestore → emit Loaded
    → Loaded: Collapsible card appears:
      → Tone badge (color-coded: neutral=blue, critical=orange, alarming=red, etc.)
      → Political leaning badge (left/center-left/center/center-right/right)
      → 3-5 Summary bullet points (always visible)
      → "Read original article" link (opens source URL)
      → Expandable sections: Tone Explanation, Source Context, Emphasis Analysis
      → "AI-generated, verify independently" disclaimer
    → Error → User-friendly message with retry option
```

---

## 9. Risks and Mitigations

| # | Risk | Impact | Likelihood | Mitigation |
|---|------|--------|------------|------------|
| R1 | Hardcoded API key in `core/constants/constants.dart` | Security breach — key exposed in git | **Certain** | Move to `.env` via `flutter_dotenv` or `--dart-define` |
| R2 | Null force-unwrap (`!`) throughout codebase | Runtime crashes on null data from API | **High** | Replace with null-safe patterns (`??`, `?.`, null checks) |
| R3 | `RemoteArticlesState` Equatable props call `articles!`/`error!` on null | Crash when accessing state props | **Certain** | Fix Equatable props to handle nullable fields |
| R4 | Dio leaks into `core/data_state.dart` and presentation layer | Architecture violation; coupling | **Certain** | Replace `DioError` with domain-level error abstraction |
| R5 | No `Firebase.initializeApp()` in `main.dart` | App crash on any Firebase call | **Certain** | Add init before `runApp()` with proper `firebase_options.dart` |
| R6 | No tests exist at all | Regressions; no confidence in changes | **Certain** | TDD for new features; add critical tests for existing code |
| R7 | Deprecated Dio APIs (`DioError`, `DioErrorType.response`) | Build warnings, future breakage | **High** | Upgrade to Dio 5.x patterns: `DioException`, `DioExceptionType` |
| R8 | Outdated SDK constraint | Dependency resolution failures | **Medium** | Update to `>=3.3.0` |
| R9 | No duplicate-save protection | SQLite bloat; confusing UX | **Medium** | Check existence before insert in use case or repository |
| R10 | Firebase project not set up (placeholder in `.firebaserc`) | All backend work blocked | **Certain** | Create Firebase project + FlutterFire CLI config first |

---

## 10. Success Criteria

### Must-Have (Assignment Fails Without These)
1. "Create Article" feature is fully functional end-to-end (form → image upload → Firestore save)
2. Clean Architecture followed with zero violations from `ARCHITECTURE_VIOLATIONS.md`
3. Firebase backend properly configured with security rules that enforce schema
4. DB schema documented in `backend/docs/DB_SCHEMA.md`
5. Report complete and follows `REPORT_INSTRUCTIONS.md` template
6. Code passes `flutter analyze` with zero issues

### Should-Have (Strong Submission)
7. TDD approach with tests for use cases, repository, and key widgets
8. Existing bugs fixed (Equatable crash, null safety, deprecated APIs)
9. Hardcoded API key removed and externalized
10. Form validation with inline error messages

### Overdelivery (Ace the Assignment)
11. Image compression before upload
12. Preview before publish
13. Local draft autosave
14. Microinteractions (bookmark animation, publish feedback)
15. Accessibility compliance (48dp targets, 4.5:1 contrast, Semantics)
16. Dark mode support

---

## 11. Milestones

> Execution order based on [USER_RESEARCH.md §9 Priority Matrix](./USER_RESEARCH.md).

| Phase | Description | Key Deliverables | Status |
|-------|-------------|-----------------|--------|
| **Phase 0** | Codebase analysis + research | PRD, USER_RESEARCH.md, FEATURE_TRACKING.md | **Complete** |
| **Phase 1** | Fix existing code issues | Equatable crash, null safety, deprecated APIs, hardcoded key, architecture violations | Pending |
| **Phase 2** | Firebase setup | Firebase project, FlutterFire CLI, `firebase_options.dart`, `Firebase.initializeApp()` | Pending |
| **Phase 3** | Backend schema + rules | `DB_SCHEMA.md`, `firestore.rules`, `storage.rules` | Pending |
| **Phase 4** | Domain layer (TDD) | `FirebaseArticleEntity`, `CreateArticleUseCase`, `UploadImageUseCase`, abstract repository | Pending |
| **Phase 5** | Data layer (TDD) | Firestore data source, Storage data source, `FirebaseArticleModel`, repository impl | Pending |
| **Phase 6** | Presentation layer (TDD) | `CreateArticleCubit`, Create Article page, form widgets, image picker, validation | Pending |
| **Phase 7** | Integration + wiring | DI registration, route setup, FAB navigation, end-to-end testing | Pending |
| **Phase 8** | Polish + overdelivery | Image compression, preview, autosave, microinteractions, accessibility | Pending |
| **Phase 9** | Report + documentation | `REPORT.md`, final code review, cleanup | Pending |

---

## 12. Key Design Decisions

> Each decision is justified by research data. See [USER_RESEARCH.md](./USER_RESEARCH.md) for sources.

| Decision | Chosen | Rejected | Rationale |
|----------|--------|----------|-----------|
| Form complexity | 4 fields: title, description, content, image | Categories, tags, scheduling, rich formatting | Simple forms outperform complex ones on mobile (Assumption 11). WordPress's block editor is universally criticized for mobile complexity. |
| Image handling | Compress client-side → upload → show progress | Direct upload without compression | Image handling is #1 friction point in mobile creation (Assumption 7). Medium has broken image bugs. |
| State management | Cubit (not full BLoC) for create feature | BLoC with events | Create Article flow is form-driven, not event-driven. Cubit is simpler for form state. |
| Navigation to create | FAB on home screen | Bottom nav tab, drawer menu | Assignment specifies FAB; Material Design standard for primary creation action. |
| Validation style | Inline, real-time, field-level | Submit-then-validate | Inline validation yields 25% higher completion rates (Material Design guidelines). |
| Error messages | Plain language + recovery action | Technical error codes | "Your cover photo couldn't be uploaded. Check your connection." > "Storage Error 403" |
| AI framing | "Perspective Context" — tone/political leaning/emphasis/source analysis | Binary "fact-check" (true/false) | 42% trust stories *less* after AI disclosure (transparency paradox). Framing as context/perspective avoids truth-arbiter backlash (see Grok's 54.5% agreement rate). Political leaning per-article satisfies user demand: "Say where the information is from and the political view of the author" — Reuters DNR 2025. Data: Reuters DNR 2025, WEF 2024, Trusting News 2025. |
| AI model | Gemini 2.0 Flash (free tier, 15 RPM) | GPT-4, Claude | Free tier for assignment scope; structured JSON output; sufficient quality for summarization. |
| AI caching | Firestore `ai_insights` collection | No caching / in-memory | Identical articles produce identical insights; caching avoids redundant API calls and stays within free tier limits. |
| AI trigger | Lazy (user taps button) | Automatic on article open | Respects user agency; avoids unnecessary API calls; keeps loading time zero for users who don't want AI. |

---

## Appendices

- [ASSIGNMENT_REQUIREMENTS.md](./ASSIGNMENT_REQUIREMENTS.md) — Full assignment deliverables breakdown
- [USER_RESEARCH.md](./USER_RESEARCH.md) — JTBD, personas, competitive analysis, assumptions, priority matrix
- [FEATURE_TRACKING.md](./FEATURE_TRACKING.md) — 127-item feature tracker
- [APP_ARCHITECTURE.md](./APP_ARCHITECTURE.md) — Symmetry's architecture spec
- [ARCHITECTURE_VIOLATIONS.md](./ARCHITECTURE_VIOLATIONS.md) — 50 violations to avoid
- [CODING_GUIDELINES.md](./CODING_GUIDELINES.md) — 6 coding rules
