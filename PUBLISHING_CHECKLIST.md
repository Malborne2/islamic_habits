# Publishing checklist — Islamic Habits

**Last updated:** 9 November 2026
**Store:** Google Play
**Package:** `dev.smoothchocolate.islamic_habits`
**Privacy policy:** https://malborne2.github.io/islamic_habits/privacy.html
**Support email:** grapplinghook73@proton.me

## Status at a glance

| Area | Status |
| --- | --- |
| Build & signing | ✅ Ready |
| Store listing & graphics | ✅ Ready |
| Privacy policy & declarations | ✅ Drafted and hosted |
| Play Console setup | 🟡 In progress — account created, waiting for identity verification |
| Tablet/large-screen layout | ✅ Responsive two-pane layout implemented |
| Habit reordering | ✅ Drag handle + arrow buttons in All habits |
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

## 2. Store listing

- [x] App name: `Islamic Habits: Prayer & Quran`
- [x] Short description
- [x] Full description
- [x] Arabic listing copy
- [x] Urdu, Persian, and Indonesian listing copy
- [x] 512×512 icon
- [x] 1024×500 feature graphic
- [x] 5 phone screenshots (1080×1920)
- [x] Contact email
- [x] Website / landing page
- [x] Privacy policy URL
- [x] Urdu, Persian, and Indonesian listings
- [x] Tablet-optimized layout (responsive home, stats, habit detail, Tasbeeh picker)
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

**Wait for identity verification.** Meanwhile, decide the public developer name/address and confirm whether the account type requires the 12-tester closed test. Once verified, create the app entry and upload the AAB to Internal testing.
