import 'package:flutter/material.dart';
import 'package:islamic_habits/utility/constants.dart';

// Brand themes. The preference keys are kept exactly as they were
// ("PurpleLight"/"PurpleDark"/"DarkNormal") so existing installs keep their
// saved dark/light choice after the palette moved from purple to the navy
// from the app icon.
const Color _lightScaffold = Color(0xFFF5F7FB);
const Color _lightCard = Colors.white;
// Keep dark mode genuinely AMOLED: pure black backgrounds and the same
// almost-black card fill the app used before the navy rebrand. The navy stays
// as an accent (buttons, selected states, charts), not as a background wash.
const Color _darkScaffold = Colors.black;
const Color _darkCard = Color(0xFF0A0A0A);
const Color _darkRaised = Color(0xFF141414);

ColorScheme _lightScheme() => ColorScheme.fromSeed(
      seedColor: kBrandNavy,
      brightness: Brightness.light,
    ).copyWith(
      primary: kBrandNavy,
      onPrimary: Colors.white,
      primaryContainer: const Color(0xFFDDE7F7),
      onPrimaryContainer: kBrandNavy,
      secondary: kBrandBlueDeep,
      onSecondary: Colors.white,
      secondaryContainer: const Color(0xFFDCE9FB),
      onSecondaryContainer: kBrandNavy,
      surface: _lightCard,
      onSurface: const Color(0xFF111827),
      surfaceContainerHighest: const Color(0xFFEDF1F8),
      error: const Color(0xFFB3261E),
    );

ColorScheme _darkScheme() => ColorScheme.fromSeed(
      seedColor: kBrandNavy,
      brightness: Brightness.dark,
    ).copyWith(
      primary: kBrandNavy,
      onPrimary: Colors.white,
      primaryContainer: kBrandBlueDeep,
      onPrimaryContainer: Colors.white,
      secondary: kBrandBlue,
      onSecondary: kBrandNavy,
      secondaryContainer: const Color(0xFF1A1A1A),
      onSecondaryContainer: const Color(0xFFDCE9FB),
      surface: _darkCard,
      onSurface: Colors.white,
      onSurfaceVariant: const Color(0xFFB5B5B5),
      surfaceContainerHighest: _darkRaised,
      error: const Color(0xFFFF6B6B),
    );

ThemeData _buildTheme({
  required Brightness brightness,
  required ColorScheme scheme,
  required Color scaffold,
  required Color card,
}) {
  final bool isDark = brightness == Brightness.dark;
  final Color accent = isDark ? kBrandBlue : kBrandNavy;
  final Color border =
      isDark ? Colors.white12 : const Color(0xFFD5DDEA);
  final Color fieldFill = isDark ? _darkCard : Colors.white;
  final RoundedRectangleBorder rounded = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
  );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    primaryColor: kBrandNavy,
    scaffoldBackgroundColor: scaffold,
    canvasColor: scaffold,
    cardColor: card,
    dividerColor: isDark ? Colors.white12 : const Color(0xFFE2E8F0),
    splashFactory: InkSparkle.splashFactory,
    appBarTheme: AppBarThemeData(
      backgroundColor: isDark ? Colors.black : kBrandNavy,
      foregroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      iconTheme: const IconThemeData(color: Colors.white),
      actionsIconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardTheme: CardThemeData(
      color: card,
      surfaceTintColor: Colors.transparent,
      elevation: isDark ? 1 : 0,
      shadowColor: Colors.black,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: isDark ? BorderSide.none : BorderSide(color: border),
      ),
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: scaffold,
      surfaceTintColor: Colors.transparent,
      elevation: 1,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: card,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: card,
      surfaceTintColor: Colors.transparent,
      modalBackgroundColor: card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
    ),
    bottomAppBarTheme: BottomAppBarThemeData(color: card),
    listTileTheme: ListTileThemeData(
      iconColor: isDark ? const Color(0xFFE6E8EB) : accent,
      textColor: scheme.onSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    dividerTheme: DividerThemeData(
      color: isDark ? Colors.white12 : const Color(0xFFE2E8F0),
      thickness: 1,
      space: 1,
    ),
    iconTheme:
        IconThemeData(color: isDark ? const Color(0xFFE6E8EB) : kBrandNavy),
    textTheme: Typography.material2021(platform: TargetPlatform.android)
        .black
        .apply(
          bodyColor: scheme.onSurface,
          displayColor: scheme.onSurface,
        ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: fieldFill,
      isDense: true,
      contentPadding:
          const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
      hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.grey),
      labelStyle:
          TextStyle(color: isDark ? Colors.white70 : const Color(0xFF4B5563)),
      floatingLabelStyle: TextStyle(color: accent),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: accent, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: scheme.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: scheme.error, width: 2),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: kBrandNavy,
        foregroundColor: Colors.white,
        minimumSize: const Size(0, 48),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: rounded,
        side: BorderSide(
          color: isDark ? Colors.white : kBrandNavy,
          width: 1.4,
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kBrandNavy,
        foregroundColor: Colors.white,
        elevation: 0,
        minimumSize: const Size(0, 48),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: rounded,
        side: BorderSide(
          color: isDark ? Colors.white : kBrandNavy,
          width: 1.4,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: accent,
        minimumSize: const Size(0, 46),
        side: BorderSide(color: accent, width: 1.2),
        shape: rounded,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: accent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: kBrandNavy,
      foregroundColor: Colors.white,
    ),
    switchTheme: SwitchThemeData(
      trackColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? (isDark ? kBrandBlue : kBrandNavy)
            : null,
      ),
      thumbColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? (isDark ? kBrandNavy : Colors.white)
            : null,
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected) ? accent : null,
      ),
      checkColor: WidgetStatePropertyAll(
        isDark ? kBrandNavy : Colors.white,
      ),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected) ? accent : null,
      ),
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? Colors.white
              : scheme.onSurface,
        ),
        backgroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? kBrandNavy
              : Colors.transparent,
        ),
        side: WidgetStatePropertyAll(BorderSide(color: border)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor:
          isDark ? _darkRaised : const Color(0xFFEDF1F8),
      selectedColor: kBrandNavy,
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(
        color: isDark ? Colors.white : const Color(0xFF1F2937),
        fontWeight: FontWeight.w500,
      ),
      secondaryLabelStyle: const TextStyle(color: Colors.white),
      side: BorderSide(color: border),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: accent,
      linearTrackColor: isDark ? Colors.white12 : const Color(0xFFE2E8F0),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: isDark ? _darkRaised : kBrandNavy,
      contentTextStyle: const TextStyle(color: Colors.white),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: isDark ? _darkRaised : kBrandNavy,
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: const TextStyle(color: Colors.white, fontSize: 12),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: card,
      indicatorColor: kBrandNavy,
      surfaceTintColor: Colors.transparent,
    ),
    tabBarTheme: TabBarThemeData(
      labelColor: accent,
      unselectedLabelColor: isDark ? Colors.white60 : Colors.black54,
      indicatorColor: accent,
      dividerColor: Colors.transparent,
    ),
  );
}

final ThemeData _lightTheme = _buildTheme(
  brightness: Brightness.light,
  scheme: _lightScheme(),
  scaffold: _lightScaffold,
  card: _lightCard,
);

final ThemeData _darkTheme = _buildTheme(
  brightness: Brightness.dark,
  scheme: _darkScheme(),
  scaffold: _darkScaffold,
  card: _darkCard,
);

final appThemeData = <String, ThemeData>{
  'PurpleLight': _lightTheme,
  'DarkNormal': _darkTheme,
  'PurpleDark': _darkTheme,
};
