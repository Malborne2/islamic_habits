# Adhan audio files

This app plays a custom sound when a prayer's reminder is set to the
"Adhan" mode (the microphone bell icon on the Prayer times screen). Android
plays this sound as part of the notification itself, so the app doesn't
need to be open or even running.

Eight reciters are bundled, each as two files in
`android/app/src/main/res/raw/` (used for the actual scheduled Adhan
notification sound) **and** the same two files again under `assets/adhan/`
(used by Settings' "Test this voice" preview, which plays them directly
through an in-app audio player instead of posting a notification — see
`NotificationService.playTestAdhan`/`stopTestAdhan` in
`lib/utility/notification_service.dart`). Keep both copies in sync when
adding or changing a voice.

| Voice (`lib/utility/prayer_settings.dart`) | Full recording | Takbeer-only cut |
|---|---|---|
| voice1 — Ahmad Al-Haddad | `adhan_01_full.mp3` | `adhan_01_takbeer.mp3` |
| voice2 — Tariq Fathi Ahmad | `adhan_02_full.mp3` | `adhan_02_takbeer.mp3` |
| voice3 — Hamza Al-Majali | `adhan_03_full.mp3` | `adhan_03_takbeer.mp3` |
| voice4 — Ahmad Al-Kurdi | `adhan_04_full.mp3` | `adhan_04_takbeer.mp3` |
| voice5 — Rabah Bendareh Al-Jazairi | `adhan_05_full.mp3` | `adhan_05_takbeer.mp3` |
| voice6 — Al-Haram Al-Madani | `adhan_06_full.mp3` | `adhan_06_takbeer.mp3` |
| voice7 — Noureddine Hamza Al-Maghribi | `adhan_07_full.mp3` | `adhan_07_takbeer.mp3` |
| voice8 — Mohammed Rammal | `adhan_08_full.mp3` | `adhan_08_takbeer.mp3` |

"Takbeer only" vs "full recording" is a separate toggle in Prayer Settings
(`PrayerSettings.adhanTakbeerOnly`), independent of which voice is chosen —
it just picks which of the pair above is used as the notification sound.
Android's notification-sound API can't stop partway through a file on its
own, so the `*_takbeer.mp3` files are pre-trimmed copies of the matching
`*_full.mp3`, cut at the timestamp the user supplied for each recording
(in minutes:seconds, the point where the opening takbeer ends):

```
voice1  00:17      voice5  00:28
voice2  00:21      voice6  00:26
voice3  00:27      voice7  00:31
voice4  00:33      voice8  00:20
```

The cut was done at an MPEG frame boundary (see
`lib/utility/adhan_voice_i18n.dart` for the per-locale display names, and
the project's session history for `trim_mp3.py`, the frame-parsing script
used to make the cut — no re-encoding, so no quality loss) rather than
with a re-encode, so there's no quality loss and no need for ffmpeg.

## Adding another voice

1. Add two files in `android/app/src/main/res/raw/`: `adhan_NN_full.<ext>`
   and `adhan_NN_takbeer.<ext>` (`.mp3`, `.wav`, or `.ogg`; lowercase
   letters, digits and underscores only — Android resource-name rules).
   Copy the same two files into `assets/adhan/` as `.mp3` (the test-preview
   player expects that extension regardless of the raw resource's actual
   format).
2. Add an `AdhanVoiceOption` entry to `kAdhanVoices` in
   `lib/utility/prayer_settings.dart` with a new `id`, the two resource
   names (without extension), and an English `displayName`.
3. Optionally add per-locale name translations to
   `kAdhanVoiceNameTranslations` in `lib/utility/adhan_voice_i18n.dart` —
   falls back to `displayName` for any locale left out.

Without a voice's audio files present, the Settings "Test this voice"
button and the scheduled Adhan notification both fail gracefully (a
SnackBar message / the prayer is just skipped) instead of crashing.
