"""Capture the five store screenshots in every supported language.

Requires: rooted emulator with the release build of com.islamic.habits
installed, `adb` on PATH, and build/demo_db/<lang>/demo.db produced by
store/tools/seed_demo_db.py.

Usage: python store/tools/capture_screenshots.py [lang ...]

Writes store/screenshots/raw/<lang>/<shot>.png at native emulator
resolution (1344x2992 on the Pixel 8 Pro).
"""
import os
import subprocess
import sys
import time

PKG = 'com.islamic.habits'
ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
OUT = os.path.join(ROOT, 'store', 'screenshots', 'raw')
TMP = os.path.join(ROOT, 'build', 'screenshots_tmp')

LANGS = ['en', 'ar', 'nb', 'ja', 'sv', 'fi', 'ur', 'fa', 'id']
RTL = {'ar', 'ur', 'fa'}

# Drawer row centres (full-width rows, so the x stays valid in RTL too).
NAV = {
    'add_habit': 397,
    'today': 742,
    'prayer_times': 910,
    'tasbeeh': 1246,
    'statistics': 2836,
}
ROW_X = 672
MENU_Y = 235

PREFS = """<?xml version='1.0' encoding='utf-8' standalone='yes' ?>
<map>
    <long name="flutter.TasbeehGoal" value="99" />
    <string name="flutter.TasbeehPreset">afterPrayer</string>
    <boolean name="flutter.OnboardingCompleted" value="true" />
    <string name="flutter.LanguageCode">{lang}</string>
</map>
"""


def sh(cmd, capture=False):
    return subprocess.run(['adb', 'shell', cmd], check=True, text=True,
                          capture_output=capture).stdout


def tap(x, y):
    sh(f'input tap {x} {y}')
    time.sleep(1.2)


def back():
    sh('input keyevent 4')
    time.sleep(1.5)


def seed(lang):
    prefs = os.path.join(TMP, f'prefs_{lang}.xml')
    with open(prefs, 'w', encoding='utf-8') as fh:
        fh.write(PREFS.format(lang=lang))

    uid = sh(f'stat -c %u /data/data/{PKG}', capture=True).strip()
    sh(f'am force-stop {PKG}')
    subprocess.run(['adb', 'push', prefs, '/data/local/tmp/prefs.xml'],
                   check=True, capture_output=True)
    subprocess.run(['adb', 'push',
                    os.path.join(ROOT, 'build', 'demo_db', lang, 'demo.db'),
                    '/data/local/tmp/demo.db'], check=True, capture_output=True)
    sh(f'cp /data/local/tmp/prefs.xml /data/data/{PKG}/shared_prefs/FlutterSharedPreferences.xml')
    sh(f'cp /data/local/tmp/demo.db /data/data/{PKG}/app_flutter/demo.db')
    sh(f'chown {uid}:{uid} /data/data/{PKG}/shared_prefs/FlutterSharedPreferences.xml '
       f'/data/data/{PKG}/app_flutter/demo.db')
    sh(f'chmod 660 /data/data/{PKG}/shared_prefs/FlutterSharedPreferences.xml')
    sh(f'chmod 600 /data/data/{PKG}/app_flutter/demo.db')
    sh(f'am start -n {PKG}/.MainActivity')
    time.sleep(7)


def shot(lang, name):
    remote = f'/sdcard/{lang}_{name}.png'
    sh(f'screencap -p {remote}')
    dest = os.path.join(OUT, lang)
    os.makedirs(dest, exist_ok=True)
    subprocess.run(['adb', 'pull', remote, os.path.join(dest, f'{name}.png')],
                   check=True, capture_output=True)
    print('  captured', lang, name)


def open_drawer(lang):
    tap(1344 - 94 if lang in RTL else 94, MENU_Y)


def capture(lang):
    print('language', lang)
    seed(lang)
    menu_x = 1344 - 94 if lang in RTL else 94

    shot(lang, 'today')

    for name in ('prayer_times', 'tasbeeh', 'statistics', 'add_habit'):
        tap(menu_x, MENU_Y)
        time.sleep(1.0)
        tap(ROW_X, NAV[name])
        time.sleep(2.0)
        if name == 'tasbeeh':
            # 15 beads so the counter and its ring are not at zero.
            for _ in range(15):
                sh('input swipe 500 1300 800 1600 400')
                time.sleep(0.35)
            time.sleep(1.5)
        shot(lang, name)
        back()


if __name__ == '__main__':
    os.makedirs(TMP, exist_ok=True)
    for lang in (sys.argv[1:] or LANGS):
        capture(lang)
