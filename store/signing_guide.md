# Release signing guide

You need one **keystore** file and one **key.properties** file. The keystore holds the private key that signs your app; `key.properties` tells Gradle where the keystore is and which alias/passwords to use.

Do not commit either file. `android/key.properties` and `*.jks` / `*.keystore` are already in `.gitignore`.

## 1. Create the upload keystore

Open a terminal in the `android/` folder and run (PowerShell line continuation uses backticks):

```powershell
keytool -genkeypair -v `
  -keystore upload-keystore.jks `
  -storetype JKS `
  -keyalg RSA -keysize 2048 -validity 10000 `
  -alias upload
```

`keytool` ships with the JDK that Android Studio installs. If it is not on `PATH`, use the full path, for example:

```powershell
& "C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe" -genkeypair -v `
  -keystore upload-keystore.jks -storetype JKS `
  -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

You will be asked for:

- A **keystore password** (choose a strong one and store it in a password manager)
- Your name, organization, city, country (these appear in the certificate, not on the store listing)
- A **key password** for the `upload` alias (press Enter to reuse the keystore password)

Keep `upload-keystore.jks` somewhere safe and back it up. Losing it means you cannot upload updates with the same identity; Play App Signing can reset an upload key, but it is much easier to keep a backup.

## 2. Create android/key.properties

Create `android/key.properties` (use forward slashes in the path):

```properties
storePassword=YOUR_KEYSTORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=upload
storeFile=C:/Users/YourName/keys/upload-keystore.jks
```

If you prefer relative paths, `storeFile=../upload-keystore.jks` points at `android/upload-keystore.jks` when the keystore sits next to the `app/` folder.

`android/key.properties.example` is a template you can copy.

## 3. Verify the keystore

```powershell
keytool -list -v -keystore upload-keystore.jks -alias upload
```

You should see the alias, validity dates, and a SHA-256 fingerprint.

## 4. Build a signed bundle

```powershell
flutter build appbundle --release
```

The output is `build/app/outputs/bundle/release/app-release.aab`. Upload that file to Play Console. Do not upload an APK for a new app.

If the build fails because `key.properties` is missing, check that the file is at `android/key.properties` and that `storeFile` points at the real keystore.

## 5. Play App Signing

Google Play uses **Play App Signing**:

- Your `upload-keystore.jks` is the **upload key**. It signs the bundle you upload.
- Google holds the **app signing key** and re-signs the app before delivery to users.
- If the upload key is lost, you can request a reset in Play Console. The app signing key cannot be replaced as easily, which is why Google manages it.

When you create the app in Play Console, accept Play App Signing. If Play offers to generate an app signing key for you, that is fine for a new app.

## 6. Version numbers

Every upload needs a higher `versionCode`. In `pubspec.yaml`:

```yaml
version: 1.0.0+1
```

The part after `+` is the `versionCode` (1). Before the next upload, change it to `+2`, then `+3`, and so on. The part before `+` is the user-visible `versionName`.

## Checklist

- [ ] `upload-keystore.jks` created and backed up
- [ ] Passwords saved in a password manager
- [ ] `android/key.properties` created and not committed
- [ ] `flutter build appbundle --release` succeeds
- [ ] Play App Signing enabled in Play Console
- [ ] `versionCode` incremented for every upload
