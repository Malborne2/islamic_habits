import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:islamic_habits/utility/habit.dart';

// Every glyph bundled with flutter_islamic_icons 1.0.2, in the same order as
// the package's own catalog. Keeping the list here (instead of reflecting over
// the package) gives the picker stable ordering and a human-readable label for
// every icon.
class HabitIconOption {
  final String label;
  final IconData icon;
  const HabitIconOption(this.label, this.icon);
}

const List<HabitIconOption> kHabitIcons = <HabitIconOption>[
  HabitIconOption('Allah 99', FlutterIslamicIcons.allah99),
  HabitIconOption('Allah Text', FlutterIslamicIcons.allahText),
  HabitIconOption('Community', FlutterIslamicIcons.community),
  HabitIconOption('Allah', FlutterIslamicIcons.allah),
  HabitIconOption('Cow', FlutterIslamicIcons.cow),
  HabitIconOption('Crescent Moon', FlutterIslamicIcons.crescentMoon),
  HabitIconOption('Calendar', FlutterIslamicIcons.calendar),
  HabitIconOption('Drum 2', FlutterIslamicIcons.drum2),
  HabitIconOption('Family', FlutterIslamicIcons.family),
  HabitIconOption('Iftar', FlutterIslamicIcons.iftar),
  HabitIconOption('Islam', FlutterIslamicIcons.islam),
  HabitIconOption('Drum', FlutterIslamicIcons.drum),
  HabitIconOption('Hadji', FlutterIslamicIcons.hadji),
  HabitIconOption('Location Muslim', FlutterIslamicIcons.locationMuslim),
  HabitIconOption('Location Mosque', FlutterIslamicIcons.locationMosque),
  HabitIconOption('Lantern', FlutterIslamicIcons.lantern),
  HabitIconOption('Kaaba', FlutterIslamicIcons.kaaba),
  HabitIconOption('Muslim', FlutterIslamicIcons.muslim),
  HabitIconOption('Muslim 2', FlutterIslamicIcons.muslim2),
  HabitIconOption('Muslimah', FlutterIslamicIcons.muslimah),
  HabitIconOption('Kowtow', FlutterIslamicIcons.kowtow),
  HabitIconOption('Mohammad', FlutterIslamicIcons.mohammad),
  HabitIconOption('Muslimah 2', FlutterIslamicIcons.muslimah2),
  HabitIconOption('Prayer', FlutterIslamicIcons.prayer),
  HabitIconOption('Praying Person', FlutterIslamicIcons.prayingPerson),
  HabitIconOption('Qibla', FlutterIslamicIcons.qibla),
  HabitIconOption('Qibla 2', FlutterIslamicIcons.qibla2),
  HabitIconOption('Quran 2', FlutterIslamicIcons.quran2),
  HabitIconOption('Ramadan', FlutterIslamicIcons.ramadan),
  HabitIconOption('Sajadah', FlutterIslamicIcons.sajadah),
  HabitIconOption('Quran', FlutterIslamicIcons.quran),
  HabitIconOption('Solid Allah', FlutterIslamicIcons.solidAllah),
  HabitIconOption('Solid Community', FlutterIslamicIcons.solidCommunity),
  HabitIconOption('Solid Drum 2', FlutterIslamicIcons.solidDrum2),
  HabitIconOption('Solid Drum', FlutterIslamicIcons.solidDrum),
  HabitIconOption('Solid Crescent Moon', FlutterIslamicIcons.solidCrescentMoon),
  HabitIconOption('Sheep', FlutterIslamicIcons.sheep),
  HabitIconOption('Solid Allah 99', FlutterIslamicIcons.solidAllah99),
  HabitIconOption('Solid Cow', FlutterIslamicIcons.solidCow),
  HabitIconOption('Solid Family', FlutterIslamicIcons.solidFamily),
  HabitIconOption('Solid Iftar', FlutterIslamicIcons.solidIftar),
  HabitIconOption('Solid Kaaba', FlutterIslamicIcons.solidKaaba),
  HabitIconOption('Solid Lantern', FlutterIslamicIcons.solidLantern),
  HabitIconOption('Solid Kowtow', FlutterIslamicIcons.solidKowtow),
  HabitIconOption('Solid Hadji', FlutterIslamicIcons.solidHadji),
  HabitIconOption('Solid Location Muslim', FlutterIslamicIcons.solidLocationMuslim),
  HabitIconOption('Solid Minaret', FlutterIslamicIcons.solidMinaret),
  HabitIconOption('Solid Mohammad', FlutterIslamicIcons.solidMohammad),
  HabitIconOption('Solid Mosque', FlutterIslamicIcons.solidMosque),
  HabitIconOption('Solid Muslimah', FlutterIslamicIcons.solidMuslimah),
  HabitIconOption('Solid Muslimah 2', FlutterIslamicIcons.solidMuslimah2),
  HabitIconOption('Solid Muslim', FlutterIslamicIcons.solidMuslim),
  HabitIconOption('Solid Muslim 2', FlutterIslamicIcons.solidMuslim2),
  HabitIconOption('Solid Prayer', FlutterIslamicIcons.solidPrayer),
  HabitIconOption('Solid Praying Person', FlutterIslamicIcons.solidPrayingPerson),
  HabitIconOption('Solid Qibla', FlutterIslamicIcons.solidQibla),
  HabitIconOption('Solid Qibla 2', FlutterIslamicIcons.solidQibla2),
  HabitIconOption('Mosque', FlutterIslamicIcons.mosque),
  HabitIconOption('Solid Quran', FlutterIslamicIcons.solidQuran),
  HabitIconOption('Solid Quran 2', FlutterIslamicIcons.solidQuran2),
  HabitIconOption('Solid Sajadah', FlutterIslamicIcons.solidSajadah),
  HabitIconOption('Solid Sheep', FlutterIslamicIcons.solidSheep),
  HabitIconOption('Solid Takbir', FlutterIslamicIcons.solidTakbir),
  HabitIconOption('Solid Tasbih', FlutterIslamicIcons.solidTasbih),
  HabitIconOption('Solid Tasbih 2', FlutterIslamicIcons.solidTasbih2),
  HabitIconOption('Solid Tasbih 3', FlutterIslamicIcons.solidTasbih3),
  HabitIconOption('Solid Tasbih Hand', FlutterIslamicIcons.solidTasbihHand),
  HabitIconOption('Solid Tawhid', FlutterIslamicIcons.solidTawhid),
  HabitIconOption('Solid Wudhu', FlutterIslamicIcons.solidWudhu),
  HabitIconOption('Solid Zakat', FlutterIslamicIcons.solidZakat),
  HabitIconOption('Tasbih 2', FlutterIslamicIcons.tasbih2),
  HabitIconOption('Tawhid', FlutterIslamicIcons.tawhid),
  HabitIconOption('Zakat', FlutterIslamicIcons.zakat),
  HabitIconOption('Tasbih Hand', FlutterIslamicIcons.tasbihHand),
  HabitIconOption('Tasbih', FlutterIslamicIcons.tasbih),
  HabitIconOption('Wudhu', FlutterIslamicIcons.wudhu),
  HabitIconOption('Takbir', FlutterIslamicIcons.takbir),
  HabitIconOption('Tasbih 3', FlutterIslamicIcons.tasbih3),
];

