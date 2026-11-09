# Publishing checklist — Islamic Habits

**Last updated:** 9 November 2026
**Store:** Google Play
**Package:** `com.islamic.habits`
**Privacy policy:** https://malborne2.github.io/islamic_habits/privacy.html
**Support email:** grapplinghook73@proton.me

## Status at a glance

| Area | Status |
| --- | --- |
| Build & signing | ✅ Ready |
| Store listing & graphics | ✅ Ready — 9 languages + screenshot/icon assets |
| Privacy policy & declarations | ✅ Drafted and hosted |
| Play Console setup | 🟡 Identity verified — create the app entry and upload |
| Tablet/large-screen layout | ✅ Responsive two-pane layout implemented |
| Habit reordering | ✅ Drag handle + arrow buttons in All habits |
| Release notes (9 languages) | ✅ Ready in `store/release_notes/` |
| Promo video | ✅ Recorded from the emulator with seeded demo data |
| Android 15/16 edge-to-edge check | ⬜ Not done — one device is enough |
| Closed testing (if required) | ⬜ Not started |
| Production release | ⬜ Not started |

---

## 1. Build and signing

- [x] `targetSdk 36` and `compileSdk 36`
- [x] Upload keystore at `C:/GitHub/key.jks` (alias `key`)
- [x] `android/key.properties` configured
- [x] `flutter build appbundle --release` succeeds
- [x] 16 KB page-size alignment verified
- [x] Release AAB builds (98.4 MB)
- [x] Back up the keystore and passwords somewhere safe
- [x] Build the final AAB with `versionCode 2` (`1.0.0+2`, adds habit reordering)
- [x] Package renamed to `com.islamic.habits` to match the Play Console app entry (AAB verified)

## 2. Store listing

- [x] App name: `Islamic Habits: Prayer & Quran`
- [x] Short description
- [x] Full description
- [x] Arabic listing copy
- [x] Urdu, Persian, and Indonesian listing copy
- [x] Finnish, Japanese, Norwegian, and Swedish listing copy
- [ ] Add all 9 languages to the Play store listing (required before release notes accept them)
- [x] 512×512 icon
- [x] 1024×500 feature graphic
- [x] 5 phone screenshots (1080×1920)
- [x] Contact email
- [x] Website / landing page
- [x] Privacy policy URL
- [x] Urdu, Persian, and Indonesian listings
- [x] Tablet-optimized layout (responsive home, stats, habit detail, Tasbeeh picker)
- [x] Release notes for all 9 languages (`store/release_notes/`, named by Play tag, plus `all_languages.txt`)
- [x] All-language copy-paste sheet (`store/play_console_copy_paste.md`): app name, short and full description for all 9 languages
- [x] Promo video recorded from the emulator with seeded demo data (`store/promo_video_720x1600.mp4`, 67 s, captioned)
- [ ] Upload the promo video to YouTube (public or unlisted) and paste the URL into the listing
- [ ] 7-inch and 10-inch tablet screenshots (optional)

## 3. Privacy and declarations

- [x] Privacy policy written
- [x] Privacy policy hosted on GitHub Pages
- [x] Contact email on the policy
- [x] Data safety answer key
- [x] Content rating answer key
- [x] Ads: No
- [x] App access: no login required
- [x] Target audience: 13+
- [ ] Enter all of the above into Play Console

## 4. Play Console setup

- [x] Create Google Play Developer account ($25 one-time)
- [ ] Complete identity verification — **in progress, waiting on Google**
- [ ] Create the app entry: name, package, default language, free
- [ ] Enable Play App Signing
- [ ] Upload the AAB to **Internal testing**
- [ ] Install from the internal-testing link and smoke test
- [ ] Complete **App content**: privacy policy, ads, access, content rating, target audience, data safety
- [ ] Fill the **Main store listing**
- [ ] Check account type and creation date
- [ ] If personal account created after 13 Nov 2023: recruit at least 12 testers
- [ ] Run **Closed testing** for 14 continuous days
- [ ] Apply for **Production** access
- [ ] Roll out to 20%, watch vitals, then increase

## 5. Device testing

> `targetSdk 36` is a behavior target, not a minimum OS. `minSdk 24` means the app installs on **Android 7.0 and newer**, so testers on older phones are fine. The Android 15/16 check is only about new OS behavior (mainly edge-to-edge), and one device or emulator covers it.

- [ ] Android 8/9 (minimum supported)
- [ ] Android 12 exact-alarm permission
- [ ] Android 13 notification permission
- [ ] Android 14 exact alarm denied by default
- [ ] Android 15/16 edge-to-edge layout — **one device is enough; other testers can use older versions**
- [ ] Widget countdown and next-prayer change with the app closed
- [ ] Arabic RTL layout
- [ ] Backup export and restore
- [ ] Map picker and OpenStreetMap attribution

## 6. Legal and rights

- [x] Confirm distribution rights for all 8 Adhan recordings
- [ ] GPLv3 compliance (source code is public)
- [ ] Decide what developer name/address will be public on Play
- [ ] EU DSA trader/non-trader declaration (if distributing in the EU)

## 7. After launch

- [ ] Add the Google Play link to the landing page
- [ ] Monitor Android vitals and reviews
- [ ] Plan the next release with `versionCode 2`

---

## Needs your input

- [ ] Play Console account type and creation date (personal vs organization)
- [ ] Public developer name/address you want shown
- [ ] Whether to add tablet screenshots for the store

## Current next action

**Create the app entry in Play Console** (`com.islamic.habits`), upload `build/app/outputs/bundle/release/app-release.aab` to Internal testing, then paste the nine listings from `store/play_console_copy_paste.md`. Upload `store/promo_video_720x1600.mp4` to YouTube first so the video URL is ready when you fill the main store listing.
