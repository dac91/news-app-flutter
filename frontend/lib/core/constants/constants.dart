const String newsAPIBaseURL = 'https://newsapi.org/v2';

/// API key injected at compile time via `--dart-define=NEWS_API_KEY=<key>`.
///
/// Never hardcode API keys in source code — they end up in version control
/// and are trivially extractable from compiled binaries.
///
/// Usage:
///   flutter run --dart-define=NEWS_API_KEY=your_key_here
///   flutter build apk --dart-define=NEWS_API_KEY=your_key_here
const String newsAPIKey = String.fromEnvironment(
  'NEWS_API_KEY',
  defaultValue: '',
);

const String countryQuery = 'us';
const String categoryQuery = 'general';

/// Fallback placeholder image when an article has no thumbnail.
///
/// Uses a lightweight placeholder service instead of a broken Google
/// Images search URL (which returns HTML, not an image).
const String kDefaultImage =
    'https://placehold.co/600x400/e8e8e8/999999?text=No+Image';