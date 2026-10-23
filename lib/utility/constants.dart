import 'package:flutter/material.dart';

// Brand palette, taken from the app icon. Navy is the primary accent in both
// light and dark themes; the lighter blue is used where navy would not have
// enough contrast against a dark surface.
const Color kBrandNavy = Color(0xFF0F2347);
const Color kBrandBlue = Color(0xFF8FB3E8);
const Color kBrandBlueDeep = Color(0xFF17356B);

/// A readable accent for the current theme: navy on light surfaces, and the
/// icon's lighter blue on dark surfaces where navy would disappear.
Color brandAccent(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark ? kBrandBlue : kBrandNavy;

/// Black or white, whichever reads better on top of [background].
Color foregroundOn(Color background) =>
    background.computeLuminance() > 0.55 ? Colors.black87 : Colors.white;

List<String> kPrayersNames = [
  'Al Fajir',
  'Al Dhuhr',
  'Al Asr',
  'Al Magrib',
  'Al Isha',
];

List<String> kDays = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
List<String> kMetricNames = [
  'Current Streak',
  'Streak Target',
  'Maximum Streak',
  'Success Percentage',
  'Weekly Average',
  'Monthly Average'
];

int kStartOfWeek = DateTime.friday;

// The original nine habit colours come first so the six default habits (and
// a new habit's pre-selected colour) keep the vibrant red/orange/blue/pink/
// maroon/green look they had before the rebrand. Navy and a broader
// Material-style palette follow as extra choices, so the picker still has a
// distinct colour for every habit without changing existing habits.
const kHabitColors = <Color>[
  // Original palette.
  Color(0xFFEB5757), // red
  Color(0xFFF2994A), // orange
  Color(0xFF2D9CDB), // blue
  Color(0xFFB94680), // pink
  Color(0xFF651E3E), // maroon
  Color(0xFF27AE60), // green
  Color(0xFF854085), // purple
  Color(0xFFFF8566), // coral
  Color(0xFF36C9A2), // teal
  // Brand accent, still selectable as a habit colour.
  kBrandNavy,
  // Expanded Material-style palette.
  Color(0xFF2563EB), // royal blue
  Color(0xFF0EA5E9), // sky
  Color(0xFF06B6D4), // cyan
  Color(0xFF14B8A6), // teal
  Color(0xFF10B981), // emerald
  Color(0xFF22C55E), // green
  Color(0xFF84CC16), // lime
  Color(0xFFEAB308), // yellow
  Color(0xFFF59E0B), // amber
  Color(0xFFF97316), // orange
  Color(0xFFEF4444), // red
  Color(0xFFF43F5E), // rose
  Color(0xFFEC4899), // pink
  Color(0xFFD946EF), // fuchsia
  Color(0xFFA855F7), // purple
  Color(0xFF8B5CF6), // violet
  Color(0xFF6366F1), // indigo
  Color(0xFF78716C), // stone
  Color(0xFF64748B), // slate
];

/// Text-field styling that follows the active theme: navy on light
/// surfaces, the icon's lighter blue on dark ones, where navy would be too
/// dark to read. Used instead of one fixed [InputDecoration] so the fields
/// stay consistent in both modes.
InputDecoration habitTextFieldDecoration(BuildContext context) {
  final bool isDark = Theme.of(context).brightness == Brightness.dark;
  final Color accent = brandAccent(context);
  final Color border = isDark
      ? const Color(0x668FB3E8)
      : const Color(0xFFD5DDEA);
  const Radius radius = Radius.circular(20);
  return InputDecoration(
    hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.grey),
    contentPadding:
        const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(radius),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: border),
      borderRadius: const BorderRadius.all(radius),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: accent, width: 2.0),
      borderRadius: const BorderRadius.all(radius),
    ),
    labelStyle:
        TextStyle(color: isDark ? Colors.white70 : const Color(0xFF4B5563)),
  );
}
