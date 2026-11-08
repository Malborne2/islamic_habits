# Store graphics

All generated assets live in `store/`.

| Asset | File | Spec | Status |
| --- | --- | --- | --- |
| App icon | `icon_512.png` | 512×512, 32-bit PNG, no transparency required | Ready |
| Feature graphic | `feature_graphic_1024x500.png` | 1024×500, JPEG or 24-bit PNG, no alpha | Ready |
| Phone screenshots | `screenshots/*_1080x1920.png` | 1080×1920, 9:16, 24-bit PNG | Ready (5) |
| 7-inch tablet screenshots | — | e.g. 1200×1920, 2–8 images | TODO (recommended) |
| 10-inch tablet screenshots | — | e.g. 1600×2560, 2–8 images | TODO (recommended) |
| Promo video | — | YouTube URL, optional | Optional |

## Screenshot set

| Order | File | Message |
| --- | --- | --- |
| 1 | `screenshots/today_1080x1920.png` | Your day at a glance |
| 2 | `screenshots/prayer_times_1080x1920.png` | Accurate prayer times, calculated on-device |
| 3 | `screenshots/tasbeeh_1080x1920.png` | A calm tasbeeh counter |
| 4 | `screenshots/statistics_1080x1920.png` | See your streaks and progress |
| 5 | `screenshots/add_habit_1080x1920.png` | Habits that fit your routine |

The source captures are 1344×2992 (2.23:1), which exceeds Play's 2:1 maximum. The build script fits each full screenshot into a 1080×1920 canvas with a blurred, darkened copy of the same screen filling the sides, so nothing is cropped and the aspect ratio is valid.

## Rules to keep in mind

- Phone screenshots: 2–8 images, minimum dimension 320 px, maximum 3840 px, aspect ratio between 1:2 and 2:1. 9:16 (1080×1920) is the safest choice.
- Feature graphic: must be exactly 1024×500 and must not contain transparency. Keep important content away from the edges because Play overlays UI in some placements.
- Icon: 512×512 PNG. Do not round the corners yourself; Play applies its own mask.
- No device frames, status-bar-only images, or misleading UI. The current screenshots are real app captures.
- If you add tablet screenshots, capture the same screens at tablet sizes rather than stretching phone images.

## Regenerating the graphics

The generator used for the icon, feature graphic, and phone screenshots is version-controlled at `store/tools/make_store_graphics.py`. Run it from the repository root:

```bash
python store/tools/make_store_graphics.py
```

It reads `assets/branding/logo.png`, `assets/branding/logo_square.png`, and `assets/onboarding/*.png`, then writes the files above.
