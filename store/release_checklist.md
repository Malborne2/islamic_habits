# Release checklist

## Hard blockers before the first upload

| # | Item | Current state | Action |
| --- | --- | --- | --- |
| 1 | **Target API level 36** | Done — `targetSdk 36`, `compileSdk 36`; debug build verified | Still test on an Android 15/16 device or emulator: targetSdk 35+ enforces edge-to-edge, so check the status bar, gesture bar, dialogs, and the home-screen widget. |
| 2 | **Release signing** | Done — `android/key.properties` points at `C:/GitHub/key.jks` (alias `key`), and `flutter build appbundle --release` succeeds. | Enable Play App Signing when creating the app, and back up `C:/GitHub/key.jks` and its passwords somewhere safe. Never commit the keystore. |
| 3 | **App bundle** | Done — `build/app/outputs/bundle/release/app-release.aab` builds successfully (98.4 MB) | Rebuild after any final code change. Play does not accept APKs for new apps. |
| 4 | **Privacy policy URL** | Done — `https://malborne2.github.io/islamic_habits/privacy.html` is live | Paste that URL into Play Console → App content → Privacy policy. |
| 5 | **Contact email** | Done — `grapplinghook73@proton.me` | Shown on the listing and in the policy. |
| 6 | **Adhan audio rights** | Done — distribution rights confirmed | Keep the confirmation on file. |
| 7 | **OpenStreetMap attribution** | Done — visible in the map picker | Keep it visible in future UI changes. |
| 8 | **Play Console account** | In progress — account created; **waiting for identity verification** | Once verified, create the app entry and upload the AAB. If the account is personal and was created after 13 Nov 2023, plan the 12-tester / 14-day closed test. |

## Hosting the privacy policy on GitHub Pages

Done. The policy and landing page are in `docs/` and GitHub Pages is serving them from `master` → `/docs`.

- Privacy policy: `https://malborne2.github.io/islamic_habits/privacy.html`
- Landing page: `https://malborne2.github.io/islamic_habits/`

To update the policy, edit `docs/privacy.html`, commit, and push to `master`. Pages redeploys automatically within a minute or two. No custom domain is required. If you later rename the repository, the URL changes, so update it in Play Console.

## Build and versioning

- [ ] Set `version: 1.0.0+1` (or the intended release number) in `pubspec.yaml`; the `+N` build number must increase for every upload.
- [ ] Confirm `applicationId` is `dev.smoothchocolate.islamic_habits` and will never change after the first release.
- [ ] Run `flutter analyze` and fix anything new.
- [ ] Run `flutter test` if tests exist.
- [ ] Build: `flutter build appbundle --release`.
- [ ] Verify the `.aab` is signed with the upload key: `jarsigner -verify -verbose -certs build/app/outputs/bundle/release/app-release.aab`.
- [ ] Optionally upload native debug symbols for readable crash reports.

## Device testing

- [ ] Android 8/9 (minimum supported) — launch, reminders, widget.
- [ ] Android 12 — exact-alarm permission flow.
- [ ] Android 13 — notification permission prompt.
- [ ] Android 14 — exact alarm denied by default; fallback still fires.
- [ ] Android 15/16 — edge-to-edge layout after the targetSdk bump; check status bar, navigation bar, and widget.
- [ ] Place the widget, close the app, and confirm the countdown changes after a minute and the highlighted prayer moves at the prayer boundary.
- [ ] Test in English, Arabic (RTL), and at least one more locale.
- [ ] Test backup export and restore on a clean install.
- [ ] Test the map picker online and confirm the attribution label is visible.

## Play Console → App content

- [ ] Privacy policy URL saved.
- [ ] Ads declaration: **No ads**.
- [ ] App access: **All functionality available without restrictions**.
- [ ] Content rating questionnaire completed (see `content_rating.md`).
- [ ] Target audience: **13+**, not designed for families.
- [ ] Data safety completed (see `data_safety.md`).
- [ ] Government apps: **No**.
- [ ] Financial features: **No**.
- [ ] Health apps: **No**.
- [ ] News apps: **No**.
- [ ] Data deletion: not applicable (no server data); mention local deletion in the policy.

## Store presence

- [ ] App name, short description, and full description from `play_store_listing.md`.
- [ ] App icon `store/icon_512.png`.
- [ ] Feature graphic `store/feature_graphic_1024x500.png`.
- [ ] At least 2 phone screenshots from `store/screenshots/`.
- [ ] Optional: 7-inch and 10-inch tablet screenshots.
- [ ] Category: Lifestyle; tags filled.
- [ ] Contact email and website.
- [ ] Localized listings for Arabic, Urdu, Persian, and Indonesian (recommended).

## Pre-launch report

- [ ] Run the Play Console pre-launch report on at least one physical device.
- [ ] Fix accessibility warnings (content descriptions, tap targets, contrast).
- [ ] Check the startup time and any ANRs on a low-end device.
- [ ] Confirm the app does not crash when notifications are denied.
- [ ] Confirm the app still works with no internet connection (map picker excepted).

## Release

- [ ] Upload the `.aab` to **Internal testing** first.
- [ ] Install from the Play internal-testing link, not from a local APK.
- [ ] Promote to **Closed testing** (required for new personal accounts).
- [ ] After the required testing period, apply for **Production**.
- [ ] Roll out to 20% first; watch Android vitals for crashes and ANRs.
- [ ] Increase the rollout after 24–48 stable hours.

## Known follow-ups (not launch blockers)

- `pubspec.yaml` still has the default description ("A new Flutter application"); update it for repository hygiene.
- README does not yet mention the Tasbeeh screen, the home screen widget, or the new onboarding slide.
- The graphics generator is version-controlled at `store/tools/make_store_graphics.py`; re-run it after changing any screenshot or branding asset.
