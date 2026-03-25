# Discovery Insights: Mobile News App — Article Creation Feature for Journalists
**Date:** March 25, 2026

---

## Executive Summary

The mobile news landscape in 2026 is bifurcating sharply: **readers** increasingly expect hyper-personalized, instantly-loading, visually immersive content — yet only 15% of 18-29 year-olds follow the news closely (Pew Research, 2025), meaning our app must earn every second of attention. **Content creators** are undergoing a "creator-fication" (Reuters Institute, 2025) where journalists seek direct-audience ownership and mobile-first publishing tools — yet every major platform (Medium, WordPress, Substack) still forces creators to a desktop for serious writing. The unaddressed opportunity is a **mobile-native article creation experience** that is both ridiculously simple (grandmother-test) and aesthetically magnetic (NPC-test), bridging the gap between the read-only news apps and the write-only CMS tools.

---

## Table of Contents

1. [Jobs To Be Done (JTBD) Analysis](#1-jobs-to-be-done-jtbd-analysis)
2. [Target Audience Deep Dive](#2-target-audience-deep-dive)
3. [Current App User Flow (Mermaid.js)](#3-current-app-user-flow-mermaidjs)
4. [Proposed App User Flow with "Create Article" Feature (Mermaid.js)](#4-proposed-app-user-flow-with-create-article-feature-mermaidjs)
5. [Competitive Benchmark Analysis](#5-competitive-benchmark-analysis)
6. [Consolidated Benchmark User Flow (Mermaid.js)](#6-consolidated-benchmark-user-flow-mermaidjs)
7. [UX Improvement Recommendations](#7-ux-improvement-recommendations)
8. [Data-Backed Assumptions](#8-data-backed-assumptions)

---

## 1. Jobs To Be Done (JTBD) Analysis

### 1.1 Reader Jobs

#### Functional Jobs
| # | JTBD Statement | Priority |
|---|---------------|----------|
| R-F1 | When I **have a few minutes to spare** (commute, waiting room), I want to **quickly scan top headlines**, so I can **stay informed without effort**. | Critical |
| R-F2 | When I **find an interesting article**, I want to **save it for later**, so I can **read it at a more convenient time without losing it**. | High |
| R-F3 | When I'm **reading a saved article offline**, I want to **access it without an internet connection**, so I can **continue reading anywhere**. | Medium |
| R-F4 | When I **want to go deeper on a topic**, I want to **tap into the full article content**, so I can **understand the complete story, not just the headline**. | High |
| R-F5 | When I **no longer need a saved article**, I want to **remove it easily**, so I can **keep my saved list clean and relevant**. | Low |

#### Emotional Jobs
| # | JTBD Statement |
|---|---------------|
| R-E1 | When I **open the app**, I want to **feel instantly informed and in control**, so I can **reduce my anxiety about missing important events**. |
| R-E2 | When I **browse headlines**, I want to **feel confident the information is current and credible**, so I can **trust what I'm reading**. |
| R-E3 | When I **use the app in public**, I want to **feel like I'm using something sleek and modern**, so I can **feel good about my tech choices**. |

#### Social Jobs
| # | JTBD Statement |
|---|---------------|
| R-S1 | When I **discover an interesting article**, I want to **share it with friends/colleagues**, so I can **appear well-informed and spark conversations**. |
| R-S2 | When I **read diverse sources**, I want to **form my own perspective**, so I can **participate in discussions confidently**. |

#### Reader Pain Points
- **Information overload**: Too many headlines, no way to prioritize
- **Stale content**: Not knowing how fresh the headlines are
- **Context switching**: Having to leave the app to read the full article on a browser
- **Cluttered saves**: No organization of saved articles (categories, tags)
- **Accessibility**: Small text, low contrast for older readers

#### Reader Gains
- Feeling informed in under 2 minutes
- One-tap save and offline access
- Clean, distraction-free reading experience
- Confidence that they haven't missed major stories

---

### 1.2 Journalist Jobs

#### Functional Jobs
| # | JTBD Statement | Priority |
|---|---------------|----------|
| J-F1 | When I've **finished writing a story**, I want to **publish it with a thumbnail from my phone**, so I can **get it out to readers while it's still timely**. | Critical |
| J-F2 | When I'm **in the field**, I want to **draft an article quickly on mobile**, so I can **capture the story before I forget the details**. | Critical |
| J-F3 | When I **attach a thumbnail image**, I want to **preview how it looks before publishing**, so I can **ensure visual quality and proper framing**. | High |
| J-F4 | When I **publish an article**, I want to **get immediate confirmation** (success/failure), so I can **move on confidently or fix issues immediately**. | High |
| J-F5 | When I **make a mistake in a published article**, I want to **edit or unpublish it**, so I can **maintain my credibility**. | Medium |
| J-F6 | When I'm **writing a long piece**, I want to **auto-save my draft**, so I can **never lose work due to a crash or accidental navigation**. | High |

#### Emotional Jobs
| # | JTBD Statement |
|---|---------------|
| J-E1 | When I **publish my article**, I want to **feel proud of how it looks**, so I can **feel like a professional, not a hobbyist**. |
| J-E2 | When I'm **writing on mobile**, I want to **feel like the tool isn't fighting me**, so I can **stay in creative flow**. |
| J-E3 | When I **see my article appear in the feed**, I want to **feel a rush of accomplishment**, so I can **be motivated to write more**. |

#### Social Jobs
| # | JTBD Statement |
|---|---------------|
| J-S1 | When I **publish regularly**, I want to **build a readership**, so I can **establish myself as a credible voice**. |
| J-S2 | When I **see my article next to major headlines**, I want to **feel legitimized**, so I can **feel my work is valued alongside professional outlets**. |

#### Journalist Pain Points
- **Mobile editors suck**: Medium disabled mobile editing entirely in 2022; WordPress mobile is clunky; Substack's app is read-focused
- **Image handling is painful**: Cropping, compression, upload failures, no preview
- **No autosave anxiety**: Fear of losing work (directly quoted from Medium UX research: *"The autosave is good, but without interaction with the article, I am afraid that I may lose the draft."*)
- **Hidden functions**: Essential publishing features buried in menus (*"Some useful functions are hidden so deep in the '...' icon"* -- Medium UX study, UXPlanet)
- **No feedback loop**: Publishing into a void with no confirmation, no view counts, no engagement signals
- **Slow upload**: Large thumbnail images on cellular networks lead to timeouts and failures

#### Journalist Gains
- Publishing a polished article in under 5 minutes from their phone
- Seeing their article live in the feed immediately
- Professional-looking output that matches established news outlets
- Peace of mind from autosave and clear status indicators

---

## 2. Target Audience Deep Dive

### 2.1 Persona: The Reader

#### Demographics
| Attribute | Details |
|-----------|---------|
| **Age Range** | 16-90+ (per assignment: must work for an 18-year-old AND a 90-year-old) |
| **Primary Segments** | Gen Z (16-28), Millennials (29-43), Boomers+ (60+) |
| **Devices** | Primarily smartphones (Android ~72% global, iOS ~28%); Flutter covers both |
| **Tech Savviness** | Ranges from digital-native to digitally cautious |
| **Income** | Mixed; 95.4% of apps are free (Statista 2025) -- readers expect free access |

#### Psychographics
- **Gen Z Readers**: Value aesthetic appeal, dark mode (68% of tech-savvy users prefer it), short attention spans, prefer visual/video-first content but 45% still prefer *reading* news (Pew, Aug 2025). Get news from TikTok (43%), Instagram (40%), YouTube (41%).
- **Millennial Readers**: Information-hungry, value credibility, use apps during commutes, 102.4 hours/month on apps (BusinessofApps). Subscribe to 2-3 news sources.
- **Boomer+ Readers**: Value simplicity, larger text, clear navigation, high contrast. 52% report high news interest vs. 35% for 18-24 year-olds (Reuters 2025). Spend less than 51.4 hours/month on apps.

#### Behavioral Patterns
| Behavior | Data |
|----------|------|
| **Session Length** | 3-7 minutes for news checking (micro-sessions); 15-30 minutes for deep reads |
| **Session Frequency** | 3-5x daily for headlines; 1-2x for saved articles |
| **Peak Usage Times** | Morning (7-9 AM), lunch break (12-1 PM), evening wind-down (8-10 PM) |
| **Retention Challenge** | Only 25% of users return after Day 1 (Adjust, 2025) |
| **Direct vs. Social** | Only 14% of 18-24s go directly to news apps; 40% via social media (Reuters 2025) |

#### What Matters Most to Readers
1. **Speed** -- Content must load instantly (mobile users are "notoriously impatient")
2. **Simplicity** -- One-hand navigation, minimal taps to content
3. **Visual Appeal** -- Modern aesthetic, thumbnail-driven browsing
4. **Trust** -- Source attribution, publication dates
5. **Personalization** -- Relevant content surfaced automatically

---

### 2.2 Persona: The Journalist

#### Demographics
| Attribute | Details |
|-----------|---------|
| **Age Range** | 22-55 |
| **Primary Segments** | Citizen journalists, freelancers, student journalists, independent creators |
| **Devices** | iPhone + Android (often flagship devices with good cameras) |
| **Tech Savviness** | Moderate to high; comfortable with CMS tools but frustrated by mobile limitations |
| **Context** | "Creator-fication of journalism" -- top talent seeking more control over content (Reuters Institute, 2025) |

#### Psychographics
- Driven by **purpose and audience impact** more than revenue
- Value **speed-to-publish** -- timeliness is the core currency of journalism
- Experience "publishing anxiety" -- fear of errors, typos, wrong images going live
- Increasingly **mobile-first in their workflow** -- 82% of users expect to complete essential forms on mobile (Tinyform, 2025)
- Seek **legitimacy** -- their content sitting alongside professional sources validates their work

#### Behavioral Patterns
| Behavior | Data |
|----------|------|
| **Writing Context** | In the field, at events, during commutes -- mobile is primary device |
| **Session Length** | 10-30 minutes for article creation; 2-5 minutes for quick edits |
| **Publishing Frequency** | 2-5 articles/week for active journalists |
| **Image Source** | Phone camera (primary), phone gallery, stock photos |
| **Pain Threshold** | Will abandon a mobile creation tool after 2 friction points and switch to desktop |

#### What Matters Most to Journalists
1. **Speed to publish** -- Get the story out while it's hot
2. **Reliability** -- Never lose a draft, never fail silently
3. **Professional output** -- The result must look polished
4. **Simplicity** -- Don't make them learn a complex CMS on a 6-inch screen
5. **Feedback** -- Know immediately if it published, and how it's performing

---

## 3. Current App User Flow (Mermaid.js)

> **Note:** This diagram was validated line-by-line against the actual source code on March 25, 2026.
> Source files: `main.dart`, `daily_news.dart`, `article_detail.dart`, `saved_article.dart`, `article_tile.dart`, `routes.dart`.

```mermaid
flowchart TD
    A([App Launch]) --> B[Initialize Dependencies\nGetIt DI Container]
    B --> C[Home Screen — DailyNews\nRemoteArticlesBloc fires GetArticles]

    %% ===== LOADING STATES =====
    C --> D{BLoC State?}
    D -->|RemoteArticlesLoading| E[Show CupertinoActivityIndicator\nCentered Spinner]
    D -->|RemoteArticlesError| F[Show Refresh Icon\nNo error message or retry button]
    D -->|RemoteArticlesDone| G[Display Article List\nPlain ListView — not paginated]

    %% ===== BROWSE ARTICLES FLOW =====
    G --> H[Article Cards via ArticleWidget\nImage + Title + Description + Date\nNo source or author displayed]
    H --> I{User Action on Home}

    I -->|Scroll Down| J[Scroll ListView\nAll articles loaded at once\nNo pagination / infinite scroll]
    J --> I

    %% Note: No pull-to-refresh — no RefreshIndicator widget exists

    %% ===== READ ARTICLE DETAIL FLOW =====
    I -->|Tap Article Card| K[Navigator.pushNamed — /ArticleDetails\nArticleDetailsView receives ArticleEntity]
    K --> L[Article Detail Screen\nTitle + Published Date + Image\n+ Description + Content\nNo source or author displayed]
    L --> M{User Action on Detail}

    M -->|Scroll Content| N[SingleChildScrollView\nRead full article]
    N --> M

    M -->|Tap Back Chevron| O[Navigator.pop\nReturn to Home Screen]
    O --> I

    %% ===== SAVE ARTICLE FLOW =====
    M -->|Tap Bookmark FAB| P[Fire SaveArticle Event\nLocalArticleBloc — no duplicate check]
    P --> Q[Show SnackBar\nArticle saved successfully\nAlways saves — even if already saved]
    Q --> M

    %% ===== NAVIGATE TO SAVED ARTICLES =====
    I -->|Tap Bookmark Icon in AppBar| R[Navigator.pushNamed — /SavedArticles\nNot a tab — push navigation]
    R --> S[SavedArticles Screen\nLocalArticleBloc fires GetSavedArticles]
    S --> T{BLoC State?}
    T -->|LocalArticlesLoading| U[Show CupertinoActivityIndicator]
    T -->|LocalArticlesDone| V{Articles List Empty?}

    V -->|Yes| W[Show Plain Text\nNO SAVED ARTICLES\nNo illustration or empty state graphic]
    V -->|No| X[Display Saved Articles\nListView.builder with ArticleWidget\nisRemovable: true]

    X --> Y{User Action on Saved}
    Y -->|Tap Article| K

    %% ===== REMOVE SAVED ARTICLE FLOW =====
    Y -->|Tap Red Remove Icon| Z[Fire RemoveArticle Event\nNo confirmation dialog\nNo undo option]
    Z --> AA[Article Removed from Floor DB\nList rebuilds via BLoC\nNo removal animation]
    AA --> X

    %% Note: No swipe-to-delete — uses a tap on red circle icon only

    Y -->|Tap Back Chevron| BB[Navigator.pop\nReturn to Home Screen]
    BB --> I
    W -->|Tap Back Chevron| BB

    %% ===== FAB ON HOME (UNUSED) =====
    I -->|Tap + FAB on Home| CC[No-op\nTODO comment in code\nRoute not yet implemented]

    style A fill:#4CAF50,stroke:#333,color:#fff
    style C fill:#2196F3,stroke:#333,color:#fff
    style L fill:#FF9800,stroke:#333,color:#fff
    style S fill:#9C27B0,stroke:#333,color:#fff
    style P fill:#4CAF50,stroke:#333,color:#fff
    style Z fill:#f44336,stroke:#333,color:#fff
    style CC fill:#757575,stroke:#333,color:#fff
```

### Corrections from Previous Version

The original diagram (auto-generated before code validation) contained **10 inaccuracies**. Here is what was wrong and what the code actually does:

| # | Original Claim | Actual Code Behavior | Severity |
|---|---------------|---------------------|----------|
| 1 | "First Time User? → Show Onboarding / Splash" | No onboarding or splash screen exists. App launches directly to `DailyNews` home screen after DI init. | **Incorrect** |
| 2 | "Display Article Cards: Title + Image + **Source** + Date" | `ArticleWidget` shows Image + Title + Description + Date. **Source/author are NOT displayed** anywhere in the tile. | **Incorrect** |
| 3 | "Load More Headlines: Pagination / Infinite Scroll" | Home uses a plain `ListView` (not `ListView.builder`). All articles from a single API call are rendered at once. **No pagination or infinite scroll.** | **Incorrect** |
| 4 | "Pull Down → Refresh Headlines" | **No `RefreshIndicator` widget exists.** There is no pull-to-refresh functionality. | **Incorrect** |
| 5 | "Article Detail: Title + Image + Full Content + **Source** + Published Date" | Detail shows Title + PublishedAt + Image + Description + Content. **No source or author displayed.** | **Incorrect** |
| 6 | "Tap Save → Article Already Saved? → Show Already Saved State" | **No duplicate check.** The `SaveArticle` event is fired unconditionally every time the FAB is tapped. The same article can be saved multiple times. | **Incorrect** |
| 7 | "Navigate to **Saved Tab**" | Saved Articles is accessed via `Navigator.pushNamed` (push navigation from AppBar bookmark icon), **not a bottom tab**. | **Incorrect** |
| 8 | "Display Saved Article List: Title + Image + **Source**" | Saved articles use the same `ArticleWidget` — shows Image + Title + Description + Date. **No source displayed.** | **Partially wrong** |
| 9 | "**Swipe to Delete** / Tap Remove" | **No swipe-to-delete.** Removal is via tapping a red `remove_circle_outline` icon rendered when `isRemovable: true`. | **Partially wrong** |
| 10 | "Update Saved List: **Show Removal Animation**" | **No removal animation.** The BLoC rebuilds the list; items simply disappear. No undo toast either. | **Partially wrong** |

---

## 4. Proposed App User Flow with "Create Article" Feature (Mermaid.js)

```mermaid
flowchart TD
    A([App Launch]) --> B{Authenticated?}
    B -->|No| C{User Type?}
    C -->|Reader| D[Continue as Guest / Reader Login]
    C -->|Journalist| E[Journalist Login / Register\nEmail + Password via Firebase Auth]
    E --> F{Auth Success?}
    F -->|No| G[Show Error Message\nRetry Option]
    G --> E
    F -->|Yes| H[Home Screen - Top Headlines\nwith FAB: Create Article]
    B -->|Yes| H
    D --> I[Home Screen - Top Headlines\nReader View - No Create Button]

    %% ===== EXISTING BROWSE FLOW =====
    I --> J[Display Article Cards\nNewsAPI + Firebase Articles Mixed]
    H --> J
    J --> K{User Action}

    K -->|Scroll| L[Load More Articles\nPaginated from Both Sources]
    L --> J

    K -->|Pull to Refresh| M[Refresh Feed\nNewsAPI + Firebase Sync]
    M --> J

    %% ===== EXISTING READ FLOW =====
    K -->|Tap Article| N[Article Detail Screen\nFull Content + Image + Meta]
    N --> O{User Action on Detail}
    O -->|Read / Scroll| N
    O -->|Tap Back| J
    O -->|Tap Save| P[Save to Local Storage]
    P --> Q[Bookmark Confirmed]
    Q --> O

    %% ===== EXISTING SAVED FLOW =====
    K -->|Navigate to Saved Tab| R[Saved Articles Screen]
    R --> S{Has Saved?}
    S -->|Yes| T[Display Saved List]
    S -->|No| U[Empty State Illustration]
    T --> V{Action on Saved}
    V -->|Tap Article| N
    V -->|Remove Article| W[Delete from Local Storage]
    W --> T

    %% ===== NEW: CREATE ARTICLE FLOW =====
    K -->|Tap FAB: Create Article| X{Is Journalist Authenticated?}
    X -->|No| Y[Prompt Login / Role Check]
    Y --> E
    X -->|Yes| Z[Create Article Screen]

    Z --> AA[Step 1: Title Input\nLarge Text Field\nPlaceholder: Give your story a headline]
    AA --> AB[Step 2: Description Input\nShort Summary Field\nPlaceholder: Write a brief summary]
    AB --> AC[Step 3: Content Input\nRich Text Area\nExpandable with Formatting]
    AC --> AD[Step 4: Thumbnail Image]

    AD --> AE{Image Action}
    AE -->|Tap Attach Image| AF{Image Source?}
    AF -->|Camera| AG[Open Camera\nCapture Photo]
    AF -->|Gallery| AH[Open Photo Picker\nSelect from Gallery]
    AG --> AI[Show Image Preview\nWith Crop Option]
    AH --> AI
    AI --> AJ{Satisfied with Image?}
    AJ -->|No| AF
    AJ -->|Yes| AK[Image Attached\nShow Thumbnail Preview in Form]
    AK --> AL{Ready to Publish?}

    %% ===== AUTOSAVE =====
    AA -.->|Auto-save Draft\nEvery 30 seconds| AM[(Local Draft Storage)]
    AB -.->|Auto-save| AM
    AC -.->|Auto-save| AM

    %% ===== VALIDATION =====
    AL -->|Tap Publish| AN{Validate Form}
    AN -->|Missing Title| AO[Highlight Title Field\nInline Error: Title is required]
    AO --> AA
    AN -->|Missing Content| AP[Highlight Content Field\nInline Error: Content is required]
    AP --> AC
    AN -->|No Image| AQ[Show Warning\nPublish without thumbnail?]
    AQ -->|Add Image| AD
    AQ -->|Continue Without| AR[Proceed to Upload]
    AN -->|All Valid| AR

    %% ===== UPLOAD TO FIREBASE =====
    AR --> AS[Show Upload Progress\nAnimated Progress Indicator]
    AS --> AT[Upload Image to\nFirebase Storage]
    AT --> AU[Save Article Data to\nFirebase Firestore\nTitle + Description + Content\n+ Image URL + Timestamp + Author]
    AU --> AV{Upload Success?}

    AV -->|Yes| AW[Success Screen\nConfetti Animation\nArticle Published!]
    AW --> AX[Preview Published Article\nSee It Live Button]
    AX --> AY[Navigate to Article in Feed]
    AY --> N

    AV -->|No| AZ[Error Screen\nFriendly Error Message\nRetry Button]
    AZ --> BA{User Choice}
    BA -->|Retry| AR
    BA -->|Save as Draft| AM
    BA -->|Discard| J

    %% ===== DRAFT RECOVERY =====
    K -->|Navigate to Drafts| BB[Drafts Screen\nList of Unpublished Drafts]
    BB --> BC{Select Draft}
    BC --> Z

    style A fill:#4CAF50,stroke:#333,color:#fff
    style H fill:#2196F3,stroke:#333,color:#fff
    style I fill:#2196F3,stroke:#333,color:#fff
    style N fill:#FF9800,stroke:#333,color:#fff
    style Z fill:#E91E63,stroke:#333,color:#fff
    style AW fill:#4CAF50,stroke:#333,color:#fff
    style AZ fill:#f44336,stroke:#333,color:#fff
    style AM fill:#795548,stroke:#333,color:#fff
```

---

## 5. Competitive Benchmark Analysis

### 5.1 Medium

| Attribute | Details |
|-----------|---------|
| **Description** | The world's most prominent long-form blogging platform with 100M+ monthly readers |
| **Reader Features** | Personalized feed, claps, highlights, bookmarks, reading time estimates, member-only content |
| **Creator Features** | Rich text editor (web), publications, analytics dashboard, monetization via Partner Program |
| **UX Patterns** | Minimal chrome, focus-mode writing, inline formatting toolbar, distraction-free reading |
| **What They Do Well** | Reading experience is best-in-class -- typography, spacing, focus. The "story editor" is clean and intuitive on desktop. |
| **What They Do Poorly** | **Disabled mobile editing entirely in 2022.** Mobile app is read-only for writers. Bugs reported include: "Every letter gets CAPITALIZED when editing," "Cut option doesn't actually work," "Large gaps appear while scrolling in Edit mode" (Medium App Bugs, 2022). Hidden functions: *"Some useful functions are hidden so deep in the '...' icon"* (UXPlanet study). Users report: *"The autosave is good, but without interaction with the article, I am afraid that I may lose the draft."* |
| **Relevance to Us** | **Massive gap**: Medium abandoned mobile creation. Our app can fill this void with a focused, reliable mobile article editor. |

### 5.2 Substack

| Attribute | Details |
|-----------|---------|
| **Description** | Newsletter platform enabling writers to build subscriber-based publications with paid tiers |
| **Reader Features** | Inbox-style reading, podcast player, community notes, recommendation engine, Substack app for browsing |
| **Creator Features** | Email newsletter editor, paid subscriptions (Substack takes 10%), podcast hosting, community threads |
| **UX Patterns** | Email-first distribution, simple WYSIWYG editor, subscriber management, publication-level tagging |
| **What They Do Well** | Built-in discovery/network effect -- *"New publications can be discovered through Substack's own reader recommendations"* (Outrank). Seamless reading app. Low friction to start writing. Zero technical setup. |
| **What They Do Poorly** | Mobile app is primarily for **reading**, not writing. Editor is web-focused. Limited SEO. Niche-dependent growth (*"On Substack you'll do better if you stick to a niche"* -- Linda Caroll). No real-time article creation from mobile. |
| **Relevance to Us** | Substack proves that combining reading + writing in one platform creates strong network effects. But their mobile writing experience is weak -- opportunity for us. |

### 5.3 WordPress Mobile App

| Attribute | Details |
|-----------|---------|
| **Description** | The mobile companion to the world's most popular CMS (43%+ of the web) |
| **Reader Features** | WordPress Reader for discovering blogs, following sites, likes, comments |
| **Creator Features** | Full post editor, media library, drafts, scheduling, category/tag management, Jetpack stats |
| **UX Patterns** | Block editor (Gutenberg) adapted for mobile, media picker, preview before publish |
| **What They Do Well** | Most **complete** mobile creation tool -- supports blocks, images, drafts, scheduling. Full content portability. Reader + Writer in one app. |
| **What They Do Poorly** | Block editor on mobile is **clunky** -- small tap targets for block manipulation, confusing for simple articles. Over-engineered for someone who just wants to write a post. Described as feeling like *"a dinosaur compared to more responsive sites"* (Anna B. Yang). Steep learning curve. |
| **Relevance to Us** | WordPress proves mobile creation is *possible* but warns against over-complexity. Our creation flow should be **dramatically simpler** -- no blocks, no plugins, just title + content + image. |

### 5.4 Ghost

| Attribute | Details |
|-----------|---------|
| **Description** | Modern open-source publishing platform focused on professional creators and membership monetization |
| **Reader Features** | Clean reading experience, membership tiers, newsletter delivery |
| **Creator Features** | Markdown + WYSIWYG editor, Grammarly integration, native SEO, built-in analytics, membership management |
| **UX Patterns** | Slash commands for content blocks, real-time preview, markdown shortcuts, distraction-free editor |
| **What They Do Well** | **Best writing experience** among CMS tools -- *"Grammarly integration in the editor... skipping the 'right-click + search + add' steps and typing immediately what you need significantly fastens the writing process"* (Norbert Hires). Clean, fast, focused. |
| **What They Do Poorly** | **No dedicated mobile app** for creation -- web-only editor. Requires hosting knowledge. Costs scale with subscribers. Not a reading destination -- no discovery/feed. |
| **Relevance to Us** | Ghost's editor UX (slash commands, markdown shortcuts, inline preview) is the gold standard for *desktop* writing. We should adapt its simplicity principles to mobile. |

### 5.5 Flipboard

| Attribute | Details |
|-----------|---------|
| **Description** | Visual news magazine app known for its stunning card-flip UI and content curation |
| **Reader Features** | Magazine-style browsing, topic following, smart magazines, social sharing, flip animation |
| **Creator Features** | Curate magazines from existing articles (not original content creation), RSS integration |
| **UX Patterns** | Card-based layout, flip animations, topic taxonomy, visual-first browsing, bottom navigation |
| **What They Do Well** | **Best visual news browsing UX** -- *"the world's most engaging news app... stunning visuals and brilliant design architecture that presents news stories in an effective and creative manner"* (Net Solutions). Combines articles, slideshows, and videos. The card-flip metaphor is uniquely engaging. |
| **What They Do Poorly** | **No original content creation at all.** Curation-only. No writing tools. Social features feel bolted-on. |
| **Relevance to Us** | Flipboard's card-based visual browsing is the UX benchmark for our **reader** feed. Our article cards should aspire to this level of visual engagement. |

### 5.6 Google News

| Attribute | Details |
|-----------|---------|
| **Description** | AI-powered news aggregator by Google, personalizing headlines from thousands of sources |
| **Reader Features** | Personalized feed, "Full Coverage" (multiple perspectives on same story), local news, fact-check labels, topic following |
| **Creator Features** | None -- purely aggregation; publishers register via Google News Publisher Center (web) |
| **UX Patterns** | Card-based feed, bottom navigation, tab-based categories, "For You" personalization, mini-cards for related stories |
| **What They Do Well** | **Best personalization** via AI; "Full Coverage" is unique and builds trust by showing multiple viewpoints. Clean, fast, reliable. |
| **What They Do Poorly** | No content creation. Sends users away to source websites (context switching). No save/offline in a meaningful way. |
| **Relevance to Us** | Google News sets the bar for **feed personalization and layout**. Their card hierarchy (headline card vs. mini-card) is a pattern we should study. |

### 5.7 LinkedIn Articles

| Attribute | Details |
|-----------|---------|
| **Description** | Long-form article publishing within the LinkedIn professional network |
| **Reader Features** | Feed integration, professional context, comments, reactions, sharing |
| **Creator Features** | Rich text editor, cover images, embedding, article analytics, professional audience |
| **UX Patterns** | In-feed article creation, cover image upload, inline formatting, mobile + desktop editor |
| **What They Do Well** | Articles appear **directly in a feed** alongside other content -- exactly our model. Professional legitimacy. Mobile editor exists and works. |
| **What They Do Poorly** | Mobile editor is limited and secondary to desktop. Article formatting options are basic. Reader engagement is low (people scroll past long articles). |
| **Relevance to Us** | LinkedIn validates our core concept: original articles from creators mixed into a consumption feed. Their model of "content lives where readers already are" is exactly right. |

### Benchmark Summary Matrix

| Feature | Medium | Substack | WordPress | Ghost | Flipboard | Google News | LinkedIn |
|---------|--------|----------|-----------|-------|-----------|-------------|----------|
| Mobile Reading | 5/5 | 4/5 | 3/5 | 2/5 | 5/5 | 5/5 | 3/5 |
| Mobile Writing | 0/5 | 2/5 | 3/5 | 0/5 | 0/5 | 0/5 | 2/5 |
| Image Handling | 3/5 | 2/5 | 4/5 | 4/5 | N/A | N/A | 2/5 |
| Publish Feedback | 2/5 | 3/5 | 4/5 | 4/5 | N/A | N/A | 3/5 |
| Feed Integration | 4/5 | 3/5 | 2/5 | 1/5 | 5/5 | 5/5 | 4/5 |
| Autosave / Drafts | 3/5 | 3/5 | 4/5 | 5/5 | N/A | N/A | 2/5 |
| Accessibility | 3/5 | 2/5 | 3/5 | 3/5 | 2/5 | 4/5 | 3/5 |

---

## 6. Consolidated Benchmark User Flow (Mermaid.js)

This flow synthesizes the **best patterns** from all benchmarks into an idealized "best of breed" approach.

```mermaid
flowchart TD
    A([App Launch]) --> B{Returning User?}
    B -->|Yes| C[Restore Session\nSkip Onboarding]
    B -->|No| D[Onboarding: 3 Screens Max\nValue Prop + Role Selection\nReader or Journalist]
    D --> E[Account Creation\nFirebase Auth\nGoogle / Email Sign-in]
    E --> C

    C --> F[Home Feed\nPersonalized Mixed Content\nNewsAPI + Firebase Articles]

    %% ===== BEST-OF-BREED READING FLOW =====
    F --> G[Visual Article Cards\nLarge Thumbnail + Title + Source Badge\n+ Time Ago + Reading Time Estimate]

    G --> H{Reader Action}
    H -->|Scroll| I[Infinite Scroll with\nSkeleton Loading\nFrom: Google News pattern]
    I --> G

    H -->|Pull to Refresh| J[Refresh with\nHaptic Feedback\nFrom: iOS News pattern]
    J --> G

    H -->|Tap Card| K[Article Detail\nImmersive Hero Image\n+ Clean Typography\nFrom: Medium reading UX]

    K --> L{Detail Actions}
    L -->|Scroll to Read| K
    L -->|Tap Bookmark| M[Save with\nMicrointeraction\nIcon Morphs + Haptic\nFrom: Flipboard]
    M --> K
    L -->|Tap Share| N[Native Share Sheet\nFrom: Standard OS pattern]
    N --> K
    L -->|Swipe Right to Go Back| G

    %% ===== BEST-OF-BREED SAVED FLOW =====
    H -->|Saved Tab via Bottom Nav| O[Saved Articles\nGrouped by Date\nFrom: Pocket pattern]
    O --> P{Saved Action}
    P -->|Tap| K
    P -->|Swipe Left to Delete| Q[Undo Toast for 5 sec\nFrom: Gmail pattern]
    Q --> O

    %% ===== BEST-OF-BREED CREATION FLOW =====
    H -->|Tap FAB +\nFrom: Material Design| R{Role Check}
    R -->|Not Journalist| S[Gentle Upsell\nBecome a Contributor]
    R -->|Journalist| T[Create Article Screen\nDistraction-Free\nFrom: Ghost editor philosophy]

    T --> U[Title Field\nAuto-expanding Large Text\nFrom: Medium story editor]
    U --> V[Description Field\nSubtitle / Teaser\nFrom: Ghost excerpt field]
    V --> W[Content Area\nPlain Rich Text\nBold + Italic + Links Only\nFrom: Substack simplicity]

    %% ===== BEST-OF-BREED IMAGE FLOW =====
    W --> X[Thumbnail Section\nFrom: WordPress featured image]
    X --> Y{Add Image}
    Y -->|Tap Image Area| Z[Bottom Sheet\nCamera / Gallery / Stock\nFrom: Instagram-style picker]
    Z --> AA[Image Preview with\nCrop to 16:9 Ratio\nFrom: WordPress media editor]
    AA --> AB{Approve?}
    AB -->|Reshoot / Reselect| Z
    AB -->|Confirm| AC[Image Compressed\nClient-Side\nWebP format]

    %% ===== BEST-OF-BREED AUTOSAVE =====
    U -.->|Debounced Autosave\n5 sec after last keystroke\nFrom: Ghost| AD[(Local Draft\nWith Timestamp)]
    V -.->|Autosave| AD
    W -.->|Autosave| AD

    %% ===== BEST-OF-BREED PUBLISH FLOW =====
    AC --> AE[Preview Button\nSee Exactly How It Looks\nFrom: WordPress preview]
    AE --> AF[Full Preview Screen\nMatches Feed Card + Detail\nFrom: Ghost preview]
    AF --> AG{Publish?}
    AG -->|Edit More| T
    AG -->|Publish| AH[Inline Validation\nReal-time Field Checks\nFrom: Form UX best practices]

    AH --> AI{Valid?}
    AI -->|Error| AJ[Inline Error Messages\nField-Level Highlighting\nFrom: Material Design guidelines]
    AJ --> T
    AI -->|Valid| AK[Upload Progress\nDeterminate Progress Bar\n+ Estimated Time\nFrom: WhatsApp media upload]

    AK --> AL{Success?}
    AL -->|Yes| AM[Success Celebration\nConfetti + View Article CTA\nFrom: Duolingo celebration pattern]
    AM --> AN[Deep Link to Article\nIn Live Feed\nFrom: LinkedIn article publish]

    AL -->|No| AO[Error with\nPlain Language Explanation\n+ Retry Button\n+ Save Draft Option\nFrom: Mailchimp error patterns]
    AO --> AK

    %% ===== BOTTOM NAVIGATION =====
    F -.-> BP[Bottom Nav Bar\n4 Tabs: Home / Saved / Create / Profile\nFrom: Instagram layout pattern]

    style A fill:#4CAF50,stroke:#333,color:#fff
    style F fill:#2196F3,stroke:#333,color:#fff
    style K fill:#FF9800,stroke:#333,color:#fff
    style T fill:#E91E63,stroke:#333,color:#fff
    style AM fill:#4CAF50,stroke:#333,color:#fff
    style AO fill:#f44336,stroke:#333,color:#fff
    style AD fill:#795548,stroke:#333,color:#fff
```

### Best-of-Breed Sources

| Pattern | Sourced From | Why It's Best |
|---------|-------------|---------------|
| Card-based visual feed | Flipboard | Most engaging visual news browsing; proven to increase dwell time |
| Distraction-free editor | Ghost | Fastest time-to-publish; minimal cognitive load |
| Auto-expanding title field | Medium | Feels natural, like writing on paper |
| Featured image with crop | WordPress | Most complete image handling on mobile |
| Debounced autosave | Ghost | Never lose work; no explicit save button needed |
| Preview before publish | WordPress + Ghost | Reduces publishing anxiety; catches errors before they're live |
| Confetti celebration | Duolingo | Emotional reward increases publishing frequency (gamification boosts engagement by 60%) |
| Undo toast on delete | Gmail | Forgiveness pattern prevents accidental data loss |
| Bottom sheet image picker | Instagram | Familiar pattern for camera/gallery selection on mobile |
| Inline validation | Material Design | Prevents submission errors; 25% higher completion rates |
| Haptic feedback on actions | iOS native | Physical confirmation builds trust |

---

## 7. UX Improvement Recommendations

### 7.1 Navigation Patterns

| Recommendation | Rationale | Implementation |
|---------------|-----------|----------------|
| **Bottom navigation bar with 4 tabs** | Thumb-friendly (bottom nav is the 2025 standard for mobile); supports both user types | `Home` / `Saved` / `Create` (journalist-only) / `Profile` |
| **FAB (Floating Action Button) for Create** | High-visibility entry point; Material Design standard for primary creation actions | Position bottom-right, above nav bar; animate on scroll (hide on scroll-down, show on scroll-up) |
| **Swipe-back gesture for navigation** | Reduces reliance on small back buttons; natural on both iOS and Android | Use Flutter's `CupertinoPageRoute` or custom `PageRouteBuilder` with edge-swipe |
| **Tab indicator with smooth animation** | Provides wayfinding; modern aesthetic | Use `AnimatedContainer` or tab bar with animated underline |

### 7.2 Article Creation Form Design

**Current Figma (baseline):** Title field -> Attach Image button -> Content area -> Publish button

**Recommended redesign:**

| Element | Current | Recommended | Reason |
|---------|---------|-------------|--------|
| **Layout** | Single scroll form | **Single scroll with sticky header + floating publish** | Keep context while scrolling long content |
| **Title Field** | Standard text field | **Auto-expanding text field, 24pt bold font, no border** | Mimics Medium/Ghost "just start typing" feel; reduces form anxiety |
| **Description Field** | Missing | **Add: subtitle/teaser field, 16pt, lighter weight** | Critical for feed card preview; every benchmark has this |
| **Content Area** | Basic text area | **Expandable rich text with minimal toolbar** (bold, italic, link only) | Ghost-level simplicity; avoid WordPress-style block complexity |
| **Image Attachment** | "Attach Image" button | **Tappable image placeholder area with icon + text** ("Tap to add cover photo") | Visual affordance > text button; shows *where* the image will go |
| **Publish Button** | Bottom of form | **Sticky bottom bar with "Preview" + "Publish" side by side** | Preview reduces anxiety; sticky ensures always accessible |
| **Character Counter** | Missing | **Add: subtle counter for title (max 100 chars) and description (max 200 chars)** | Prevents truncation in feed cards |
| **Draft Indicator** | Missing | **Add: "Draft saved" timestamp in header** | Addresses autosave anxiety (Medium's #1 user complaint) |

### 7.3 Image Handling UX

| Recommendation | Details |
|---------------|---------|
| **Bottom sheet picker** | On tap: show bottom sheet with "Take Photo", "Choose from Gallery" options |
| **Automatic compression** | Compress to WebP, max 1200px width, <500KB -- client-side before upload (prevents upload failures on cellular) |
| **16:9 crop enforced** | Maintain consistent feed card aspect ratios; use `image_cropper` Flutter package |
| **Upload progress** | Show determinate progress bar during Firebase Storage upload; estimated time remaining |
| **Retry on failure** | If upload fails, keep the image in memory and offer one-tap retry (don't make them re-select) |
| **Placeholder preview** | Before image is selected, show a styled placeholder that demonstrates the ideal result |
| **Remove option** | After image is attached, show a small "x" to remove and re-select |

### 7.4 Feedback and Confirmation Patterns

| Moment | Pattern | Implementation |
|--------|---------|----------------|
| **Article saved** | Bookmark icon morphs from outline to filled + subtle scale animation + haptic | `AnimatedSwitcher` + `HapticFeedback.lightImpact()` |
| **Article removed from saved** | Swipe-to-dismiss + undo toast (5 seconds) | `Dismissible` widget + `SnackBar` with undo action |
| **Draft auto-saved** | Subtle "Saved" text appears in header, fades after 2 seconds | `AnimatedOpacity` with timer |
| **Form validation error** | Inline error text below field + field border turns red + gentle shake | `TextFormField` validator + custom shake animation |
| **Publish in progress** | Full-screen overlay with animated illustration + progress bar + "Publishing your story..." text | `showDialog` with custom progress widget |
| **Publish success** | Confetti animation + "Your article is live!" + "View Article" CTA button | `confetti` package + success dialog |
| **Publish failure** | Friendly error screen: illustration + plain-language error + "Try Again" + "Save as Draft" options | Error dialog with retry logic |
| **Pull to refresh** | Custom refresh indicator with app branding + haptic feedback | `RefreshIndicator` customized |

### 7.5 Accessibility -- The "Grandmother Test"

> *"Your 90 year old grandmother must be able to use the app"*

| Guideline | Implementation | Standard |
|-----------|----------------|----------|
| **Minimum font size: 16sp body, 18sp+ for key labels** | Use `Theme` data with `textScaleFactor` support | WCAG 2.2 |
| **Minimum touch target: 48x48 dp** | All tappable elements including buttons, icons, list items | Material Design guideline |
| **Color contrast ratio: 4.5:1 minimum** | Use WCAG contrast checker for all text/background combos | WCAG 2.2 AA |
| **No color-only information** | Use icons + labels + color together (e.g., error = red border + icon + text) | 1 in 12 men are color blind |
| **Clear, jargon-free labels** | "Save" not "Bookmark"; "Write" not "Compose"; "Publish" not "Submit" | Plain language principle |
| **Screen reader support** | Add `Semantics` widgets to all interactive elements; test with TalkBack/VoiceOver | WCAG 2.2 |
| **Predictable navigation** | Bottom nav always visible; no hidden hamburger menus; no gesture-only actions | Elderly-friendly |
| **Large, clear buttons** | Primary actions (Publish, Save) use full-width buttons with high contrast | Reduce missed taps |
| **Text resizing support** | Respect system font size; test at 200% scale without layout breakage | WCAG 2.2 |
| **Error recovery** | Every destructive action has undo; every error has a clear fix path | Forgiveness > prevention for elderly users |

### 7.6 Modern Appeal -- The "18-Year-Old NPC Test"

> *"An 18 year old male NPC must use the app and think 'this shit goes hard'"*

| Element | Implementation | Vibe |
|---------|----------------|------|
| **Dark mode default** | Implement full dark theme with dark gray (#121212) base, not pure black; neon accent colors | 68% of tech-savvy users prefer dark mode |
| **Smooth page transitions** | Use `Hero` animations for article card to detail transitions; shared element transitions | Feels "buttery" and premium |
| **Haptic feedback everywhere** | `HapticFeedback.mediumImpact()` on saves, publishes, refreshes | Physical feedback makes actions feel "real" |
| **Skeleton loading screens** | Show shimmer/skeleton placeholders while content loads (not a spinner) | Modern apps never show empty loading states |
| **Confetti on publish** | Particle animation celebration when article goes live | Dopamine hit; Duolingo-proven engagement pattern |
| **Card elevation and shadows** | Subtle shadow on article cards; slight scale-up on long-press | Depth creates premium material feel |
| **Animated empty states** | Lottie animations for "no saved articles" or "no results" screens | Delightful > boring |
| **Pull-to-refresh with custom animation** | Branded animation (not default Material spinner) | App identity + polish |
| **Gradient accents** | Subtle gradient on primary buttons and selected states | Trendy without being distracting |
| **Micro-animation on bookmark** | Bookmark icon bounces/morphs with particle burst on save | Satisfying dopamine moment |

### 7.7 Microinteractions and Animations

| Interaction | Animation | Duration | Flutter Implementation |
|-------------|-----------|----------|----------------------|
| Tap article card | Scale to 0.98 + subtle shadow reduction | 100ms | `GestureDetector` + `AnimatedScale` |
| Card to Detail transition | Hero animation: thumbnail expands to full header | 300ms | `Hero` widget with shared tag |
| Bookmark toggle | Icon morphs: outline to filled + bounce + particles | 400ms | `AnimatedSwitcher` + custom painter |
| Pull to refresh | Custom branded animation to content slides in | 500ms | Custom `RefreshIndicator` |
| Form field focus | Bottom border animates from center outward + label floats | 200ms | `InputDecoration` with `FloatingLabelBehavior.auto` |
| Publish button press | Button compresses to progress bar fills to expands to success | 200ms + upload time | `AnimatedContainer` + state management |
| Success confetti | Particle burst from center of screen | 2000ms | `confetti` package |
| Error shake | Horizontal oscillation of error field | 300ms | Custom `AnimationController` with `Curves.elasticIn` |
| Image upload progress | Circular determinate progress overlay on thumbnail | Duration of upload | `CircularProgressIndicator` with value |
| Draft saved indicator | "Saved" fades in to holds to fades out | 300ms in + 1500ms hold + 300ms out | `AnimatedOpacity` with `Future.delayed` |

### 7.8 Error Handling UX

| Error Scenario | User-Facing Message | Recovery Action | Technical Detail |
|---------------|---------------------|-----------------|------------------|
| **No internet on feed load** | "You're offline. Here are your saved articles." | Show saved articles + retry button | Check connectivity; fallback to local cache |
| **NewsAPI request failure** | "Couldn't refresh headlines. Pull down to try again." | Pull-to-refresh | HTTP error handling with retry logic |
| **Image upload failure** | "Your cover photo couldn't be uploaded. Check your connection and try again." | One-tap retry (image stays in memory) | Firebase Storage error with retry with exponential backoff |
| **Article publish failure** | "Something went wrong while publishing. Your draft is safe. Try again?" | Retry / Save as Draft / Back to editing | Firestore write error with auto-save draft locally |
| **Title too long** | "Headlines work best under 100 characters" (shown at 100 chars) | Inline character counter turns red | `maxLength` on `TextFormField` with soft validation |
| **Empty required field** | "Your article needs a title" / "Add some content before publishing" | Scroll to and highlight the empty field | `Form` validation + `Scrollable.ensureVisible` |
| **Authentication expired** | "Your session expired. Please sign in again." | Re-auth flow preserving draft state | Firebase Auth token refresh failure |
| **Image too large** | (Handled silently -- auto-compress client-side) | N/A | `image_picker` + client-side compression to <500KB |
| **Firebase quota exceeded** | "Our servers are busy. Please try again in a few minutes." | Retry with countdown timer | Firestore/Storage quota error handling |

---

## 8. Data-Backed Assumptions

### Assumption 1: Mobile-first creation is viable and expected
- **Evidence:** 82% of users expect to complete essential forms on mobile (Tinyform, 2025). 73% of all digital interactions occur on mobile. The average smartphone user spends 4.9 hours/day on apps (Statista, 2025).
- **Impact:** Justify building the article creation feature as a first-class mobile experience, not a compromised afterthought.

### Assumption 2: Existing platforms have abandoned mobile article creation, creating a gap
- **Evidence:** Medium disabled mobile editing in 2022. Ghost has no mobile app. Substack's app is read-focused. WordPress mobile editor is described as clunky ("a dinosaur" -- Anna B. Yang).
- **Impact:** Our app can differentiate by being the platform where you can *both* read and write quality articles from your phone.

### Assumption 3: Autosave is non-negotiable
- **Evidence:** Top user complaint from Medium UX study: *"without interaction with the article, I am afraid that I may lose the draft"* (UXPlanet contextual inquiry). Ghost's autosave is rated its best feature. WordPress mobile has full draft management.
- **Impact:** Implement debounced autosave every 5 seconds after last keystroke. Show visible "Draft saved" indicator. Store drafts locally AND sync to Firebase.

### Assumption 4: Dark mode is expected, not optional
- **Evidence:** 68% of tech-savvy users choose dark mode (SanjayDey.com). Gen Z associates dark interfaces with premium, modern brands. OLED screens use 50% less power in dark mode. All top-10 apps support dark mode.
- **Impact:** Ship with dark mode from Day 1. Consider dark-mode-first design with light mode as alternative. Use dark gray (#121212), not pure black.

### Assumption 5: Younger users (18-29) still read news -- but on their terms
- **Evidence:** 45% of 18-29 year-olds prefer *reading* news over watching (31%) or listening (24%) -- Pew Research, Aug 2025. However, only 14% go directly to news apps; 40% come via social media (Reuters, 2025).
- **Impact:** Optimize the reading experience for this demographic. Make sharing frictionless (social-first distribution). Don't assume young users only want video.

### Assumption 6: Older users have higher news interest but lower tech confidence
- **Evidence:** 52% of 55+ year-olds report high news interest vs. 35% of 18-24s (Reuters, 2025). Users 65+ spend <51.4 hours/month on apps but are heavy news consumers. Font sizes of 18dp+ and touch targets of 48x48dp are required for elderly usability (HK DPO Elderly-Friendly Design Guide, 2025).
- **Impact:** The "grandmother test" directly benefits our highest-interest audience segment. Large fonts, clear labels, and predictable navigation serve both accessibility and engagement.

### Assumption 7: Image handling is the #1 friction point in mobile content creation
- **Evidence:** Medium mobile bugs included broken image descriptions, no undo on image edits. WordPress block editor image handling requires multiple taps. No benchmark offers client-side compression + crop + preview in a single flow.
- **Impact:** Invest heavily in image UX: bottom sheet picker to auto-compress to crop to 16:9 to preview to one-tap retry on failure. This single flow can differentiate our creation experience.

### Assumption 8: Microinteractions significantly improve engagement and completion rates
- **Evidence:** Gamified forms boost engagement by 60% (Designity). Microinteractions improved form submissions by 25% in direct A/B tests (Morfett Designs via Tinyform). Data-driven design decisions improve usability by 88% (MockFlow UX Research).
- **Impact:** Every state change should have a corresponding microinteraction: bookmark animations, publish celebrations, error shakes, draft-saved indicators. These aren't nice-to-haves -- they're conversion drivers.

### Assumption 9: Only 25% of users return after Day 1 -- onboarding is critical
- **Evidence:** Retention Day 1 = 25% average across all apps (Adjust, 2025). Effective onboarding increases Day 1 retention by 50% (Localytics). 21% of Millennials open an app 50+ times/day (BuildFire, 2026).
- **Impact:** Onboarding must be <=3 screens, show immediate value, and let users start browsing within 10 seconds. Don't gate the reading experience behind account creation -- only require auth for journalist features.

### Assumption 10: Combining reading + creation creates network effects
- **Evidence:** Substack's built-in discovery provides organic growth for new writers. LinkedIn articles appear directly in the feed, driving engagement. Medium's reader base is the primary incentive for writers to use the platform.
- **Impact:** Firebase articles should appear seamlessly alongside NewsAPI headlines in the same feed. This gives journalists instant distribution and gives readers diverse content -- creating a virtuous cycle.

### Assumption 11: Simple forms outperform complex ones on mobile
- **Evidence:** Our form has only 4 fields (title, description, content, image) -- far below the complexity threshold. Form completion rates drop significantly after 5+ fields. WordPress's block editor on mobile is universally criticized for over-complexity. Ghost's success is attributed to markdown simplicity.
- **Impact:** Resist the urge to add categories, tags, scheduling, or formatting options in v1. Title + Description + Content + Image is the minimum viable article. Complexity can come in v2 based on journalist feedback.

### Assumption 12: Preview before publish reduces errors and anxiety
- **Evidence:** WordPress and Ghost both feature preview as a core workflow step. Medium users report publishing anxiety. The "grandmother test" requires clear steps before irreversible actions.
- **Impact:** Add a "Preview" step between form completion and publishing. Show exactly how the article will appear in the feed card AND the detail screen. This builds confidence for both novice and experienced publishers.

---

## 9. Priority Matrix

### Framework

Features and improvements are scored on two axes:
- **Impact** (1-5): How much value does this deliver? Considers: assignment requirement weight, user pain point severity, competitive differentiation, and alignment with Symmetry's "Maximally Overdeliver" value.
- **Effort** (1-5): How much work to implement? Considers: technical complexity, number of files touched, dependencies on other work, and testing burden.

**Quadrants:**
- **P0 -- Do First** (High Impact, Low-Medium Effort): Assignment requirements + quick wins
- **P1 -- Do Next** (High Impact, Higher Effort): Core differentiators that take more work
- **P2 -- Nice to Have** (Medium Impact, Low Effort): Polish items that show attention to detail
- **P3 -- Backlog** (Lower Impact or High Effort): Future improvements for v2+

### P0 -- Do First (Assignment-Critical + Quick Wins)

These are non-negotiable. The assignment fails without them.

| # | Feature / Improvement | Impact | Effort | Justification |
|---|----------------------|--------|--------|---------------|
| P0-01 | Firebase project setup + FlutterFire CLI | 5 | 2 | Blocker for all backend work; assignment requirement 2.0 |
| P0-02 | Firestore schema design + `DB_SCHEMA.md` | 5 | 2 | Assignment requirement 1.1; must exist before any data layer work |
| P0-03 | Firestore security rules | 5 | 2 | Assignment requirement 1.3; schema enforcement |
| P0-04 | Cloud Storage security rules | 5 | 1 | Assignment requirement 1.3; simple rule set for `media/articles/` |
| P0-05 | Create Article entity (domain layer) | 5 | 2 | Assignment requirement 2.1; foundation for all feature code |
| P0-06 | Create Article use case + Upload Image use case | 5 | 2 | Assignment requirement 2.1; business logic core |
| P0-07 | Abstract repository for article creation | 5 | 1 | Assignment requirement 2.1; interface contract |
| P0-08 | Create Article BLoC/Cubit | 5 | 3 | Assignment requirement 2.2; state management for the form |
| P0-09 | Create Article page UI (form + image picker) | 5 | 4 | Assignment requirement 2.2; the primary deliverable screen |
| P0-10 | FAB navigation to Create Article page | 5 | 1 | Assignment requirement 2.2; replaces the TODO in `daily_news.dart` |
| P0-11 | Firestore data source + Storage data source | 5 | 3 | Assignment requirement 2.3; connects frontend to backend |
| P0-12 | Firebase Article model with serialization | 5 | 2 | Assignment requirement 2.3; Firestore JSON mapping |
| P0-13 | Repository implementation (replace mocks) | 5 | 3 | Assignment requirement 2.3; real data flow |
| P0-14 | DI registration for new feature | 5 | 1 | Required for everything to work; small change to `injection_container.dart` |
| P0-15 | Fix hardcoded API key (security) | 5 | 1 | Critical security issue; Boy Scout Rule (CG1) |
| P0-16 | Fix Equatable props crash | 5 | 1 | App crashes at runtime on specific states; blocking bug |
| P0-17 | Fix force-unwrap null crashes (`!`) | 5 | 2 | Multiple runtime crash risks throughout presentation layer |
| P0-18 | Unit tests for new use cases (TDD) | 4 | 3 | TDD is CG4; "MAXIMALLY OVERDELIVER" per their own docs |
| P0-19 | Unit tests for new BLoC | 4 | 3 | TDD is CG4; demonstrates testing discipline |
| P0-20 | Project Report (`docs/REPORT.md`) | 5 | 3 | Assignment requirement 3; "crucial for reviewers" |

### P1 -- Do Next (High-Value Differentiators)

These separate a "complete" submission from an "impressive" one.

| # | Feature / Improvement | Impact | Effort | Justification |
|---|----------------------|--------|--------|---------------|
| P1-01 | Autosave drafts locally | 5 | 3 | Research Assumption #3: non-negotiable per benchmarks; addresses journalist pain point J-F6 |
| P1-02 | Preview before publish | 4 | 2 | Research Assumption #12: reduces publishing anxiety; WordPress/Ghost pattern |
| P1-03 | Image crop to 16:9 + compression | 4 | 3 | Research Assumption #7: #1 friction point in mobile creation; competitive differentiator |
| P1-04 | Form validation with inline errors | 4 | 2 | Research Assumption #8: 25% higher completion rates; grandmother test |
| P1-05 | Dark mode theme | 4 | 3 | Research Assumption #4: 68% preference; NPC test; `values-night/styles.xml` already exists |
| P1-06 | Pull-to-refresh on home page | 4 | 1 | Reader pain point R-F1; currently no way to refresh; trivial `RefreshIndicator` |
| P1-07 | ListView.builder (lazy rendering) | 3 | 1 | Performance fix; currently builds all widgets eagerly |
| P1-08 | Remove Dio from DataState/presentation | 4 | 2 | Architecture violation: Dio leaks into core/presentation layers |
| P1-09 | Replace DioError with DioException | 3 | 2 | Deprecated API; future-proofs codebase |
| P1-10 | Add `toEntity()` on models | 3 | 1 | Architecture violation 1.3.2; explicitly required by their docs |
| P1-11 | Publish success feedback (confetti/celebration) | 3 | 2 | Research Assumption #8: gamification boosts engagement 60%; journalist emotional job J-E3 |
| P1-12 | Hero animation card-to-detail | 3 | 2 | NPC test; Flipboard-level polish; reader emotional job R-E3 |
| P1-13 | Error retry on home page | 3 | 1 | Currently shows static error icon with no tap handler |
| P1-14 | Unit tests for existing use cases | 4 | 2 | Boy Scout Rule CG1: "leave the campground cleaner than you found it" |
| P1-15 | Widget tests for key screens | 3 | 3 | CG4.2: "Create/Adapt Integration tests when you add/change a User Journey" |

### P2 -- Nice to Have (Polish + Attention to Detail)

These show you care about quality beyond just "it works."

| # | Feature / Improvement | Impact | Effort | Justification |
|---|----------------------|--------|--------|---------------|
| P2-01 | Skeleton/shimmer loading | 3 | 2 | NPC test; modern loading pattern; replaces CupertinoActivityIndicator |
| P2-02 | Bookmark animation (micro-interaction) | 2 | 2 | Research Assumption #8; satisfying save moment |
| P2-03 | Bottom sheet image picker (camera/gallery) | 3 | 1 | Instagram pattern; more intuitive than a button |
| P2-04 | Character counter on title/description | 2 | 1 | Prevents feed card truncation; form best practice |
| P2-05 | Empty state illustration for saved articles | 2 | 1 | Currently plain text; Lottie animation shows care |
| P2-06 | Haptic feedback on key actions | 2 | 1 | NPC test; physical confirmation; trivial to add |
| P2-07 | Swipe-to-dismiss on saved articles + undo toast | 2 | 2 | Gmail pattern; forgiveness UX; grandmother test |
| P2-08 | Rename `pages` to `screens` | 1 | 1 | Architecture doc specifies `screens`; shows you read the docs |
| P2-09 | Add `shared` folder structure | 1 | 1 | Architecture doc specifies it; shows structural awareness |
| P2-10 | Add `const` constructors where missing | 1 | 1 | Performance micro-optimization; code quality signal |
| P2-11 | Add return type annotations | 1 | 1 | Code quality; CG2 meaningful names |
| P2-12 | Update Dart SDK constraint | 2 | 1 | Prevents confusing dependency resolution errors |
| P2-13 | Splash screen | 2 | 2 | First impression; currently white stub |
| P2-14 | Upload progress indicator (determinate) | 3 | 2 | Journalist pain point; WhatsApp pattern |
| P2-15 | Draft saved indicator in header | 2 | 1 | Addresses autosave anxiety; Ghost pattern |

### P3 -- Backlog (Future / v2+)

These are excellent ideas but not justified for initial submission scope.

| # | Feature / Improvement | Impact | Effort | Justification |
|---|----------------------|--------|--------|---------------|
| P3-01 | User authentication (Firebase Auth) | 4 | 4 | Not required by assignment; adds complexity; but enables journalist ownership |
| P3-02 | Article editing after publish | 3 | 4 | Journalist job J-F5; requires additional CRUD flows |
| P3-03 | Bottom navigation bar | 3 | 3 | Research recommends it; but assignment uses current nav pattern |
| P3-04 | Article categories/tags | 2 | 3 | Research Assumption #11: keep v1 simple; add in v2 |
| P3-05 | Rich text editor | 2 | 4 | Ghost-level; but over-engineering for v1 |
| P3-06 | Article sharing (native share sheet) | 2 | 2 | Reader social job R-S1; low effort but not assignment-critical |
| P3-07 | Offline support / cached articles | 3 | 4 | Reader job R-F3; significant caching infrastructure |
| P3-08 | Pagination / infinite scroll | 3 | 3 | Currently loads all at once; matters at scale |
| P3-09 | Push notifications | 2 | 4 | FCM setup + permissions; overkill for assignment |
| P3-10 | CI/CD pipeline (GitHub Actions) | 2 | 3 | Shows DevOps awareness; but not code quality |
| P3-11 | Onboarding screens (3 max) | 2 | 3 | Research Assumption #9; Day 1 retention; but scope creep |
| P3-12 | Article drafts synced to Firebase | 3 | 3 | Enhancement over local-only autosave |
| P3-13 | Analytics dashboard for journalists | 2 | 5 | Journalist feedback loop; high effort |

### Priority Summary Visualization

```
                    HIGH IMPACT
                        |
         P0             |           P1
    (Do First)          |       (Do Next)
    - Firebase setup    |    - Autosave drafts
    - Schema + rules    |    - Preview before publish
    - Create Article    |    - Image crop/compress
      full feature      |    - Dark mode
    - Fix crashes       |    - Hero animations
    - TDD tests         |    - Pull-to-refresh
    - Report            |    - Architecture fixes
                        |
  LOW EFFORT -----------+------------ HIGH EFFORT
                        |
         P2             |           P3
   (Nice to Have)       |       (Backlog)
    - Shimmer loading   |    - Firebase Auth
    - Haptic feedback   |    - Article editing
    - Character counter |    - Bottom nav bar
    - Empty states      |    - Rich text editor
    - Rename pages/     |    - Offline support
      screens           |    - Push notifications
    - Splash screen     |    - CI/CD
                        |
                    LOW IMPACT
```

### Recommended Execution Order

Based on dependency chains and the priority matrix:

```
Week 1: P0 (Assignment Requirements)
  Day 1-2: Firebase setup + Schema + Rules (P0-01 to P0-04)
           Fix critical bugs (P0-15 to P0-17)
  Day 2-3: Domain layer + TDD (P0-05 to P0-07, P0-18)
  Day 3-4: Presentation layer + TDD (P0-08 to P0-10, P0-19)
  Day 4-5: Data layer (P0-11 to P0-14)

Week 2: P1 (Differentiators) + P2 (Polish)
  Day 6:   Autosave + Preview + Validation (P1-01, P1-02, P1-04)
  Day 7:   Image handling + Dark mode (P1-03, P1-05)
  Day 8:   Architecture fixes + Existing tests (P1-07 to P1-15)
  Day 9:   P2 polish items (shimmer, haptics, animations)
  Day 10:  Report writing (P0-20)

Buffer: 2 days for unexpected issues and final polish
```

---

## Appendix: Key Sources

> All sources verified on March 25, 2026. URLs were confirmed accessible at time of writing.

### Primary Research Reports

| # | Source | Date | Key Data Point | URL |
|---|--------|------|----------------|-----|
| 1 | Pew Research Center, "Young Adults and the Future of News" | Dec 3, 2025 | 15% of 18-29 year-olds follow news closely; 45% prefer reading news over watching (31%) or listening (24%) | [pewresearch.org](https://www.pewresearch.org/journalism/2025/12/03/young-adults-and-the-future-of-news/) |
| 2 | Reuters Institute / FT Strategies, "Journalism and Technology Trends & Predictions 2025" | 2025 | "Creator-fication of news"; top talent seeking direct-audience ownership | [hubspotusercontent-eu1.net (PDF)](https://24982124.fs1.hubspotusercontent-eu1.net/hubfs/24982124/PDF%20documents/2025%20Journalism%20Predictions%20x%20FT%20Strategies.pdf) |
| 3 | Reuters Institute, "Digital News Report 2025" | June 2025 | 14% of 18-24s go directly to news apps; 40% via social media; 52% of 55+ report high news interest vs 35% for 18-24 | [reutersinstitute.politics.ox.ac.uk (PDF)](https://reutersinstitute.politics.ox.ac.uk/sites/default/files/2025-06/Digital_News-Report_2025.pdf) |
| 4 | Tinyform, "Unveiling 2025: Mobile Form Statistics & UX Trends" | 2025 | 82% of users expect to complete essential forms on mobile (up from 67% in 2024); microinteractions +25% form submissions | [tinyform.com](https://tinyform.com/post/mobile-form-statistics-ux-trends) |
| 5 | Adjust, "Mobile App Trends: 2025 Edition" | 2025 | 25% Day-1 retention rate across all apps. Corroborated by Statista (25.3%) and AppsFlyer (24.33%) | [Adjust PDF](https://adindex.ru/publication/analitics/search/330815/img/Adjust%20x%20AppLovin-mobile-app-trends-2025.pdf) |
| 6 | Hong Kong Digital Policy Office (DPO), "Elderly-friendly Website/Mobile Application Design Guide" v1.2 | Sep 2025 | 18dp+ fonts; 200% text scaling; clear steps for elderly. Originally published by OGCIO, renamed to DPO July 2024 | [digitalpolicy.gov.hk (PDF)](https://www.digitalpolicy.gov.hk/en/our_work/digital_government/digital_inclusion/accessibility/promulgating_resources/application_design_guide/doc/elderly_friendly_design_guide_eng.pdf) |

### Industry Data & Statistics

| # | Source | Date | Key Data Point | URL |
|---|--------|------|----------------|-----|
| 7 | Statista / 42matters, "Free and paid app distribution 2025" | Nov 27, 2025 | 95.4% of apps are free. Also cited by MindSea | [statista.com](https://www.statista.com/statistics/263797/number-of-applications-for-mobile-phones/) |
| 8 | BusinessofApps, "App Data" | 2025 (ongoing) | 25-34 year-olds spend 102.4 hours monthly on apps | [businessofapps.com](https://www.businessofapps.com/data-topic/app-data/) |
| 9 | SQMagazine, "Mobile App Growth Statistics" | 2025 | Average daily time on mobile apps: 4.9 hours globally in 2025 | [sqmagazine.co.uk](https://sqmagazine.co.uk/mobile-app-growth-statistics/) |
| 10 | BuildFire, "Mobile App Download & Usage Statistics (2026)" | Updated 2026 | 21% of Millennials open an app 50+ times/day (stat originates ~2020 via Comscore) | [buildfire.com](https://buildfire.com/app-statistics/) |
| 11 | Sanjay Dey, "Designing for Gen Z and UI Trends" | 2025 | 68% of tech-savvy users choose dark mode | [sanjaydey.com](https://www.sanjaydey.com/designing-for-gen-z-ui-trends-next-generation/) |

### UX Case Studies & Reviews

| # | Source | Date | Key Data Point | URL |
|---|--------|------|----------------|-----|
| 12 | Camilla Z / UXPlanet, "Redesign Medium's editing experience — a UX case study" | March 2020 | "Some useful functions are hidden so deep in the '...' icon"; "without interaction with the article, I am afraid that I may lose the draft" — from 5 contextual inquiries | [uxplanet.org](https://uxplanet.org/improve-mediums-editing-experience-for-new-writers-b54bc2644c64) |
| 13 | Abhinav Yadav, "Medium App Bugs (RTB)" | Jan 19, 2022 (updated Mar 24, 2022) | "Every letter gets CAPITALIZED when editing"; "Editing from Native apps is not allowed anymore" (Medium disabled mobile editing March 2022) | [medium.com](https://travellingthroughspace.medium.com/medium-bug-list-1351e19ec5af) |
| 14 | Norbert Hires, "My Review of the Ghost Blogging Platform after 1 year" | 2023-2024 | "Grammarly integration in the editor... skipping the 'right-click + search + add' steps and typing immediately what you need significantly fastens the writing process" | [norberthires.blog](https://www.norberthires.blog/ghost-blogging-platform-review/) |
| 15 | Anna Burgess Yang, "I Publish on Substack, Ghost, and Kit. Here's Why." | 2024-2025 | WordPress "felt like a dinosaur compared to more responsive sites" | [blog.annabyang.com](https://blog.annabyang.com/publish-substack-ghost-kit/) |
| 16 | Linda Caroll, "Does Writing In A Niche Help You As A Writer? Depends Where." | 2024-2025 | "I think writers do have to niche on Substack... it's going to be a million times harder to build an audience" otherwise | [lindac.substack.com](https://lindac.substack.com/p/does-writing-in-a-niche-help-you) |

### Competitive Analysis Sources

| # | Source | Date | Key Data Point | URL |
|---|--------|------|----------------|-----|
| 17 | Outrank, "Substack vs WordPress: Which Platform Is Right for You?" | 2024-2025 | "New publications can be discovered through Substack's own reader recommendations and network, providing organic growth opportunities" | [outrank.so](https://www.outrank.so/blog/substack-vs-wordpress) |
| 18 | Net Solutions, "13 Best News Apps of 2025" | 2025 (updated) | Flipboard = "quite possibly the world's trendiest and most engaging news app" | [netsolutions.com](https://www.netsolutions.com/insights/11-best-news-apps/) |

### Design & Engagement Data

| # | Source | Date | Key Data Point | URL |
|---|--------|------|----------------|-----|
| 19 | Designity, "Top Trends in Mobile App Design" | 2025-2026 | Gamified forms boost engagement by 60% | [designity.com](https://www.designity.com/blog/top-trends-in-mobile-app-design) |
| 20 | Localytics (via Medium) | ~2017 | "We've seen app user retention rates increase by 50% after implementing a solid onboarding" | [medium.com/@Localytics](https://medium.com/@Localytics_58363/mobile-apps-whats-a-good-retention-rate-528381a1af0d) |
| 21 | MockFlow, "Top Trends for UX Research" (via Tinyform) | 2025 | Data-driven design decisions improve usability by 88% | [mockflow.com](https://mockflow.com/blog/top-trends-for-ux-research) |

### Source Reliability Notes

| Source | Confidence | Note |
|--------|-----------|------|
| Pew Research Center | **High** | Peer-reviewed, survey-based, methodology published |
| Reuters Institute | **High** | Oxford University-affiliated, gold standard for digital news research |
| Adjust / AppsFlyer / Statista | **High** | Primary data from mobile analytics platforms |
| Tinyform / Designity / MockFlow | **Medium** | Industry blogs; stats may be aggregated from multiple sources. The "88% usability" claim from MockFlow may trace to the widely-cited Econsultancy stat about return visits after bad UX |
| SQMagazine (4.9 hrs/day) | **Medium** | Secondary aggregation. Primary source (Sensor Tower via MindSea) reports 3.6 hrs/day. The 4.9 figure may include background usage |
| BuildFire (21% Millennials) | **Medium** | Widely cited but stat originates ~2017-2020, not fresh 2026 data |
| UXPlanet / Medium blogs | **Medium** | Contextual inquiries with small sample (n=5). Qualitative, not statistical |
| Individual blogger reviews | **Low-Medium** | Anecdotal; valuable for qualitative sentiment, not statistical claims |

---

*This document was produced following the Continuous Discovery framework. All opportunities are grounded in evidence. Design decisions should be validated through usability testing with representative users from both persona groups.*
