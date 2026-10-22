import 'package:flutter/widgets.dart';
import 'package:islamic_habits/utility/prayer_settings.dart';

// Per-locale display names for kAdhanVoices, keyed by voice id. A locale
// not covered here falls back to the voice's English displayName. Arabic,
// Urdu and Farsi show the reciter's name in Arabic script (as given on the
// original recordings); Japanese uses katakana; other locales keep the
// Latin transliteration already in displayName.
const Map<String, Map<String, String>> kAdhanVoiceNameTranslations = {
  'voice1': {
    'ar': 'أحمد الحداد (مصر)',
    'ur': 'احمد الحداد (مصر)',
    'fa': 'احمد الحداد (مصر)',
    'ja': 'アフマド・ハッダード(エジプト)',
  },
  'voice2': {
    'ar': 'طارق فتحي أحمد',
    'ur': 'طارق فتحی احمد',
    'fa': 'طارق فتحی احمد',
    'ja': 'ターリク・ファトヒ・アフマド',
  },
  'voice3': {
    'ar': 'حمزة المجالي',
    'ur': 'حمزہ المجالی',
    'fa': 'حمزه مجالی',
    'ja': 'ハムザ・マジャーリ',
  },
  'voice4': {
    'ar': 'أحمد الكوردي',
    'ur': 'احمد الکردی',
    'fa': 'احمد کردی',
    'ja': 'アフマド・クルディ',
  },
  'voice5': {
    'ar': 'رابح بن دارح الجزائري',
    'ur': 'رابح بن دارح الجزائری',
    'fa': 'رابح بن دارح الجزایری',
    'ja': 'ラベ・ベンダレ(アルジェリア)',
  },
  'voice6': {
    'ar': 'الحرم المدني',
    'ur': 'حرمِ مدنی',
    'fa': 'حرم مدنی',
    'ja': 'メディナ・ハラム',
  },
  'voice7': {
    'ar': 'نور الدين حمزة المغربي',
    'ur': 'نور الدین حمزہ المغربی',
    'fa': 'نورالدین حمزه مغربی',
    'ja': 'ヌールッディーン・ハムザ(モロッコ)',
  },
  'voice8': {
    'ar': 'محمد رمال (لبنان)',
    'ur': 'محمد رمال (لبنان)',
    'fa': 'محمد رمال (لبنان)',
    'ja': 'ムハンマド・ランマール(レバノン)',
  },
};

String localizedAdhanVoiceName(BuildContext context, AdhanVoiceOption voice) {
  final lang = Localizations.localeOf(context).languageCode;
  return kAdhanVoiceNameTranslations[voice.id]?[lang] ?? voice.displayName;
}
