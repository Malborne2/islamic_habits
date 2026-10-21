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

Supported formats: `.mp3`, `.wav`, or `.ogg` (keep the filenames above,
just change the extension to match).

Without these files, prayers set to Adhan mode fall back to the device's
default notification sound.
