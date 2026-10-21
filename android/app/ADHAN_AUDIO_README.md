# Adhan audio files

This app can play a custom sound when a prayer's reminder is set to the
"Adhan" mode (the microphone bell icon on the Prayer times screen). Android
plays this sound as part of the notification itself, so the app doesn't
need to be open or even running.

To enable it, add your own licensed audio files to
`android/app/src/main/res/raw/`, named exactly (lowercase, no spaces —
Android resource file names only allow lowercase letters, digits and
underscores):

- `takbeer.mp3` — a short clip for the "Takbeer only" voice setting
- `adhan_full.mp3` — the full call to prayer for the "Full Adhan" voice setting
- `adhan_makkah.mp3` — for the "Makkah (Haramain)" voice setting
- `adhan_madinah.mp3` — for the "Madinah (Haramain)" voice setting

Supported formats: `.mp3`, `.wav`, or `.ogg` (keep the filenames above,
just change the extension to match).

Without these files, prayers set to Adhan mode fall back to the device's
default notification sound — this is why Adhan mode has never actually
played anything audible: no files were ever added here. Use the "Test this
voice" button in Prayer Settings to check a voice without waiting for the
next prayer time.

To offer more voices than the four above, add an `AdhanVoiceOption` entry
to `kAdhanVoices` in `lib/utility/prayer_settings.dart` with a new `id` and
`soundResource`, and drop the matching audio file in here under that
`soundResource` name — no other code changes are needed.
