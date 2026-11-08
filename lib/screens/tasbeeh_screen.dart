import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'dart:ui' as ui show Image;

import 'package:flutter/material.dart';
import 'package:islamic_habits/l10n/generated/app_localizations.dart';
import 'package:islamic_habits/utility/habit.dart';
import 'package:islamic_habits/utility/shared_prefrences_helper.dart';
import 'package:vibration/vibration.dart';

// A single phrase of dhikr: Arabic script, a Latin transliteration, and its
// English meaning. The Arabic text and transliteration stay the same in
// every locale (like the Adhan reciter names) — only the surrounding
// screen chrome is translated.
class _Dhikr {
  final String ar;
  final String tr;
  final String en;
  // Katakana reading, used only for Japanese — Arabic devotional phrases
  // are conventionally rendered this way rather than translated.
  final String ja;
  const _Dhikr(this.ar, this.tr, this.en, this.ja);

  // Which script a transliteration/subtitle line should use: Arabic script
  // for Arabic-alphabet locales (Arabic itself, Farsi, Urdu all share it),
  // Katakana for Japanese, and the Latin transliteration everywhere else.
  String display(String languageCode) {
    switch (languageCode) {
      case 'ar':
      case 'fa':
      case 'ur':
        return ar;
      case 'ja':
        return ja;
      default:
        return tr;
    }
  }
}

const _Dhikr _dSubhanallah = _Dhikr('سُبْحَانَ اللَّه', 'Subḥānallāh',
    'Glory be to Allah', 'スブハーナッラー');
const _Dhikr _dAlhamdulillah = _Dhikr('الْحَمْدُ لِلَّه', 'Alhamdulillāh',
    'Praise be to Allah', 'アルハムドゥリッラー');
const _Dhikr _dAllahuAkbar = _Dhikr('اللَّهُ أَكْبَر', 'Allāhu Akbar',
    'Allah is the Greatest', 'アッラーフ・アクバル');
const _Dhikr _dLaIlahaIllallah = _Dhikr(
    'لَا إِلَٰهَ إِلَّا اللَّه',
    'Lā ilāha illallāh',
    'There is no god but Allah',
    'ラー・イラーハ・イッラッラー');
const _Dhikr _dLaHawla = _Dhikr(
    'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّه',
    'Lā ḥawla wa lā quwwata illā billāh',
    'No power except with Allah',
    'ラー・ハウラ・ワラー・クウワタ・イッラー・ビッラー');

const _Dhikr _dSalawat = _Dhikr(
  'اللَّهُمَّ صَلِّ وَسَلِّمْ عَلَى نَبِيِّنَا مُحَمَّد',
  'Allāhumma ṣalli wa sallim ʿalā nabiyyinā Muḥammad',
  'O Allah, send prayers and peace upon our Prophet Muhammad',
  'アッラーフンマ・サッリ・ワサッリム・アラー・ナビイィナー・ムハンマド',
);
// "Al-Kalimatan" — the two phrases from the hadith "two words light on the
// tongue, heavy on the scale."
const _Dhikr _dKalimatan1 = _Dhikr(
  'سُبْحَانَ اللَّهِ وَبِحَمْدِه',
  'Subḥāna-llāhi wa biḥamdih',
  'Glory be to Allah, and praise be to Him',
  'スブハーナッラーヒ・ワビハムディヒ',
);
const _Dhikr _dKalimatan2 = _Dhikr(
  'سُبْحَانَ اللَّهِ الْعَظِيم',
  'Subḥāna-llāhil-ʿaẓīm',
  'Glory be to Allah, the Magnificent',
  'スブハーナッラーヒル・アズィーム',
);
const _Dhikr _dIstighfar = _Dhikr(
  'أَسْتَغْفِرُ اللَّهَ وَأَتُوبُ إِلَيْه',
  'Astaghfirullāha wa atūbu ilayh',
  'I seek forgiveness from Allah and repent to Him',
  'アスタグフィルッラーハ・ワアトゥーブ・イライヒ',
);
const _Dhikr _dDuaYunus = _Dhikr(
  'لَا إِلَٰهَ إِلَّا أَنْتَ سُبْحَانَكَ إِنِّي كُنْتُ مِنَ الظَّالِمِين',
  'Lā ilāha illā anta subḥānaka innī kuntu mina-ẓ-ẓālimīn',
  'There is no god but You; exalted are You. Indeed, I was among the wrongdoers.',
  'ラー・イラーハ・イッラー・アンタ・スブハーナカ・インニー・クントゥ・ミナッ=ザーリミーン',
);
const _Dhikr _dClosingAfterPrayer = _Dhikr(
  'لَا إِلَٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ '
      'الْحَمْدُ وَهُوَ عَلَىٰ كُلِّ شَيْءٍ قَدِير',
  'Lā ilāha illallāhu waḥdahū lā sharīka lah, lahu-l-mulku wa lahu-l-ḥamdu '
      'wa huwa ʿalā kulli shayʾin qadīr',
  'There is no god but Allah alone, with no partner. His is the dominion '
      'and His is the praise, and He has power over all things.',
  'ラー・イラーハ・イッラッラーフ・ワフダフ・ラー・シャリーカ・ラフ、ラフル・ムルク・'
      'ワラフル・ハムドゥ・ワフワ・アラー・クッリ・シャイィン・カディール',
);

// AppLocalizations.localeName is a canonicalized locale string (e.g. "en",
// "pt_BR") — this pulls out just the bare language code.
String _languageCode(AppLocalizations l10n) =>
    l10n.localeName.split(RegExp('[_-]')).first;

// One step in a tasbeeh preset: a phrase, and how many times it's said
// before moving to the next step. A null count means the step doesn't have
// a fixed length of its own — it either repeats forever (a single-step
// preset) or cycles with its siblings (a multi-step preset with no counts).
class _PresetStep {
  final _Dhikr dhikr;
  final int? count;
  const _PresetStep(this.dhikr, [this.count]);
}

// A selectable "kind" of tasbeeh: a short sequence of phrases (sometimes
// with a fixed count each), and an optional closing dua recited once the
// sequence completes.
class _TasbeehPreset {
  final String id;
  final String Function(AppLocalizations) titleKey;
  final List<_PresetStep> steps;
  final _Dhikr? closingDua;
  const _TasbeehPreset({
    required this.id,
    required this.titleKey,
    required this.steps,
    this.closingDua,
  });

  String title(AppLocalizations l10n) => titleKey(l10n);

  String subtitle(AppLocalizations l10n) {
    final lang = _languageCode(l10n);
    if (steps.length == 1) return steps.first.dhikr.display(lang);
    // Non-breaking spaces inside each "phrase ×count" unit keep it from
    // splitting mid-phrase when the subtitle wraps — only the separators
    // between units are allowed to break.
    return steps
        .map((s) {
          final word = s.dhikr.display(lang);
          final label = s.count != null ? '$word ×${s.count}' : word;
          return label.replaceAll(' ', ' ');
        })
        .join('  ·  ');
  }

  bool get _isSequential =>
      steps.length > 1 && steps.every((s) => s.count != null);

  int? get totalCount {
    if (!_isSequential) return null;
    return steps.fold<int>(0, (sum, s) => sum + s.count!);
  }

