# Play Store publishing kit

Everything needed to publish Islamic Habits on Google Play.

| File | Use |
| --- | --- |
| `play_store_listing.md` | App name, short/full description, What's new, screenshot order |
| `play_store_listing_ar.md` | Arabic listing: name, short description, and full description |
| `privacy_policy.md` | Host at a public URL and paste that URL into Play Console |
| `data_safety.md` | Answer key for the Data safety form |
| `content_rating.md` | Answer key for the IARC content-rating questionnaire |
| `graphics_checklist.md` | Icon, feature graphic, screenshots, and their specs |
| `release_checklist.md` | Build, signing, testing, declarations, and rollout steps |
| `icon_512.png` | 512×512 Play Store icon |
| `feature_graphic_1024x500.png` | 1024×500 feature graphic |
| `screenshots/` | Five 1080×1920 phone screenshots |

## Before uploading

1. Resolve the hard blockers in `release_checklist.md` — most importantly **targetSdk 36** (currently 34) and release signing.
2. Host `privacy_policy.md` and replace every `TODO` in the docs with real contact details.
3. Build the bundle with `flutter build appbundle --release`.
4. Complete App content (privacy policy, ads, app access, content rating, target audience, data safety).
5. Upload the bundle to internal testing, then closed testing, then production.
