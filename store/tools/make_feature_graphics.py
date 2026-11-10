"""Render the 1024x500 Play Store feature graphic in every language.

Arabic/Persian/Urdu are reshaped with arabic-reshaper + python-bidi because
Pillow here has no Raqm/HarfBuzz shaping, and the composition is mirrored
(logo on the right, text right-aligned) for RTL languages.

Usage: python store/tools/make_feature_graphics.py [lang ...]
Output: store/feature_graphics/feature_graphic_<lang>_1024x500.png
        store/feature_graphic_1024x500.png (English copy, kept for compat)
"""
import os
import sys

from PIL import Image, ImageDraw, ImageFont

try:
    import arabic_reshaper
    from bidi.algorithm import get_display
except ImportError:  # only needed for the RTL graphics
    arabic_reshaper = None
    get_display = None

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
OUT = os.path.join(ROOT, 'store', 'feature_graphics')

NAVY = (15, 35, 71)
DEEP = (6, 13, 28)
ACCENT = (143, 179, 232)
SOFT = (200, 214, 236)

LATIN = 'segoeuib.ttf'
LATIN_REG = 'segoeui.ttf'
JP_BOLD = 'YuGothB.ttc'
JP_REG = 'YuGothM.ttc'

L10N = {
    'en': ('Islamic Habits', 'Prayer times  •  Quran  •  Daily habits',
           'Private by design. No account, no ads.', False, False),
    'ar': ('العادات الإسلامية', 'مواقيت الصلاة  •  القرآن  •  عادات يومية',
           'خصوصية بالتصميم. دون حساب أو إعلانات.', True, False),
    'fa': ('عادات اسلامی', 'اوقات نماز  •  قرآن  •  عادت‌های روزانه',
           'خصوصی از پایه. بدون حساب و تبلیغات.', True, False),
    'ur': ('اسلامی عادات', 'اوقاتِ نماز  •  قرآن  •  روزانہ عادات',
           'نجی اور محفوظ۔ نہ اکاؤنٹ، نہ اشتہارات۔', True, False),
    'id': ('Kebiasaan Islami', 'Waktu salat  •  Quran  •  Kebiasaan harian',
           'Privat sejak awal. Tanpa akun, tanpa iklan.', False, False),
    'ja': ('イスラムの習慣', '礼拝時刻・クルアーン・毎日の習慣',
           'プライバシー重視。アカウントも広告もなし。', False, True),
    'nb': ('Islamske vaner', 'Bønnetider  •  Koranen  •  Daglige vaner',
           'Privat av design. Ingen konto, ingen annonser.', False, False),
    'sv': ('Islamiska vanor', 'Bönetider  •  Koranen  •  Dagliga vanor',
           'Privat från början. Inget konto, inga annonser.', False, False),
    'fi': ('Islamilaiset tavat', 'Rukousajat  •  Koraani  •  Päivittäiset tavat',
           'Yksityinen suunnittelultaan. Ei tiliä, ei mainoksia.', False, False),
}


def shaped(text, rtl):
    if not rtl:
        return text
    return get_display(arabic_reshaper.reshape(text))


def load_font(name, size):
    return ImageFont.truetype(os.path.join('C:/Windows/Fonts', name), size)


def fit(draw, text, font_name, size, max_width, floor=18):
    """Largest size <= `size` whose single line fits `max_width`."""
    while size > floor:
        f = load_font(font_name, size)
        w = draw.textbbox((0, 0), text, font=f)[2]
        if w <= max_width:
            return f
        size -= 2
    return load_font(font_name, floor)


def render(lang):
    title, tag, sub, rtl, jp = L10N[lang]
    title, tag, sub = (shaped(t, rtl) for t in (title, tag, sub))

    bold = JP_BOLD if jp else LATIN
    reg = JP_REG if jp else LATIN_REG

    W, H = 1024, 500
    fg = Image.new('RGB', (W, H), DEEP)
    px = fg.load()
    for y in range(H):
        t = y / (H - 1)
        for x in range(W):
            u = (x / (W - 1) * 0.55 + t * 0.45)
            px[x, y] = (
                int(NAVY[0] * (1 - u) + DEEP[0] * u),
                int(NAVY[1] * (1 - u) + DEEP[1] * u),
                int(NAVY[2] * (1 - u) + DEEP[2] * u),
            )

    # Faint oversized logo as a geometric watermark, opposite the logo.
    mark = Image.open(os.path.join(ROOT, 'assets/branding/logo.png')).convert('RGBA')
    mark = mark.resize((560, 560), Image.LANCZOS)
    mark.putalpha(mark.split()[3].point(lambda a: int(a * 0.16)))
    fg.paste(mark, (-90 if rtl else W - 470, -30), mark)

    logo = Image.open(os.path.join(ROOT, 'assets/branding/logo.png')).convert('RGBA')
    logo = logo.resize((228, 228), Image.LANCZOS)
    logo_x = W - 66 - 228 if rtl else 66
    fg.paste(logo, (logo_x, 136), logo)

    draw = ImageDraw.Draw(fg)
    margin = 66
    if rtl:
        text_right = W - 332
        max_w = text_right - margin
    else:
        text_left = 332
        max_w = W - margin - text_left

    title_font = fit(draw, title, bold, 58, max_w)
    tag_font = fit(draw, tag, reg, 27, max_w)
    sub_font = fit(draw, sub, reg, 21, max_w)

    def put(text, font, y, fill):
        w = draw.textbbox((0, 0), text, font=font)[2]
        x = text_right - w if rtl else text_left
        draw.text((x, y), text, font=font, fill=fill)

    put(title, title_font, 168, (255, 255, 255))
    put(tag, tag_font, 248, ACCENT)
    put(sub, sub_font, 302, SOFT)

    os.makedirs(OUT, exist_ok=True)
    path = os.path.join(OUT, f'feature_graphic_{lang}_1024x500.png')
    fg.save(path)
    if lang == 'en':
        fg.save(os.path.join(ROOT, 'store', 'feature_graphic_1024x500.png'))
    return path


if __name__ == '__main__':
    for lang in (sys.argv[1:] or list(L10N)):
        print(render(lang))