  _Dhikr dhikrForSeq(int seq) {
    if (steps.length == 1) return steps.first.dhikr;
    if (_isSequential) {
      int remaining = seq;
      for (final step in steps) {
        if (remaining < step.count!) return step.dhikr;
        remaining -= step.count!;
      }
      return steps.last.dhikr;
    }
    return steps[seq % steps.length].dhikr;
  }
}

final List<_TasbeehPreset> _kPresets = [
  _TasbeehPreset(
    id: 'afterPrayer',
    titleKey: (l10n) => l10n.tasbeehPresetAfterPrayerTitle,
    steps: const [
      _PresetStep(_dSubhanallah, 33),
      _PresetStep(_dAlhamdulillah, 33),
      _PresetStep(_dAllahuAkbar, 33),
    ],
    closingDua: _dClosingAfterPrayer,
  ),
  _TasbeehPreset(
    id: 'salawat',
    titleKey: (l10n) => l10n.tasbeehPresetSalawatTitle,
    steps: const [_PresetStep(_dSalawat)],
  ),
  _TasbeehPreset(
    id: 'kalimatan',
    titleKey: (l10n) => l10n.tasbeehPresetKalimatanTitle,
    steps: const [_PresetStep(_dKalimatan1), _PresetStep(_dKalimatan2)],
  ),
  _TasbeehPreset(
    id: 'istighfar',
    titleKey: (l10n) => l10n.tasbeehPresetIstighfarTitle,
    steps: const [_PresetStep(_dIstighfar)],
  ),
  _TasbeehPreset(
    id: 'duaYunus',
    titleKey: (l10n) => l10n.tasbeehPresetDuaYunusTitle,
    steps: const [_PresetStep(_dDuaYunus)],
  ),
  // What's traditionally called Al-Baqiyat As-Salihat: these five phrases
  // cycled through together, not the two-phrase "Kalimatan" above.
  _TasbeehPreset(
    id: 'baqiyat',
    titleKey: (l10n) => l10n.tasbeehPresetBaqiyatTitle,
    steps: const [
      _PresetStep(_dSubhanallah),
      _PresetStep(_dAlhamdulillah),
      _PresetStep(_dLaIlahaIllallah),
      _PresetStep(_dAllahuAkbar),
      _PresetStep(_dLaHawla),
    ],
  ),
];

// A bead color theme: the radial gradient stops, rim/glow accents, and the
// text color that keeps the Arabic legible on top of it. Blue/white/maroon/
// green are unlocked from the start; gold/amethyst unlock the same way the
// bead patterns do — by reaching a habit streak (unlockStreakDays, 0 = no
// lock).
class _BeadTheme {
  final String id;
  final List<Color> gradient;
  final Color rim;
  final Color glow;
  final Color textColor;
  final Color accent;
  final int unlockStreakDays;
  const _BeadTheme({
    required this.id,
    required this.gradient,
    required this.rim,
    required this.glow,
    required this.textColor,
    required this.accent,
    this.unlockStreakDays = 0,
  });
}

const List<_BeadTheme> _kBeadThemes = [
  _BeadTheme(
    id: 'blue',
    gradient: [
      Color(0xFFFFFFFF),
      Color(0xFFDFF4FF),
      Color(0xFF8FD9F4),
      Color(0xFF3A93C2),
      Color(0xFF123F5C),
    ],
    rim: Color(0xBBBFE9FF),
    glow: Color(0x704FB6E8),
    textColor: Color(0xFF06283F),
    accent: Color(0xFF7DD3FC),
  ),
  _BeadTheme(
    id: 'white',
    // Shaded a touch darker than pure white (more "polished pearl" than
    // paper-flat), with a cool grey rim/glow instead of white-on-white —
    // against this dark background a white glow blended into the bead
    // itself and all but vanished.
    gradient: [
      Color(0xFFFFFFFF),
      Color(0xFFF0F3F6),
      Color(0xFFD8DEE6),
      Color(0xFFAEB8C4),
      Color(0xFF7C8794),
    ],
    rim: Color(0xCCD8DEE6),
    glow: Color(0x708A93A3),
    textColor: Color(0xFF20262C),
    accent: Color(0xFFCCD5DE),
  ),
  _BeadTheme(
    id: 'maroon',
    gradient: [
      Color(0xFFFFFFFF),
      Color(0xFFD9A8AE),
      Color(0xFF93323E),
      Color(0xFF4F0F18),
      Color(0xFF200206),
    ],
    rim: Color(0xBBD9A8AE),
    glow: Color(0x70500810),
    textColor: Color(0xFF20040A),
    accent: Color(0xFF8E3340),
  ),
  _BeadTheme(
    id: 'green',
    gradient: [
      Color(0xFFFFFFFF),
      Color(0xFFDFF6E7),
      Color(0xFF8FD9AE),
      Color(0xFF32916A),
      Color(0xFF0D3C2D),
    ],
    rim: Color(0xBBC6F0D6),
    glow: Color(0x704FB68C),
    textColor: Color(0xFF07301F),
    accent: Color(0xFF7DD3A8),
  ),
  _BeadTheme(
    id: 'gold',
    unlockStreakDays: 14,
    gradient: [
      Color(0xFFFFFFFF),
      Color(0xFFFCEFCB),
      Color(0xFFE3C170),
      Color(0xFFA9792C),
      Color(0xFF5E3E10),
    ],
    rim: Color(0xBBF6E3B4),
    glow: Color(0x70C2982F),
    textColor: Color(0xFF3A2605),
    accent: Color(0xFFE3C170),
  ),
  _BeadTheme(
    id: 'amethyst',
    unlockStreakDays: 28,
    gradient: [
      Color(0xFFFFFFFF),
      Color(0xFFEBE0F7),
      Color(0xFFB79AE0),
      Color(0xFF6E469F),
      Color(0xFF3A225E),
    ],
    rim: Color(0xBBD9C7F2),
    glow: Color(0x708C5FC2),
    textColor: Color(0xFF1F1033),
    accent: Color(0xFFB79AE0),
  ),
];

// A decorative pattern drawn on top of every bead. Unlocked by keeping a
// habit streak going — a small gamification hook for returning users.
class _BeadPattern {
  final String id;
  final int unlockStreakDays;
  const _BeadPattern(this.id, this.unlockStreakDays);
}

// Boring, deliberately unflashy grey for every lock glyph in this screen —
// white got lost against the white bead theme's glow, this doesn't.
const Color _kLockIconColor = Color(0xFF9AA3AD);

// DEV ONLY: unlocks every color/pattern regardless of streak, for testing
// the gamification visuals without grinding habit streaks first. Flip back
// to false before shipping.
const bool _kDevUnlockAll = false;

const List<_BeadPattern> _kPatterns = [
  _BeadPattern('none', 0),
  _BeadPattern('rosette', 0),
  _BeadPattern('eightStar', 14),
  _BeadPattern('twelveStar', 28),
  _BeadPattern('octagonStar', 42),
  _BeadPattern('girihTiling', 56),
];

// A bead's resting state: how big, how far back (negative = further into
// the screen), how visible, and how soft-focused. Level 0 is the bead in
// front; higher levels recede into the dark behind it.
class _Level {
  final double scale;
  final double dy;
  final double opacity;
  final double blur;
  const _Level(this.scale, this.dy, this.opacity, this.blur);
}

