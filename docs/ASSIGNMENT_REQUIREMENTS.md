# Assignment Requirements Analysis

## Overview

This repository is a **job application assignment for Symmetry Club OU**. The applicant takes on the role of a "journalist" who wants to **upload their own articles** to an existing News App built with Flutter and Clean Architecture. The starter project provides a fully functional news-reading app that fetches articles from the NewsAPI. The assignment is to extend it with a full "Create/Upload Article" feature backed by Firebase.

---

## Context

The starter project already provides:

- A Flutter app using **Clean Architecture** (3-layer: data, domain, presentation)
- **BLoC** state management with `flutter_bloc`
- **Dependency injection** via `get_it`
- **NewsAPI integration** via Retrofit + Dio for fetching remote articles
- **Local persistence** via Floor (SQLite ORM) for saved articles
- A home page listing articles, an article detail page, and a saved articles page
- A `FloatingActionButton` on the home page with a TODO comment marking where the "Add Article" navigation should go

The applicant must build on this foundation without breaking the existing architecture.

---

## Deliverables

### 1. Backend (Firebase)

#### 1.1 Schema Design
- Design a **NoSQL schema** for articles stored in **Firebase Firestore**
- Must include a `thumbnailURL` field referencing images stored in **Firebase Cloud Storage** at path `media/articles/`
- Document the schema in `backend/docs/DB_SCHEMA.md`

#### 1.2 Schema Implementation
- Create the Firestore **collections, subcollections, fields, and documents** according to the designed schema

#### 1.3 Schema Enforcement
- Write **Firestore security rules** in `backend/firestore.rules`
- Write **Cloud Storage security rules** in `backend/storage.rules`
- Rules should enforce the schema and protect data integrity

### 2. Frontend (Flutter)

#### 2.0 Firebase Setup
- Connect the Flutter frontend to the Firebase backend using **FlutterFire CLI**
- Generate `firebase_options.dart`
- Call `Firebase.initializeApp()` in `main.dart`

#### 2.1 Business/Domain Layer
- Implement the **domain layer** for the "upload article" feature
- Create new entities, use cases, and abstract repository definitions
- Start with **mock data** in use cases before connecting to real Firebase data
- Follow the existing Clean Architecture pattern exactly

#### 2.2 Presentation Layer
- Implement **BLoC/Cubit** state management for the new feature
- Build the **UI** from the provided Figma prototype (link in main README)
- The `FloatingActionButton` on the home page should navigate to an **"Add Article" page**
- The page should include form fields for article creation (title, content, description, image)
- Handle loading, success, and error states in the UI

#### 2.3 Data Layer
- Create **data sources** for Firebase Firestore and Cloud Storage
- Implement models with proper serialization (Firestore JSON)
- Implement the **repository** to replace mock data with real Firebase operations

### 3. Report

- Write a comprehensive report in `docs/REPORT.md`
- Must follow the template in `docs/REPORT_INSTRUCTIONS.md`
- Sections: introduction, learning journey, challenges, reflection, proof (screenshots/videos), overdelivery, extras

### 4. Overdelivery (Encouraged)

The assignment explicitly encourages going beyond the minimum:
- Add more functionality
- Create new prototypes
- Suggest improvements
- Recommend technologies
- Repeat the backend-frontend-report cycle for any new features

---

## Architecture Constraints

All code must follow the documented architecture rules:

1. **Clean Architecture** - 3 layers with strict dependency rules (Presentation -> Domain <- Data)
2. **Domain layer has zero framework imports** - Pure Dart only
3. **Data layer models** must extend domain entities and implement `fromRawData()` and `toEntity()`
4. **Presentation layer** uses BLoC/Cubit exclusively for state management
5. **Single responsibility** for all use cases (one public method: `call()`)
6. **Dependency injection** via GetIt for all cross-layer dependencies
7. **50 specific architecture violations to avoid** (listed in `ARCHITECTURE_VIOLATIONS.md`)

---

## Coding Guidelines

From `docs/CODING_GUIDELINES.md`:

1. **Boy Scout Rule** - Leave the code cleaner than you found it
2. **Meaningful names** - Descriptive variable, function, and class names
3. **Small functions** - Each function does one thing
4. **TDD** - Test-Driven Development is expected
5. **Small classes** - Single Responsibility Principle
6. **Abstract classes** - Use for isolation between layers

---

## Evaluation Criteria

From the README, Symmetry values:
- **Independence & Ownership** - Self-learning, problem-solving without hand-holding
- **Code Quality** - Clean, maintainable, well-architected code
- **Communication** - Clear documentation and reporting
- **Overdelivery** - Going above and beyond the minimum requirements

---

## Resources Provided

- `docs/APP_ARCHITECTURE.md` - Full architecture specification
- `docs/ARCHITECTURE_VIOLATIONS.md` - 50 violations to avoid
- `docs/CODING_GUIDELINES.md` - Coding standards
- `docs/REPORT_INSTRUCTIONS.md` - Report template
- `docs/clean-code-book.pdf` - Clean Code reference book
- Figma prototype link (in main README)
- YouTube tutorial link for Clean Architecture in Flutter (in main README)
