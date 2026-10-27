# Islamic Habits

A Flutter app for building consistent Islamic habits — the five daily prayers, Qur'an reading, and any other habit you want to track — with accurate prayer times, Adhan playback, and streak-based statistics.

## Features

- **Habit tracking** — Yes/No habits (e.g. "prayed Fajr") or number-based habits (e.g. "pages of Qur'an read"), each with its own schedule (every day, specific weekdays, or N times a week), success target, and colour.
- **Prayer times** — calculated on-device from your location (manual entry, city search, or a map picker), with a choice of calculation methods and madhabs, plus per-prayer manual adjustments.
- **Adhan playback** — 8 bundled reciter voices, each with a full recording and a pre-trimmed "Takbeer only" cut; choose per prayer whether it plays a full notification, Adhan audio, a silent vibration, or nothing at all.
- **Prayer reminders** — an optional Yes/No notification 30 minutes after each prayer, answerable right from the notification.
- **Statistics dashboard** — overall success rate, daily/weekly/monthly completion trends, and per-habit breakdowns, charted with full RTL support.
- **Localization** — 9 languages (English, Arabic, Persian, Urdu, Indonesian, Japanese, Norwegian, Swedish, Finnish), with right-to-left layout for Arabic/Persian/Urdu, Hijri calendar dates, and Eastern Arabic numeral support.
- **Backup & restore** — export your habit data to a file and restore it later or on another device.
- **Dark mode**, configurable start-of-week, and a first-run onboarding tour.

## Tech stack

- [Flutter](https://flutter.dev) / Dart
- [sembast](https://pub.dev/packages/sembast) — local NoSQL storage for habits
- [adhan](https://pub.dev/packages/adhan) — prayer time calculation
- [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications) — scheduled prayer/reminder notifications
- [audioplayers](https://pub.dev/packages/audioplayers) — in-app Adhan voice preview
- [fl_chart](https://pub.dev/packages/fl_chart) — statistics charts
- [flutter_bloc](https://pub.dev/packages/flutter_bloc) — theme state
- [flutter_map](https://pub.dev/packages/flutter_map) — location picker

## Getting started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Dart ≥ 3.0.0)
- Android Studio (for the Android SDK/emulator) and/or Xcode (for iOS)

### Setup

```bash
git clone https://github.com/<your-username>/islamic_habits.git
cd islamic_habits
flutter pub get
flutter run
```

To build a release APK:

```bash
flutter build apk --release
```

### Signing a release build

Release builds expect `android/key.properties` pointing at your own signing key; this file is intentionally not checked in. See the Flutter docs on [signing the app](https://docs.flutter.dev/deployment/android#signing-the-app) to generate a keystore and create that file yourself.

### Adding an Adhan voice

See [`android/app/ADHAN_AUDIO_README.md`](android/app/ADHAN_AUDIO_README.md) for how the bundled reciter audio is organized and how to add another voice.

## Project structure

```
lib/
  components/   # Reusable widgets (habit buttons, day circles, drawer, …)
  screens/      # App screens (home, prayer times, settings, statistics, …)
  utility/      # Habit model, prayer/notification services, localization helpers
  l10n/         # ARB translation files and generated localization classes
android/        # Android platform project (incl. bundled Adhan audio)
ios/            # iOS platform project
```

## Contributing

Issues and pull requests are welcome. For anything non-trivial, please open an issue first to discuss what you'd like to change.

## License

Licensed under the [GNU GPLv3](LICENSE).