const List<_Level> _kLevels = [
  _Level(1.00, 0, 1.00, 0),
  _Level(0.70, -58, 0.78, 1.2),
  _Level(0.47, -92, 0.50, 2.4),
  _Level(0.30, -118, 0.26, 3.8),
];
const _Level _kSpawnLevel = _Level(0.20, -132, 0, 5);

const double _kMaxDrag = 150;
const double _kThreshold = 92;

// A fixed, pre-seeded star field so the night-sky background stays calm
// (stars don't jump around on every rebuild) instead of regenerating
// randomly each frame.
class _Star {
  final double x;
  final double y;
  final double size;
  final double opacity;
  const _Star(this.x, this.y, this.size, this.opacity);
}

final List<_Star> _kStars = (() {
  final rnd = Random(1337);
  return List.generate(
    110,
    (_) => _Star(
      rnd.nextDouble(),
      rnd.nextDouble(),
      0.5 + rnd.nextDouble() * 1.5,
      0.2 + rnd.nextDouble() * 0.55,
    ),
  );
})();

class _StarsPainter extends CustomPainter {
  const _StarsPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (final star in _kStars) {
      paint.color = Colors.white.withValues(alpha: star.opacity);
      canvas.drawCircle(
          Offset(star.x * size.width, star.y * size.height), star.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _StarsPainter oldDelegate) => false;
}

class TasbeehScreen extends StatefulWidget {
  final List<Habit> habits;
  const TasbeehScreen({super.key, this.habits = const []});
  @override
  State<TasbeehScreen> createState() => _TasbeehScreenState();
}

class _Bead {
  final int id;
  final _Dhikr dhikr;
  _Bead(this.id, this.dhikr);
}

class _TasbeehScreenState extends State<TasbeehScreen>
    with TickerProviderStateMixin {
  int _count = 0;
  // null goal means "continuous" — count with no target and no celebration.
  int? _goal = 100;
  _TasbeehPreset _preset = _kPresets.last;
  // White pearl is the default look, with the always-unlocked rosette
  // medallion engraved on it. Saved preferences still win for returning users.
  _BeadTheme _theme = _kBeadThemes[1];
  String _patternId = 'rosette';
  int _maxStreakDays = 0;
  int _idSeq = 0;
  int _phraseSeq = 0;
  late List<_Bead> _queue;
  _Bead? _leaving;
  int _leavingId = -1;
  Offset _leavingDirection = const Offset(0, -1);

  bool _dragging = false;
  Offset _dragStart = Offset.zero;
  Offset _dragDelta = Offset.zero;

  bool _celebrating = false;
  Timer? _celebrateTimer;
  late final AnimationController _sparkController;
  List<Offset> _sparkTargets = const [];

  @override
  void initState() {
    super.initState();
    _maxStreakDays = widget.habits
        .fold<int>(0, (m, h) => max(m, h.getMaximumStreak()));
    _queue = List.generate(_kLevels.length, (_) => _nextBead());
    _sparkController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final results = await Future.wait([
      SharedPreferencesHelper.getTasbeehGoal(),
      SharedPreferencesHelper.getTasbeehPreset(),
      SharedPreferencesHelper.getTasbeehColor(),
      SharedPreferencesHelper.getTasbeehPattern(),
    ]);
    if (!mounted) return;
    final goal = results[0] as int?;
    final presetId = results[1] as String?;
    final colorId = results[2] as String?;
    final patternId = results[3] as String?;
    setState(() {
      if (goal != null) _goal = goal == -1 ? null : goal;
      if (presetId != null) {
        _preset = _kPresets.firstWhere((p) => p.id == presetId,
            orElse: () => _kPresets.last);
      }
      if (colorId != null) {
        _theme = _kBeadThemes.firstWhere((t) => t.id == colorId,
            orElse: () => _kBeadThemes.first);
      }
      if (patternId != null) _patternId = patternId;
      _phraseSeq = 0;
      _queue = List.generate(_kLevels.length, (_) => _nextBead());
    });
    // First time this screen is ever opened there's no saved preset yet —
    // open the picker right away instead of silently defaulting to one.
    if (presetId == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _showPresetPicker();
      });
    }
  }

  _Bead _nextBead() => _Bead(_idSeq++, _preset.dhikrForSeq(_phraseSeq++));

  void _setPreset(_TasbeehPreset preset) {
    setState(() {
      _preset = preset;
      _phraseSeq = 0;
      _count = 0;
      _leaving = null;
      _leavingId = -1;
      if (preset.totalCount != null) _goal = preset.totalCount;
      _queue = List.generate(_kLevels.length, (_) => _nextBead());
    });
    SharedPreferencesHelper.setTasbeehPreset(preset.id);
    if (preset.totalCount != null) {
      SharedPreferencesHelper.setTasbeehGoal(preset.totalCount!);
    }
  }

  @override
  void dispose() {
    _celebrateTimer?.cancel();
    _sparkController.dispose();
    super.dispose();
  }

  void _vibrate(int ms) async {
    try {
      if (await Vibration.hasVibrator()) Vibration.vibrate(duration: ms);
    } catch (_) {}
  }

  void _vibrateCelebrate() async {
    try {
      if (await Vibration.hasVibrator()) {
        Vibration.vibrate(pattern: [0, 30, 60, 30, 60, 120]);
      }
    } catch (_) {}
  }

  void _setGoal(int? goal) {
    setState(() => _goal = goal);
    SharedPreferencesHelper.setTasbeehGoal(goal ?? -1);
  }

  void _reset() {
    setState(() {
      _count = 0;
      _phraseSeq = 0;
      _leaving = null;
      _leavingId = -1;
      _queue = List.generate(_kLevels.length, (_) => _nextBead());
    });
  }

  void _advance(Offset direction) {
    final leavingBead = _queue.first;
    setState(() {
      _leaving = leavingBead;
      _leavingId = leavingBead.id;
      _leavingDirection = direction;
      _queue = [..._queue.skip(1), _nextBead()];
    });
    Future.delayed(const Duration(milliseconds: 520), () {
      if (!mounted) return;
      if (_leavingId == leavingBead.id) {
        setState(() {
          _leaving = null;
          _leavingId = -1;
        });
      }
    });
  }

  void _onPanStart(DragStartDetails d) {
    setState(() {
      _dragging = true;
      _dragStart = d.globalPosition;
      _dragDelta = Offset.zero;
    });
  }

  void _onPanUpdate(DragUpdateDetails d) {
    setState(() => _dragDelta = d.globalPosition - _dragStart);
  }

  void _onPanEnd(DragEndDetails d) {
    final dist = _dragDelta.distance;
    setState(() => _dragging = false);
    if (dist > _kThreshold) {
      final dir = Offset(_dragDelta.dx / dist, _dragDelta.dy / dist);
      _vibrate(20);
      final before = _count;
      setState(() => _count += 1);
      _advance(dir);
      if (_goal != null && before < _goal! && _count >= _goal!) _celebrate();
    }
    setState(() => _dragDelta = Offset.zero);
  }

  void _celebrate() {
    _vibrateCelebrate();
    final rnd = Random();
    _sparkTargets = List.generate(16, (_) {
      final angle = rnd.nextDouble() * pi - pi; // upward fan
      final dist = 60 + rnd.nextDouble() * 140;
      return Offset(cos(angle) * dist, -dist * (0.6 + rnd.nextDouble() * 0.6));
    });
    setState(() => _celebrating = true);
    _sparkController.forward(from: 0);
    _celebrateTimer?.cancel();
    _celebrateTimer = Timer(const Duration(milliseconds: 2600), () {
      if (mounted) setState(() => _celebrating = false);
    });
  }

  Future<void> _showPresetPicker() async {
    final selected = await showModalBottomSheet<_TasbeehPreset>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _PresetPickerSheet(current: _preset),
    );
    if (selected != null) _setPreset(selected);
  }

  Future<void> _showColorPicker() async {
    final selected = await showModalBottomSheet<_BeadTheme>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) =>
          _ColorPickerSheet(currentId: _theme.id, maxStreakDays: _maxStreakDays),
    );
    if (selected != null) {
      setState(() => _theme = selected);
      SharedPreferencesHelper.setTasbeehColor(selected.id);
    }
  }

  Future<void> _showPatternPicker() async {
    final selected = await showModalBottomSheet<_BeadPattern>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _PatternPickerSheet(
        currentId: _patternId,
        maxStreakDays: _maxStreakDays,
        theme: _theme,
      ),
    );
    if (selected != null) {
      setState(() => _patternId = selected.id);
      SharedPreferencesHelper.setTasbeehPattern(selected.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final mainPhrase = _queue.first.dhikr;

    return Scaffold(
      backgroundColor: const Color(0xFF02050C),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF02050C),
              Color(0xFF040A17),
              Color(0xFF081528),
              Color(0xFF0D1F3C),
            ],
            stops: [0.0, 0.4, 0.75, 1.0],
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(painter: const _StarsPainter()),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  _buildHeader(context, l10n),
                  Expanded(
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: LayoutBuilder(
                            builder: (context, constraints) => _buildStage(
                                context, constraints.biggest),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 70,
                          child: Column(
                            children: [
                              Text(
                                '${mainPhrase.display(_languageCode(l10n))} — ${mainPhrase.en}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFFB9D8EE),
                                    letterSpacing: .2),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 24,
                          child: Text(
                            l10n.tasbeehHint,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 12, color: Color(0xFF5F84A3)),
                          ),
                        ),
                        if (_celebrating) _buildCelebration(l10n),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
    final goal = _goal;
    final frac =
        goal == null || goal == 0 ? 0.0 : (_count / goal).clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              Expanded(
                child: Text(
                  l10n.navTasbeeh,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                width: 42,
                height: 42,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 42,
                      height: 42,
                      child: CircularProgressIndicator(
                        value: goal == null ? 1.0 : frac,
                        strokeWidth: 3.5,
                        backgroundColor: const Color(0xFF1C3F61),
                        valueColor: AlwaysStoppedAnimation(goal == null
                            ? const Color(0xFF2D5986)
                            : _theme.accent),
                      ),
                    ),
                    Text('$_count',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            fontFeatures: [FontFeature.tabularFigures()])),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(999),
                    onTap: _showPresetPicker,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0x330A1F3A),
                        border: Border.all(color: const Color(0xFF2D5986)),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.swap_horiz_rounded,
                              size: 16, color: Color(0xFF9FC3DE)),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              _preset.title(l10n),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _HeaderIconButton(
                  icon: Icons.palette_rounded,
                  color: _theme.accent,
                  onTap: _showColorPicker,
                ),
                const SizedBox(width: 8),
                _HeaderIconButton(
                  icon: Icons.texture_rounded,
                  color: const Color(0xFF9FC3DE),
                  onTap: _showPatternPicker,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                ...[33, 100, 1000, null].map((g) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _GoalChip(
                        label: g == null ? '∞' : '$g',
                        selected: _goal == g,
                        accent: _theme.accent,
                        onTap: () => _setGoal(g),
                      ),
                    )),
                const Spacer(),
                TextButton(
                  onPressed: _reset,
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF9FC3DE),
                    side: const BorderSide(color: Color(0xFF2D5986)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                  ),
                  child: Text(l10n.tasbeehReset,
                      style: const TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStage(BuildContext context, Size size) {
    // Sized relative to the available width rather than a fixed constant —
    // 0.45 of the width lands at 180 on a ~400dp-wide phone, 20% bigger
    // than the old fixed 150, and scales up or down with the screen.
    final beadSize = (size.width * 0.45).clamp(150.0, 260.0);
    final anchor = Offset(size.width / 2, size.height * 0.34);
    final beads = <Widget>[];

    // Back-to-front so the front bead paints on top.
    final renderList = [
      if (_leaving != null) _leaving!,
      ..._queue,
    ];
    for (final bead in renderList.reversed) {
      final isLeaving = bead.id == _leavingId;
      final queueIndex = _queue.indexWhere((b) => b.id == bead.id);
      final isMain = !isLeaving && queueIndex == 0;
      final level = isLeaving
          ? _kLevels[0]
          : (queueIndex >= 0 && queueIndex < _kLevels.length
              ? _kLevels[queueIndex]
              : _kSpawnLevel);
      final phrase = bead.dhikr;

      Offset offset = Offset(0, level.dy);
      double scale = level.scale;
      double opacity = level.opacity;

      if (isMain && _dragging) {
        final dist = _dragDelta.distance;
        final rubber =
            dist == 0 ? 0.0 : _kMaxDrag * (1 - exp(-dist / _kMaxDrag));
        final k = dist == 0 ? 0.0 : rubber / dist;
        offset = Offset(_dragDelta.dx * k, _dragDelta.dy * k);
        scale = 1 + rubber / 700;
      }
      if (isLeaving) {
        offset = _leavingDirection * 220;
        scale = 1.5;
        opacity = 0;
      }

      beads.add(
        AnimatedPositioned(
          key: ValueKey('pos-${bead.id}'),
          duration: (isMain && _dragging)
              ? Duration.zero
              : (isLeaving
                  ? const Duration(milliseconds: 480)
                  : const Duration(milliseconds: 500)),
          curve: Curves.easeOutCubic,
          left: anchor.dx - beadSize / 2 + offset.dx,
          top: anchor.dy - beadSize / 2 + offset.dy,
          width: beadSize,
          height: beadSize,
          child: IgnorePointer(
            child: AnimatedScale(
              scale: scale,
              duration: (isMain && _dragging)
                  ? Duration.zero
                  : const Duration(milliseconds: 500),
              curve: Curves.easeOutCubic,
              child: AnimatedOpacity(
                opacity: opacity,
                duration: isLeaving
                    ? const Duration(milliseconds: 400)
                    : const Duration(milliseconds: 500),
                // RepaintBoundary around the bead's full visual content
                // (gradient, AO, glow, specular highlights, pattern, text)
                // so Flutter rasterizes it once into its own layer. Without
                // this, every frame of the position/scale/opacity/blur
                // animations above was forcing a full repaint of every
                // gradient and box-shadow on every visible bead — this was
                // the real remaining cost after caching just the pattern
                // geometry; the cached layer now gets cheaply transformed
                // and blurred instead of redrawn from scratch each frame.
                child: _maybeBlur(
                  level.blur,
                  RepaintBoundary(
                    child: _Bead3D(
                      arabic: phrase.ar,
                      theme: _theme,
                      patternId: _patternId,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Stack(
      children: [
        ...beads,
        Positioned(
          left: anchor.dx - beadSize * 0.633,
          top: anchor.dy - beadSize * 0.633,
          width: beadSize * 1.267,
          height: beadSize * 1.267,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onPanStart: _onPanStart,
            onPanUpdate: _onPanUpdate,
            onPanEnd: _onPanEnd,
          ),
        ),
      ],
    );
  }

  Widget _maybeBlur(double sigma, Widget child) {
    if (sigma <= 0) return child;
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
      child: child,
    );
  }

  Widget _buildCelebration(AppLocalizations l10n) {
    final dua = _preset.closingDua;
    return Positioned.fill(
      child: AnimatedOpacity(
        opacity: _celebrating ? 1 : 0,
        duration: const Duration(milliseconds: 500),
        child: Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0, -0.1),
              radius: 0.9,
              colors: [
                Color(0xFF241A08),
                Color(0xCC02050C),
                Color(0xFF02050C),
              ],
              stops: [0.0, 0.55, 1.0],
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedBuilder(
                animation: _sparkController,
                builder: (context, _) {
                  final t = _sparkController.value;
                  return Stack(
                    children: [
                      for (int i = 0; i < _sparkTargets.length; i++)
                        Builder(builder: (context) {
                          final target = _sparkTargets[i];
                          final eased = Curves.easeOutCubic.transform(t);
                          final pos = target * eased;
                          final fade = (1 - t).clamp(0.0, 1.0);
                          return Positioned(
                            left: MediaQuery.of(context).size.width / 2 +
                                pos.dx -
                                3,
                            top: MediaQuery.of(context).size.height / 2 +
                                pos.dy -
                                3,
                            child: Opacity(
                              opacity: fade,
                              child: Container(
                                width: 5,
                                height: 5,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFFBD38D),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Color(0x99F6C453),
                                        blurRadius: 8,
                                        spreadRadius: 2),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                    ],
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      dua?.ar ?? 'تَقَبَّلَ اللَّه',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: dua != null ? 22 : 32,
                          height: 1.5,
                          color: const Color(0xFFF6C453),
                          shadows: const [
                            Shadow(color: Color(0x99F6C453), blurRadius: 24),
                          ]),
                    ),
                    if (dua != null && dua.display(_languageCode(l10n)) != dua.ar) ...[
                      const SizedBox(height: 8),
                      Text(dua.display(_languageCode(l10n)),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 12, color: Color(0xFFD9BE87))),
                    ],
                    const SizedBox(height: 10),
                    Text(l10n.tasbeehGoalReached,
                        style: const TextStyle(
                            fontSize: 13, color: Color(0xFF9FC3DE))),
                    const SizedBox(height: 22),
                    OutlinedButton(
                      onPressed: () => setState(() => _celebrating = false),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFF6C453),
                        side: const BorderSide(color: Color(0x88F6C453)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                      ),
                      child: Text(l10n.tasbeehKeepGoing),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// A bead rendered as a solid glowing sphere with its dhikr word on it —
// deliberately opaque (a bright rim plus a non-near-black outer gradient
// stop) so it still reads as a solid object even blurred far in the back,
// rather than fading into the night-sky background behind it.
// Everything about a bead except its dhikr text — gradient, glow, rim,
// ambient occlusion, both specular highlights, contact shadow and the
// tiling pattern — is fully determined by (patternId, theme), never
// changes while a bead is on screen, and used to be rebuilt as ~8 nested
// widgets with 3 separate blur passes (2 ImageFiltered + the box-shadow
// blurs) EVERY animation frame. The reason RepaintBoundary alone didn't
// fix the swipe slowdown: Flutter's engine-level layer cache deliberately
// refuses to cache a layer whose transform is actively changing — which
// is exactly what AnimatedScale does to every bead for the full 500ms of
// a swipe/advance. So during the one moment it needed to be cheap, the
// cache was never in play. The fix is to not depend on that cache at
// all: bake the whole static visual into a real `ui.Image` once per
// (pattern, theme) combination, then every frame just blits that texture
// with `drawImageRect` — trivial for any GPU regardless of how the scale/
// opacity/blur around it is animating.
class _BeadSprite {
  // Reference circle diameter the sprite is baked at, plus padding on
  // every side to capture the glow/contact-shadow blur bleeding past the
  // circle's own edge (BoxShadow isn't clipped to its widget's bounds).
  static const double core = 260;
  static const double pad = 80;
  static const double canvasSize = core + pad * 2;

  // Keyed by pattern+theme so every bead sharing a look reuses the same
  // bake. Caching the Future itself (not just the eventual Image) means
  // concurrent requests for the same key — several beads mounting in the
  // same frame — share one bake instead of racing to start their own.
  static final Map<String, Future<ui.Image>> _cache = {};

  static String _key(String patternId, _BeadTheme theme) =>
      '$patternId|${theme.id}';

  // `Picture.toImageSync` rasterizes on the calling thread — baking three
  // large Gaussian-blurred circles that way blocked the UI thread long
  // enough to trip Android's ANR watchdog (worse yet on the software-GL
  // emulator this was first caught on, and exactly the low-end-hardware
  // case this whole fix is for). `toImage` does the same rasterization
  // off the UI thread instead, so the app stays responsive while it bakes
  // — a one-time cost per pattern+theme, never paid again afterward.
  static Future<ui.Image> of(String patternId, _BeadTheme theme) =>
      _cache.putIfAbsent(_key(patternId, theme), () {
        final recorder = PictureRecorder();
        final canvas = Canvas(recorder);
        _paint(canvas, patternId, theme);
        final picture = recorder.endRecording();
        return picture.toImage(canvasSize.round(), canvasSize.round());
      });

  static void _paint(Canvas canvas, String patternId, _BeadTheme theme) {
    const center = Offset(canvasSize / 2, canvasSize / 2);
    const r = core / 2;

    // The three BoxShadow layers the old Container decoration used, in
    // the same back-to-front order: glow, rim, contact shadow — all
    // painted before the circle itself, exactly like BoxDecoration does.
    canvas.drawCircle(
        center,
        r + 8,
        Paint()
          ..color = theme.glow
          ..maskFilter =
              MaskFilter.blur(BlurStyle.normal, Shadow.convertRadiusToSigma(34)));
    canvas.drawCircle(center, r + 2, Paint()..color = theme.rim);
    canvas.drawCircle(
        center + const Offset(0, 10),
        r,
        Paint()
          ..color = Colors.black.withValues(alpha: .35)
          ..maskFilter =
              MaskFilter.blur(BlurStyle.normal, Shadow.convertRadiusToSigma(18)));

    // Base gradient — the tighter highlight falloff (vs. an even 0/0.12/
    // 0.38/0.66/1.0 spread) reads as a glossier, more curved surface: the
    // bright spot stays small and mid-tones compress quickly into shadow,
    // like light wrapping a sphere instead of a flat radial fade.
    final circleRect = Rect.fromCircle(center: center, radius: r);
    final baseGradient = RadialGradient(
      center: const Alignment(-0.32, -0.48),
      radius: 1.05,
      colors: theme.gradient,
      stops: const [0.0, 0.07, 0.24, 0.58, 1.0],
    );
    canvas.drawCircle(
        center, r, Paint()..shader = baseGradient.createShader(circleRect));

    canvas.save();
    canvas.clipPath(Path()..addOval(circleRect));

    // Ambient-occlusion ring: darkens the rim uniformly on top of the base
    // gradient, selling curvature further out where the highlight
    // gradient alone goes flat.
    final aoGradient = RadialGradient(
      center: const Alignment(-0.1, -0.2),
      colors: [Colors.transparent, Colors.black.withValues(alpha: .28)],
      stops: const [0.68, 1.0],
    );
    canvas.drawRect(
        circleRect, Paint()..shader = aoGradient.createShader(circleRect));

    // Primary specular highlight — a small, tight hot-spot where a glossy
    // sphere would catch the light source directly.
    final primaryCenter = center +
        const Offset(-0.46 * r, -0.64 * r);
    final primaryRect = Rect.fromCenter(
        center: primaryCenter, width: 0.24 * core, height: 0.16 * core);
    canvas.drawOval(
        primaryRect,
        Paint()
          ..shader = RadialGradient(colors: [
            Colors.white.withValues(alpha: .37),
            Colors.white.withValues(alpha: 0),
          ]).createShader(primaryRect)
          ..imageFilter = ImageFilter.blur(sigmaX: 4, sigmaY: 4));

    // Secondary bounce highlight — dim, tinted with the theme's own accent
    // rather than white, as if light reflected off a nearby bead. Two
    // highlights read as "glossy curved surface"; one reads as "flat
    // shine painted on top".
    final secondaryCenter = center + const Offset(0.58 * r, 0.5 * r);
    final secondaryRect = Rect.fromCenter(
        center: secondaryCenter, width: 0.26 * core, height: 0.16 * core);
    canvas.drawOval(
        secondaryRect,
        Paint()
          ..shader = RadialGradient(colors: [
            theme.accent.withValues(alpha: .5),
            theme.accent.withValues(alpha: 0),
          ]).createShader(secondaryRect)
          ..imageFilter = ImageFilter.blur(sigmaX: 7, sigmaY: 7));

    // The tiling pattern, offset into the padded canvas.
    canvas.save();
    canvas.translate(pad, pad);
    _PatternPainter._drawPattern(
        canvas, const Size(core, core), patternId, theme.rim);
    canvas.restore();

    canvas.restore();
  }
}

class _SpritePainter extends CustomPainter {
  final ui.Image image;
  const _SpritePainter(this.image);

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / _BeadSprite.core;
    final dst = Rect.fromCenter(
      center: size.center(Offset.zero),
      width: image.width * scale,
      height: image.height * scale,
    );
    final src =
        Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
    canvas.drawImageRect(
        image, src, dst, Paint()..filterQuality = FilterQuality.medium);
  }

  @override
  bool shouldRepaint(covariant _SpritePainter oldDelegate) =>
      oldDelegate.image != image;
}

// A trivial, instant placeholder shown only for the brief one-time gap
// before a pattern+theme's sprite finishes baking — no gradient shader,
// no blur, just a flat fill, so there's never a reason for this one to be
// slow.
class _FallbackCirclePainter extends CustomPainter {
  final _BeadTheme theme;
  const _FallbackCirclePainter(this.theme);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(size.center(Offset.zero), size.width / 2,
        Paint()..color = theme.gradient[2]);
  }

  @override
  bool shouldRepaint(covariant _FallbackCirclePainter oldDelegate) =>
      oldDelegate.theme != theme;
}

class _Bead3D extends StatelessWidget {
  final String arabic;
  final _BeadTheme theme;
  final String patternId;
  const _Bead3D(
      {required this.arabic, required this.theme, required this.patternId});

  @override
  Widget build(BuildContext context) {
    return Stack(
      // The sprite's glow/contact-shadow bleed past this box on purpose
      // (padded into the baked image), same as the BoxShadow it replaces
      // did — don't let the Stack's own clip cut that off.
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          // The bake is async now (see _BeadSprite.of), so there's a
          // brief gap — once per pattern+theme, ever — before the real
          // sprite is ready. A flat themed circle in the meantime beats
          // either a blank frame or blocking the UI thread to avoid one.
          child: FutureBuilder<ui.Image>(
            future: _BeadSprite.of(patternId, theme),
            builder: (context, snapshot) {
              final image = snapshot.data;
              return CustomPaint(
                painter: image != null
                    ? _SpritePainter(image)
                    : _FallbackCirclePainter(theme),
              );
            },
          ),
        ),
        Positioned.fill(
          child: LayoutBuilder(
            builder: (context, constraints) {
              // A square inscribed in the circle (side ≈ diameter/√2) so a
              // long phrase like the Dua of Yunus wraps and, if it's still
              // too tall, gets scaled down by FittedBox — never spilling
              // past the bead's edge — while short phrases stay full size.
              final inscribed = constraints.maxWidth * 0.7;
              // An embossed look: a light highlight above-left and a dark
              // depth shadow below-right, so the word reads as carved into
              // the bead rather than painted flat on top of it — works
              // across every pattern without needing a fixed outline hue.
              // Scales with the bead's own (responsive) size instead of a
              // flat constant, so the word is as large as the bead allows
              // — FittedBox's scaleDown still catches anything that still
              // doesn't fit (the Dua of Yunus, say) without this growing
              // unbounded.
              final fontSize = (inscribed * 0.29).clamp(26.0, 54.0);
              final textStyle = TextStyle(
                fontSize: fontSize,
                height: 1.25,
                fontWeight: FontWeight.w800,
                color: theme.textColor,
                shadows: [
                  Shadow(
                      color: Colors.white.withValues(alpha: .55),
                      offset: const Offset(-0.6, -0.6)),
                  Shadow(
                      color: Colors.black.withValues(alpha: .4),
                      offset: const Offset(0.9, 1.2),
                      blurRadius: 1),
                ],
              );
              // A thin outline in the bead's own accent color (already
              // tuned per-theme to read well against that gradient) behind
              // the fill text, so busy patterns don't swallow the word —
              // matches the bead instead of a fixed color that clashed on
              // some themes (gold on purple, for instance).
              final outlineStyle = textStyle.copyWith(
                color: null,
                shadows: null,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = inscribed * 0.0144
                  ..color = theme.accent.withValues(alpha: .95),
              );
              return Center(
                child: SizedBox(
                  width: inscribed,
                  height: inscribed,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: SizedBox(
                      width: inscribed,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Text(
                            arabic,
                            textAlign: TextAlign.center,
                            style: outlineStyle,
                          ),
                          Text(
                            arabic,
                            textAlign: TextAlign.center,
                            style: textStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// Alternating outer/inner-radius points of an n-point star, centered at
// (cx, cy) — the same "points in contact" construction used for every
// star-based pattern below: place these on a lattice at spacing ==
// outerR*2 and neighboring stars' points land exactly between lattice
// cells, interlocking without any separate connector logic.
List<Offset> _starPts(
    double cx, double cy, int n, double outerR, double innerR, double rot) {
  final pts = <Offset>[];
  for (var i = 0; i < n * 2; i++) {
    final ang = (i / (n * 2)) * 2 * pi + rot;
    final r = i.isEven ? outerR : innerR;
    pts.add(Offset(cx + cos(ang) * r, cy + sin(ang) * r));
  }
  return pts;
}

// Equal-radius n-gon points (a regular polygon, not a star).
List<Offset> _ngonPts(double cx, double cy, int n, double r, double rot) {
  final pts = <Offset>[];
  for (var i = 0; i < n; i++) {
    final ang = (i / n) * 2 * pi + rot;
    pts.add(Offset(cx + cos(ang) * r, cy + sin(ang) * r));
  }
  return pts;
}

void _drawPoly(Canvas canvas, List<Offset> pts, Color? fill, Color? stroke,
    double strokeWidth) {
  final path = Path()..addPolygon(pts, true);
  if (fill != null) {
    canvas.drawPath(path, Paint()..color = fill);
  }
  if (stroke != null) {
    canvas.drawPath(
        path,
        Paint()
          ..color = stroke
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth);
  }
}

// Simple geometric motifs painted inside a bead's circle: a single rosette
// medallion, or one of several seamless Islamic star tilings repeated
// across the bead (points-in-contact method, from the pattern lab).
class _PatternPainter extends CustomPainter {
  final String id;
  final Color color;
  const _PatternPainter(this.id, this.color);

  // The tiling patterns (eightStar/twelveStar/octagonStar/girihTiling) draw
  // dozens of trig-heavy Paths per bead. Beads resize every frame while
  // animating (receding/approaching in the queue), and CustomPaint repaints
  // whenever its `size` changes — so without caching, every one of those
  // Paths was being rebuilt from scratch on every single animation frame,
  // for every visible bead. Instead, each distinct (pattern, color) is
  // rendered once into a `Picture` at a fixed reference size and cached;
  // paint() then only scales and replays that recording, which is cheap
  // regardless of how often the bead's on-screen size changes.
  static const double _kRefSize = 260;
  static final Map<String, Picture> _pictureCache = {};

  static String _cacheKey(String id, Color color) =>
      '$id|${color.a}|${color.r}|${color.g}|${color.b}';

  static Picture _buildPicture(String id, Color color) {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    _drawPattern(canvas, const Size(_kRefSize, _kRefSize), id, color);
    return recorder.endRecording();
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (id == 'none') return;
    final picture = _pictureCache.putIfAbsent(
        _cacheKey(id, color), () => _buildPicture(id, color));
    final scale = size.width / _kRefSize;
    canvas.save();
    canvas.scale(scale);
    canvas.drawPicture(picture);
    canvas.restore();
  }

  static void _drawPattern(Canvas canvas, Size size, String id, Color color) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;
    switch (id) {
      case 'rosette':
        // A 10-fold radial medallion: one petal wedge of nested arcs,
        // stamped around the center — the tightest-reading Islamic motif
        // at bead scale, from the pattern lab (N=10, density=4).
        const n = 10;
        const petals = 4;
        final linePaint = Paint()
          ..color = color.withValues(alpha: .85)
          ..style = PaintingStyle.stroke
          ..strokeWidth = radius * 0.03;
        canvas.save();
        canvas.translate(center.dx, center.dy);
        for (var i = 0; i < n; i++) {
          canvas.save();
          canvas.rotate((i / n) * 2 * pi);
          for (var p = 1; p <= petals; p++) {
            final rr = radius * (p / petals);
            final path = Path()
              ..moveTo(0, -rr)
              ..quadraticBezierTo(rr * 0.42, -rr * 0.62, 0, -radius * 0.14)
              ..quadraticBezierTo(-rr * 0.42, -rr * 0.62, 0, -rr);
            canvas.drawPath(path, linePaint);
          }
          final spokePaint = Paint()
            ..color = color.withValues(alpha: .33)
            ..style = PaintingStyle.stroke
            ..strokeWidth = radius * 0.03;
          canvas.drawLine(
              Offset(0, -radius * 0.12), Offset(0, -radius), spokePaint);
          canvas.restore();
        }
        final corePaint = Paint()
          ..color = color.withValues(alpha: .9)
          ..style = PaintingStyle.stroke
          ..strokeWidth = radius * 0.03;
        for (var rr = radius * 0.12; rr < radius * 0.22; rr += radius * 0.05) {
          canvas.drawCircle(Offset.zero, rr, corePaint);
        }
        canvas.restore();
        break;
      case 'eightStar':
        // Classic "star and cross" lattice — square grid, rot=0 so the 4
        // cardinal points land exactly on neighboring centers' midpoints.
        // A stroked point's painted edge actually extends lw/2 past its
        // mathematical position, so outerR is trimmed by half the line
        // weight — otherwise thicker lines (1.5x here, from Bead Studio)
        // overlap their neighbor more and more instead of just touching.
        final sp = size.width * 0.21;
        final lw = size.width * 0.018 * 1.2;
        final trim = lw * 0.5;
        final outerR = sp * 0.5 - trim, innerR = outerR * 0.42;
        for (var y = -sp; y < size.height + sp; y += sp) {
          for (var x = -sp; x < size.width + sp; x += sp) {
            _drawPoly(canvas, _starPts(x, y, 8, outerR, innerR, 0), null,
                color.withValues(alpha: .9), lw);
          }
        }
        break;
      case 'twelveStar':
        // Denser triangular lattice, 12-point stars whose points touch
        // their neighbors directly — matches the ornate mandala reference,
        // outline only, same stroke-width trim as eightStar.
        final sp = size.width * 0.21 * 1.15;
        final rowH = sp * sqrt(3) / 2;
        final lw = size.width * 0.018 * 1.2;
        final trim = lw * 0.5;
        final outerR = sp * 0.5 - trim, innerR = outerR * 0.62;
        var row = 0;
        for (var y = -rowH; y < size.height + rowH; y += rowH, row++) {
          final off = (row % 2) * (sp / 2);
          for (var x = -sp + off; x < size.width + sp; x += sp) {
            _drawPoly(canvas, _starPts(x, y, 12, outerR, innerR, 0), null,
                color.withValues(alpha: .85), lw);
          }
        }
        break;
      case 'octagonStar':
        // Octagons on a square grid, each carrying an inscribed 8-point
        // star — the star is drawn somewhat larger than the octagon so its
        // points poke past the octagon's edge into the gap between tiles
        // and meet the neighboring cell's star points, instead of leaving
        // an empty cross-shaped gap there. Both shapes trim their own
        // radius by half their stroke width so thicker lines don't balloon
        // that overlap into a blob at the tips. Outline only.
        final sp = size.width * 0.21 * 1.1;
        final lw = size.width * 0.018 * 1.2;
        final octagonLw = lw * 0.75;
        final r = sp * 0.46 - octagonLw * 0.5;
        final starOuterR = r * 1.1 - lw * 0.5;
        final starInnerR = starOuterR * 0.46;
        for (var y = 0.0; y < size.height + sp; y += sp) {
          for (var x = 0.0; x < size.width + sp; x += sp) {
            _drawPoly(
                canvas,
                _starPts(x, y, 8, starOuterR, starInnerR, pi / 8),
                null,
                color.withValues(alpha: .85),
                lw);
          }
        }
        for (var y = 0.0; y < size.height + sp; y += sp) {
          for (var x = 0.0; x < size.width + sp; x += sp) {
            _drawPoly(canvas, _ngonPts(x, y, 8, r, pi / 8), null,
                color.withValues(alpha: .7), octagonLw);
          }
        }
        break;
      case 'girihTiling':
        // Ten-point stars on a triangular lattice, outline only, no
        // infill, same stroke-width trim as eightStar/twelveStar. Point
        // length from the pattern lab (innerRatio 0.38). Density/weight
        // tuned in Bead Studio (denser field, slightly finer line).
        final sp = size.width * 0.21 * 1.1;
        final rowH = sp * sqrt(3) / 2;
        final lw = size.width * 0.018 * 0.9;
        final trim = lw * 0.5;
        final outerR = sp * 0.5 - trim, innerR = outerR * 0.38;
        var row = 0;
        for (var y = -rowH; y < size.height + rowH; y += rowH, row++) {
          final off = (row % 2) * (sp / 2);
          for (var x = -sp + off; x < size.width + sp; x += sp) {
            _drawPoly(canvas, _starPts(x, y, 10, outerR, innerR, pi / 10),
                null, color.withValues(alpha: .81), lw);
          }
        }
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _PatternPainter oldDelegate) =>
      oldDelegate.id != id || oldDelegate.color != color;
}

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _HeaderIconButton(
      {required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0x330A1F3A),
          border: Border.all(color: const Color(0xFF2D5986)),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 17, color: color),
      ),
    );
  }
}

// Shared frosted-glass panel: used by the preset picker and the color/
// pattern pickers so every bottom sheet in this screen matches.
class _GlassSheet extends StatelessWidget {
  final String title;
  final Widget child;
  const _GlassSheet({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: .10),
                    const Color(0xFF13314F).withValues(alpha: .55),
                  ],
                ),
                border:
                    Border.all(color: Colors.white.withValues(alpha: .16)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: .4),
                      blurRadius: 30,
                      offset: const Offset(0, 14)),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 22),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(4)),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 16),
                  child,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PresetPickerSheet extends StatelessWidget {
  final _TasbeehPreset current;
  const _PresetPickerSheet({required this.current});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _GlassSheet(
      title: l10n.tasbeehChooseTitle,
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.92,
        children: _kPresets
            .map((p) => _PresetCard(
                  preset: p,
                  selected: p.id == current.id,
                  onTap: () => Navigator.of(context).pop(p),
                ))
            .toList(),
      ),
    );
  }
}

class _PresetCard extends StatelessWidget {
  final _TasbeehPreset preset;
  final bool selected;
  final VoidCallback onTap;
  const _PresetCard(
      {required this.preset, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: selected
                ? [
                    const Color(0xFF7DD3FC).withValues(alpha: .30),
                    const Color(0xFF7DD3FC).withValues(alpha: .08),
                  ]
                : [
                    Colors.white.withValues(alpha: .08),
                    Colors.white.withValues(alpha: .02),
                  ],
          ),
          border: Border.all(
              color: selected
                  ? const Color(0xFF7DD3FC)
                  : Colors.white.withValues(alpha: .14)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: .25),
                blurRadius: 14,
                offset: const Offset(0, 6)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              preset.title(l10n),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  height: 1.3),
            ),
            const SizedBox(height: 6),
            Text(
              preset.subtitle(l10n),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colors.white.withValues(alpha: .75),
                  fontSize: 11.5,
                  height: 1.3),
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorPickerSheet extends StatelessWidget {
  final String currentId;
  final int maxStreakDays;
  const _ColorPickerSheet(
      {required this.currentId, required this.maxStreakDays});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hasLocked = !_kDevUnlockAll &&
        _kBeadThemes.any((t) => maxStreakDays < t.unlockStreakDays);
    return _GlassSheet(
      title: l10n.tasbeehColors,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
        spacing: 16,
        runSpacing: 10,
        alignment: WrapAlignment.center,
        children: _kBeadThemes.map((t) {
          final unlocked = _kDevUnlockAll || maxStreakDays >= t.unlockStreakDays;
          final selected = t.id == currentId;
          return GestureDetector(
            onTap: unlocked ? () => Navigator.of(context).pop(t) : null,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(colors: t.gradient),
                    border: Border.all(
                        color: selected ? Colors.white : Colors.white24,
                        width: selected ? 3 : 1),
                    boxShadow: [
                      BoxShadow(
                          color: t.glow, blurRadius: 16, spreadRadius: 2),
                    ],
                  ),
                  child: !unlocked
                      ? Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black.withValues(alpha: .5)),
                          child: const Icon(Icons.lock_rounded,
                              color: _kLockIconColor, size: 20),
                        )
                      : null,
                ),
                if (!unlocked) ...[
                  const SizedBox(height: 4),
                  Text(l10n.tasbeehDaysShort(t.unlockStreakDays),
                      style: const TextStyle(
                          color: _kLockIconColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w600)),
                ],
              ],
            ),
          );
        }).toList(),
          ),
          if (hasLocked) ...[
            const SizedBox(height: 14),
            Text(
              l10n.tasbeehLockedHint,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white.withValues(alpha: .6), fontSize: 11.5),
            ),
          ],
        ],
      ),
    );
  }
}

