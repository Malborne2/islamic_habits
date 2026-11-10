"""Build the per-language sembast demo database used for store screenshots.

The app stores habits in `app_flutter/demo.db` (sembast JSON-lines). Default
habit names are translated at display time, but custom habit names are shown
exactly as stored, so for localized screenshots the two adhkar habits are
seeded with translated names.

Usage:  python store/tools/seed_demo_db.py            # all languages
        python store/tools/seed_demo_db.py en ar      # selected languages
Output: build/demo_db/<lang>/demo.db
"""
import json
import os
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
BACKUP = os.path.join(ROOT, 'artifacts', 'demo_backup.json')
OUT_DIR = os.path.join(ROOT, 'build', 'demo_db')

DAY_MS = 86400000
TODAY = '2026-11-10'

ADHKAR_NAMES = {
    'en': ('Morning Adhkar', 'Evening Adhkar'),
    'ar': ('أذكار الصباح', 'أذكار المساء'),
    'nb': ('Morgen-adhkar', 'Kvelds-adhkar'),
    'ja': ('朝のズィクル', '夕方のズィクル'),
    'sv': ('Morgonadhkar', 'Kvällsadhkar'),
    'fi': ('Aamun adhkar', 'Illan adhkar'),
    'ur': ('صبح کے اذکار', 'شام کے اذکار'),
    'fa': ('اذکار صبح', 'اذکار شب'),
    'id': ('Zikir Pagi', 'Zikir Petang'),
}

# Which habits are already done "today", so the Today screen shows partial,
# believable progress instead of a spotless or empty day. Same for every
# language so the screenshots stay comparable.
TODAY_VALUES = {
    'Al Fajir Prayer': 1.0,
    'Al Dhuhr Prayer': 1.0,
    'Reciting the Quran': 14.0,
    'Morning Adhkar': 1.0,
}


def build(lang):
    with open(BACKUP, encoding='utf-8') as fh:
        backup = json.load(fh)

    morning, evening = ADHKAR_NAMES[lang]
    records = []
    key = 18
    for habit in backup['habits']:
        habit = dict(habit)
        if habit['name'] == 'Morning Adhkar':
            habit['name'] = morning
        elif habit['name'] == 'Evening Adhkar':
            habit['name'] = evening

        name = habit['name']
        done = TODAY_VALUES.get(
            'Morning Adhkar' if name == morning else
            'Evening Adhkar' if name == evening else name)

        habit['dataKeys'] = list(habit['dataKeys'])
        habit['habitData'] = list(habit['habitData'])
        habit['habitTimeStamp'] = list(habit['habitTimeStamp'])

        if done is not None:
            habit['dataKeys'].append(TODAY)
            habit['habitData'].append(done)
            habit['habitTimeStamp'].append(
                str(int(habit['habitTimeStamp'][-1]) + DAY_MS))

        records.append({'key': key, 'store': 'habits', 'value': habit})
        key += 1

    out = os.path.join(OUT_DIR, lang)
    os.makedirs(out, exist_ok=True)
    path = os.path.join(out, 'demo.db')
    with open(path, 'w', encoding='utf-8', newline='\n') as fh:
        fh.write('{"version":1,"sembast":1}\n')
        for rec in records:
            fh.write(json.dumps(rec, ensure_ascii=False) + '\n')
    return path


if __name__ == '__main__':
    langs = sys.argv[1:] or list(ADHKAR_NAMES)
    for lang in langs:
        print(lang, build(lang))
