from PIL import Image, ImageDraw, ImageFilter, ImageFont
import os

os.makedirs('store/screenshots', exist_ok=True)

NAVY = (15, 35, 71)
DEEP = (6, 13, 28)
ACCENT = (143, 179, 232)

def font(name, size):
    path = os.path.join('C:/Windows/Fonts', name)
    return ImageFont.truetype(path, size)

# ---------- Icon ----------
icon = Image.open('assets/branding/logo_square.png').convert('RGBA')
if icon.size != (512, 512):
    icon = icon.resize((512, 512), Image.LANCZOS)
icon.save('store/icon_512.png')

# ---------- Feature graphic ----------
W, H = 1024, 500
fg = Image.new('RGB', (W, H), DEEP)
px = fg.load()
for y in range(H):
    t = y / (H - 1)
    for x in range(W):
        # Diagonal-ish gradient from top-left navy to bottom-right near-black.
        u = (x / (W - 1) * 0.55 + t * 0.45)
        r = int(NAVY[0] * (1 - u) + DEEP[0] * u)
        g = int(NAVY[1] * (1 - u) + DEEP[1] * u)
        b = int(NAVY[2] * (1 - u) + DEEP[2] * u)
        px[x, y] = (r, g, b)

# Faint oversized logo as a geometric watermark on the right.
mark = Image.open('assets/branding/logo.png').convert('RGBA')
mark = mark.resize((560, 560), Image.LANCZOS)
alpha = mark.split()[3].point(lambda a: int(a * 0.16))
mark.putalpha(alpha)
fg.paste(mark, (W - 470, -30), mark)

draw = ImageDraw.Draw(fg)
logo = Image.open('assets/branding/logo.png').convert('RGBA')
logo = logo.resize((228, 228), Image.LANCZOS)
fg.paste(logo, (66, 136), logo)

title_font = font('segoeuib.ttf', 58)
tag_font = font('segoeui.ttf', 27)
small_font = font('segoeui.ttf', 21)

draw.text((332, 168), 'Islamic Habits', font=title_font, fill=(255, 255, 255))
draw.text((334, 246), 'Prayer times  •  Quran  •  Daily habits',
          font=tag_font, fill=ACCENT)
draw.text((334, 300), 'Private by design. No account, no ads.',
          font=small_font, fill=(200, 214, 236))

fg.save('store/feature_graphic_1024x500.png')

# ---------- Phone screenshots ----------
shots = [
    ('today', 'assets/onboarding/today.png'),
    ('prayer_times', 'assets/onboarding/prayer_times.png'),
    ('tasbeeh', 'assets/onboarding/tasbeeh.png'),
    ('statistics', 'assets/onboarding/statistics.png'),
    ('add_habit', 'assets/onboarding/add_habit.png'),
]

TW, TH = 1080, 1920
for name, path in shots:
    src = Image.open(path).convert('RGB')

    # Blurred, darkened copy of the screenshot fills the 9:16 canvas so the
    # full screen stays visible without awkward letterboxing.
    scale = max(TW / src.width, TH / src.height)
    bg = src.resize((max(1, int(src.width * scale)), max(1, int(src.height * scale))),
                    Image.LANCZOS)
    left = (bg.width - TW) // 2
    top = (bg.height - TH) // 2
    bg = bg.crop((left, top, left + TW, top + TH))
    bg = bg.filter(ImageFilter.GaussianBlur(38))
    dark = Image.new('RGB', (TW, TH), (4, 8, 16))
    bg = Image.blend(bg, dark, 0.55)

    # Fit the untouched screenshot by height.
    fh = TH
    fw = int(src.width * fh / src.height)
    shot = src.resize((fw, fh), Image.LANCZOS)
    x = (TW - fw) // 2
    bg.paste(shot, (x, 0))
    bg.save('store/screenshots/%s_1080x1920.png' % name)

print('done')