class _PatternPickerSheet extends StatelessWidget {
  final String currentId;
  final int maxStreakDays;
  final _BeadTheme theme;
  const _PatternPickerSheet(
      {required this.currentId,
      required this.maxStreakDays,
      required this.theme});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hasLocked = !_kDevUnlockAll &&
        _kPatterns.any((p) => maxStreakDays < p.unlockStreakDays);
    return _GlassSheet(
      title: l10n.tasbeehPatterns,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
        spacing: 14,
        runSpacing: 14,
        alignment: WrapAlignment.center,
        children: _kPatterns.map((p) {
          final unlocked = _kDevUnlockAll || maxStreakDays >= p.unlockStreakDays;
          final selected = p.id == currentId;
          return GestureDetector(
            onTap: unlocked ? () => Navigator.of(context).pop(p) : null,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF0A1F3A),
                    border: Border.all(
                        color: selected ? Colors.white : Colors.white24,
                        width: selected ? 3 : 1),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipOval(
                        child: CustomPaint(
                          size: const Size.square(72),
                          painter: _PatternPainter(p.id, theme.accent),
                        ),
                      ),
                      if (!unlocked)
                        Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black.withValues(alpha: .55)),
                          child: const Icon(Icons.lock_rounded,
                              color: _kLockIconColor, size: 20),
                        ),
                    ],
                  ),
                ),
                if (!unlocked) ...[
                  const SizedBox(height: 4),
                  Text(l10n.tasbeehDaysShort(p.unlockStreakDays),
                      style: const TextStyle(
                          color: _kLockIconColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w600)),
                ],
              ],
            ),
          );
        }).toList(),
          ),
          if (hasLocked) ...[
            const SizedBox(height: 14),
            Text(
              l10n.tasbeehLockedHint,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white.withValues(alpha: .6), fontSize: 11.5),
            ),
          ],
        ],
      ),
    );
  }
}

class _GoalChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color accent;
  final VoidCallback onTap;
  const _GoalChip(
      {required this.label,
      required this.selected,
      required this.accent,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? accent : const Color(0x330A1F3A),
          border: Border.all(color: selected ? accent : const Color(0xFF2D5986)),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected ? const Color(0xFF05223B) : const Color(0xFF9FC3DE),
          ),
        ),
      ),
    );
  }
}
