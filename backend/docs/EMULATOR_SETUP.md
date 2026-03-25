# Firebase Emulator Setup

## Prerequisites

- [Firebase CLI](https://firebase.google.com/docs/cli) installed (`npm install -g firebase-tools`)
- Java JDK 11+ (required by Firestore emulator)

## Quick Start

```bash
cd backend
firebase emulators:start
```

This starts:
- **Firestore Emulator** on `localhost:8080`
- **Storage Emulator** on `localhost:9199`
- **Emulator UI** on `localhost:4000`

## Emulator UI

Open `http://localhost:4000` in your browser to:
- View and edit Firestore documents
- Monitor Storage uploads
- Clear all emulator data

## Connecting the Flutter App

To use emulators during development, the app needs to connect to the local
emulator endpoints instead of production Firebase. Add the following to
`main.dart` **before** any Firebase operations, gated behind a compile-time
flag:

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

const bool useEmulator = bool.fromEnvironment('USE_FIREBASE_EMULATOR');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (useEmulator) {
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
    FirebaseStorage.instance.useStorageEmulator('localhost', 9199);
  }

  // ... rest of app setup
}
```

Then run with:

```bash
flutter run --dart-define=USE_FIREBASE_EMULATOR=true
```

### Android Emulator Note

If running on an Android emulator (not a physical device), use `10.0.2.2`
instead of `localhost`:

```dart
if (useEmulator) {
  final host = Platform.isAndroid ? '10.0.2.2' : 'localhost';
  FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);
  FirebaseStorage.instance.useStorageEmulator(host, 9199);
}
```

## Testing Security Rules

The emulator validates Firestore and Storage security rules locally. To test
rules without deploying:

1. Start emulators: `firebase emulators:start`
2. Make requests from the app or Emulator UI
3. Check the **Rules** tab in Emulator UI for allow/deny logs

## Seeding Test Data

To export emulator data for repeatable testing:

```bash
# Export current emulator state
firebase emulators:export ./emulator-data

# Start with previously exported data
firebase emulators:start --import=./emulator-data
```

## Port Summary

| Service    | Port  |
|------------|-------|
| Firestore  | 8080  |
| Storage    | 9199  |
| Emulator UI| 4000  |
