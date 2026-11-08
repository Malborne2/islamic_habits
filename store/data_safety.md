# Data safety declaration

Use this as the answer key for **Play Console → App content → Data safety**.

## Section 1 — Data collection and security

| Question | Answer |
| --- | --- |
| Does your app collect or share any of the required user data types? | **No** |
| Is all of the user data collected by your app encrypted in transit? | Not applicable — no user data is collected |
| Do you provide a way for users to request that their data is deleted? | Not applicable — no server-side data exists |

After answering **No** to collection, Play skips the data-type, purpose, and sharing questions. Do not add data types "just in case"; an inaccurate declaration is worse than a minimal one.

## Section 2 — Data types (if the form asks)

| Data type | Collected | Shared |
| --- | --- | --- |
| Personal info | No | No |
| Financial info | No | No |
| Health and fitness | No | No |
| Messages | No | No |
| Photos and videos | No | No |
| Audio | No | No |
| Files and docs | No | No |
| Calendar | No | No |
| Contacts | No | No |
| App activity | No | No |
| Web browsing | No | No |
| App info and performance | No | No |
| Device or other IDs | No | No |
| Location | No | No |

## Section 3 — Other declarations

| Question | Answer |
| --- | --- |
| Does the app contain ads? | **No** |
| Does the app use an advertising ID? | **No** |
| Is the app a news app? | **No** |
| Is the app a government app? | **No** |
| Does the app offer financial features? | **No** |
| Does the app provide health or medical functionality? | **No** |
| Is all functionality available without special access or login? | **Yes** |
| Target audience | **13+** (the app is suitable for all ages, but 13+ avoids Families-policy obligations) |

## Why this is accurate

- Habit data, prayer settings, coordinates, and tasbeeh counts are stored in app-private local storage and are never transmitted.
- Reminders are scheduled locally with `flutter_local_notifications`; there is no push server.
- Backups are user-initiated files; the app never uploads them.
- The only network traffic is OpenStreetMap tile requests in the optional map picker. Those requests carry an IP address and tile coordinates to the OpenStreetMap Foundation, not to the developer, and are disclosed in the privacy policy. No advertising, analytics, crash-reporting, or attribution SDK is included.
- `pubspec.yaml` contains no ad, analytics, or tracking packages.

## Permissions to be ready to explain

| Permission | Declaration |
| --- | --- |
| `POST_NOTIFICATIONS` | Core feature: prayer, Adhan, and habit reminders |
| `SCHEDULE_EXACT_ALARM` | Reminders must fire at the intended prayer/reminder minute |
| `RECEIVE_BOOT_COMPLETED` | Re-arm reminders after a device restart |
| `REQUEST_IGNORE_BATTERY_OPTIMIZATIONS` | Optional reliability prompt for time-sensitive reminders |
| `INTERNET` | Load OpenStreetMap tiles only while picking a location |

`REQUEST_IGNORE_BATTERY_OPTIMIZATIONS` and `SCHEDULE_EXACT_ALARM` are sensitive permissions. If Play review questions them, point to the in-app explanation on the Prayer settings screen and the privacy policy. If review still objects, replace the battery-optimization request with the system settings screen (`ACTION_IGNORE_BATTERY_OPTIMIZATION_SETTINGS`) instead of the direct request dialog.
