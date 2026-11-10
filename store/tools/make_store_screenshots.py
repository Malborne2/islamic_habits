"""Frame the raw emulator captures as 1080x1920 Play Store screenshots.

Each raw screen is centred on a blurred, darkened copy of itself so the full
9:16 canvas is filled without cropping the UI.

Usage: python store/tools/make_store_screenshots.py [lang ...]
Input:  store/screenshots/raw/<lang>/<shot>.png
Output: store/screenshots/<lang>/<shot>_1080x1920.png
"""
import os
import time
import sys

from PIL import Image, ImageFilter

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
RAW = os.path.join(ROOT, 'store', 'screenshots', 'raw')
OUT = os.path.join(ROOT, 'store', 'screenshots')

LANGS = ['en', 'ar', 'nb', 'ja', 'sv', 'fi', 'ur', 'fa', 'id']
SHOTS = ['today', 'prayer_times', 'tasbeeh', 'statistics', 'add_habit']

TW, TH = 1080, 1920


def frame(src_path, dest_path):
    src = Image.open(src_path).convert('RGB')

    scale = max(TW / src.width, TH / src.height)
    bg = src.resize((max(1, int(src.width * scale)), max(1, int(src.height * scale))),
                    Image.LANCZOS)
    left = (bg.width - TW) // 2
    top = (bg.height - TH) // 2
    bg = bg.crop((left, top, left + TW, top + TH))
    bg = bg.filter(ImageFilter.GaussianBlur(38))
    bg = Image.blend(bg, Image.new('RGB', (TW, TH), (4, 8, 16)), 0.55)

    fh = TH
    fw = int(src.width * fh / src.height)
    shot = src.resize((fw, fh), Image.LANCZOS)
    bg.paste(shot, ((TW - fw) // 2, 0))

    # Windows occasionally refuses the direct write (antivirus/indexer holding
    # the file), so write beside it and swap in with retries.
    tmp_path = dest_path + '.tmp.png'
    bg.save(tmp_path)
    for attempt in range(10):
        try:
            os.replace(tmp_path, dest_path)
            return
        except OSError:
            time.sleep(0.4)
    raise OSError(f'could not write {dest_path}')


if __name__ == '__main__':
    for lang in (sys.argv[1:] or LANGS):
        dest_dir = os.path.join(OUT, lang)
        os.makedirs(dest_dir, exist_ok=True)
        for name in SHOTS:
            src = os.path.join(RAW, lang, f'{name}.png')
            if not os.path.exists(src):
                print('missing', src)
                continue
            frame(src, os.path.join(dest_dir, f'{name}_1080x1920.png'))
        print('framed', lang)