final Map<int, HabitIconOption> _iconsByCodePoint = <int, HabitIconOption>{
  for (final option in kHabitIcons) option.icon.codePoint: option,
};

HabitIconOption? habitIconOptionForCodePoint(int? codePoint) {
  if (codePoint == null) return null;
  return _iconsByCodePoint[codePoint];
}

// The seeded Quran habit predates the icon picker, so it (and any habit the
// user created with the same name) still shows a mushaf without needing a
// database migration. Everything else keeps the colored dot until the user
// picks an icon.
int? defaultIconCodePointForHabitName(String name) {
  if (name == 'Reciting the Quran') {
    return FlutterIslamicIcons.solidQuran2.codePoint;
  }
  return null;
}

int? habitIconCodePoint(Habit habit) =>
    habit.iconCodePoint ?? defaultIconCodePointForHabitName(habit.name);

IconData? habitIconForHabit(Habit habit) =>
    habitIconOptionForCodePoint(habitIconCodePoint(habit))?.icon;

// Small leading avatar used by the drawer, Today list, and archive screen.
// HabitIconOption-less habits keep the original colored dot.
class HabitIconBadge extends StatelessWidget {
  final Habit habit;
  final double size;
  const HabitIconBadge({super.key, required this.habit, this.size = 34});

  @override
  Widget build(BuildContext context) {
    final IconData? icon = habitIconForHabit(habit);
    if (icon == null) {
      return SizedBox(
        width: size,
        height: size,
        child: Center(
          child: CircleAvatar(radius: 6, backgroundColor: habit.color),
        ),
      );
    }
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: habit.color.withValues(alpha: 0.16),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: size * 0.58, color: habit.color),
    );
  }
}
