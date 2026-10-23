import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:islamic_habits/l10n/generated/app_localizations.dart';
import 'package:islamic_habits/screens/add_habit_screen.dart';
import 'package:islamic_habits/screens/archived_habits_screen.dart';
import 'package:islamic_habits/screens/habit_detail.dart';
import 'package:islamic_habits/screens/multi-habit_screen.dart';
import 'package:islamic_habits/screens/prayers_screen.dart';
import 'package:islamic_habits/screens/settings_screen.dart';
import 'package:islamic_habits/screens/statistics_screen.dart';
import 'package:islamic_habits/utility/constants.dart';
import 'package:islamic_habits/utility/data_access_object.dart';
import 'package:islamic_habits/utility/habit.dart';
import 'package:islamic_habits/utility/habit_icons.dart';
import 'package:islamic_habits/utility/habit_name_localizer.dart';
import 'package:islamic_habits/utility/notification_service.dart';

class HabitDrawer extends StatelessWidget {
  final List<Habit> habits;
  const HabitDrawer({super.key, required this.habits});

  Future<void> _addHabit(BuildContext context) async {
    final navigator = Navigator.of(context);
    navigator.pop();
    final newHabit = await navigator.push<Habit>(
        MaterialPageRoute(
            builder: (context) => const AddHabitScreen(),
            settings: const RouteSettings(name: '/AddHabitScreen')));
    if (newHabit != null) {
      habits.add(newHabit);
      navigator.pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => SeveralHabitsScreen(habits: habits),
              settings: const RouteSettings(name: '/SeveralHabitsScreen')),
          (route) => route.settings.name == '/MainScreen');
    }
  }

  // Every drawer destination replaces whatever is currently on top of
  // Home, so Home is always exactly one back-press (or one drawer tap on
  // "Home") away, no matter how deep the user has navigated.
  void _navigateTo(
      BuildContext context, String routeName, WidgetBuilder builder) {
    final navigator = Navigator.of(context);
    navigator.pop();
    if (ModalRoute.of(context)?.settings.name == routeName) return;
    navigator.pushAndRemoveUntil(
        MaterialPageRoute(builder: builder, settings: RouteSettings(name: routeName)),
        (route) => route.settings.name == '/MainScreen');
  }

  void _goHome(BuildContext context) {
    final navigator = Navigator.of(context);
    navigator.pop();
    navigator.popUntil((route) => route.settings.name == '/MainScreen');
  }

  // Long-pressing a habit exposes the actions that used to be missing
  // entirely: edit, archive (keeps every logged day), and delete (removes the
  // habit and its history).
  Future<void> _showHabitActions(BuildContext context, Habit habit) async {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final String action = await showModalBottomSheet<String>(
          context: context,
          showDragHandle: true,
          builder: (sheetContext) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: HabitIconBadge(habit: habit),
                  title: Text(
                    localizedHabitName(sheetContext, habit.name),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.edit_outlined),
                  title: Text(l10n.edit),
                  onTap: () => Navigator.pop(sheetContext, 'edit'),
                ),
                ListTile(
                  leading: const Icon(Icons.archive_outlined),
                  title: Text(l10n.archive),
                  subtitle: Text(l10n.archivedHabitsHint),
                  onTap: () => Navigator.pop(sheetContext, 'archive'),
                ),
                ListTile(
                  leading: Icon(Icons.delete_outline,
                      color: theme.colorScheme.error),
                  title: Text(l10n.delete,
                      style: TextStyle(color: theme.colorScheme.error)),
                  onTap: () => Navigator.pop(sheetContext, 'delete'),
                ),
              ],
            ),
          ),
        ) ??
        '';

    if (!context.mounted || action.isEmpty) return;

    switch (action) {
      case 'edit':
        await _editHabit(context, habit);
        break;
      case 'archive':
        await _setArchived(context, habit, true);
        break;
      case 'delete':
        await _confirmDelete(context, habit);
        break;
    }
  }

  Future<void> _editHabit(BuildContext context, Habit habit) async {
    final navigator = Navigator.of(context);
    navigator.pop();
    final updated = await navigator.push<Habit>(MaterialPageRoute(
        builder: (context) => AddHabitScreen(editingHabit: habit),
        settings: const RouteSettings(name: '/AddHabitScreen')));
    if (updated != null) NotificationService.habitDataRevision.value++;
  }

  Future<void> _setArchived(
      BuildContext context, Habit habit, bool archived) async {
    final l10n = AppLocalizations.of(context);
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    navigator.pop();
    await HabitDao().updateHabit(habit..archived = archived);
    await NotificationService.scheduleHabitReminders();
    NotificationService.habitDataRevision.value++;
    messenger.showSnackBar(SnackBar(
      content: Text(archived ? l10n.habitArchived : l10n.habitRestored),
    ));
  }

  Future<void> _confirmDelete(BuildContext context, Habit habit) async {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final bool confirmed = await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: Text(l10n.deleteHabitTitle),
            content: Text(l10n.deleteHabitMessage(
                localizedHabitName(dialogContext, habit.name))),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: Text(l10n.cancel),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: theme.colorScheme.error,
                ),
                onPressed: () => Navigator.pop(dialogContext, true),
                child: Text(l10n.delete),
              ),
            ],
          ),
        ) ??
        false;
    if (!confirmed) return;

    navigator.pop();
    await HabitDao().deleteHabit(habit);
    await NotificationService.scheduleHabitReminders();
    NotificationService.habitDataRevision.value++;
    messenger.showSnackBar(SnackBar(content: Text(l10n.habitDeleted)));
  }

  Widget _header(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return DrawerHeader(
      padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
      decoration: BoxDecoration(
        color: isDark ? Colors.black : null,
        border: isDark
            ? const Border(
                bottom: BorderSide(color: Colors.white12),
              )
            : null,
        gradient: isDark
            ? null
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[kBrandNavy, kBrandBlueDeep],
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              ClipOval(
                child: Image.asset(
                  'assets/branding/logo.png',
                  width: 42,
                  height: 42,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.appTitle,
                  maxLines: 2,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
              ),
              IconButton(
                tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 2),
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => _addHabit(context),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: Row(
                children: <Widget>[
                  const Icon(Icons.add_circle_outline, color: Colors.white),
                  const SizedBox(width: 12),
                  Text(
                    l10n.navAddHabit,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Destinations that live in the scrollable part of the drawer. Prayer
  // Times and The Five Prayers stay above All Habits, and any user-added
  // habits follow All Habits so a long list of custom habits can scroll
  // without pushing Settings/Statistics out of reach.
  List<Widget> _scrollableDestinations(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final prayerNames = kPrayersNames.map((name) => '$name Prayer').toSet();
    final prayerHabits =
        habits.where((habit) => prayerNames.contains(habit.name)).toList();
    final otherHabits =
        habits.where((habit) => !prayerNames.contains(habit.name)).toList();

    return <Widget>[
      ListTile(
        leading: const Icon(Icons.home_outlined),
        title: Text(l10n.navHome),
        onTap: () => _goHome(context),
      ),
      ListTile(
        leading: const Icon(FlutterIslamicIcons.solidMosque),
        title: Text(l10n.navPrayerTimes),
        onTap: () => _navigateTo(context, '/PrayersScreen',
            (context) => PrayersScreen(habits: habits)),
      ),
      if (prayerHabits.isNotEmpty)
        ListTile(
          leading: const Icon(FlutterIslamicIcons.solidPrayingPerson),
          title: Text(l10n.navFivePrayers),
          onTap: () => _navigateTo(
              context,
              '/FivePrayersScreen',
              (context) => SeveralHabitsScreen(
                    habits: prayerHabits,
                    allHabits: habits,
                    titleKind: SeveralHabitsTitle.fivePrayers,
                    color: Colors.blueGrey,
                    showAddButton: false,
                  )),
        ),
      ListTile(
        leading: const Icon(Icons.list_alt_rounded),
        title: Text(l10n.navAllHabits),
        onTap: () => _navigateTo(context, '/SeveralHabitsScreen',
            (context) => SeveralHabitsScreen(habits: habits)),
      ),
      for (final habit in otherHabits)
        ListTile(
          leading: HabitIconBadge(habit: habit),
          title: Text(localizedHabitName(context, habit.name)),
          onTap: () => _navigateTo(context, '/${habit.name}',
              (context) => HabitDetail(habit: habit, habits: habits)),
          onLongPress: () => _showHabitActions(context, habit),
        ),
      // Kept as the last destination so it always sits at the bottom of the
      // habit list, right above the pinned Settings/Statistics section.
      ListTile(
        leading: const Icon(Icons.archive_outlined),
        title: Text(l10n.archivedHabits),
        onTap: () => _navigateTo(context, '/ArchivedHabitsScreen',
            (context) => const ArchivedHabitsScreen()),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Drawer(
      child: SafeArea(
        top: false,
        child: Column(
          children: <Widget>[
            _header(context),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: _scrollableDestinations(context),
              ),
            ),
            const Divider(height: 1),
            // Pinned to the bottom so Settings and Statistics are always
            // reachable, however many custom habits the user has added.
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: Text(l10n.settingsTitle),
              onTap: () => _navigateTo(context, '/SettingsScreen',
                  (context) => const SettingsScreen()),
            ),
            ListTile(
              leading: const Icon(Icons.insights_rounded),
              title: Text(l10n.navStatistics),
              onTap: () => _navigateTo(context, '/StatisticsScreen',
                  (context) => StatisticsScreen(habits: habits)),
            ),
          ],
        ),
      ),
    );
  }
}
