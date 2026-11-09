import 'package:sembast/sembast.dart';
import 'package:islamic_habits/utility/app_database.dart';
import 'package:islamic_habits/utility/habit.dart';

class HabitDao {
  static const String HABIT_STORE_NAME = 'habits';
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Habit objects converted to Map
  final _habitStore = intMapStoreFactory.store(HABIT_STORE_NAME);

  Future<bool> isEmpty() async {
    return await _habitStore.count(await _db) == 0;
  }

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  Future<Database> get _db async => await AppDatabase.instance.database;

  Future addHabit(Habit habit) async {
    habit.id = await _habitStore.add(await _db, habit.toMap());
  }

  Future updateHabit(Habit habit) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.byKey(habit.id));
    await _habitStore.update(
      await _db,
      habit.toMap(),
      finder: finder,
    );
  }

  Future deleteHabit(Habit habit) async {
    final finder = Finder(filter: Filter.byKey(habit.id));
    await _habitStore.delete(
      await _db,
      finder: finder,
    );
  }

  Future clear() async {
    await _habitStore.delete(await _db);
  }

  Future<List<Habit>> getAll() async {
    // Finder object can also sort data.

    final recordSnapshots = await _habitStore.find(
      await _db,
    );

    // Making a List<Habit> out of List<RecordSnapshot>
    final habits = recordSnapshots.map((snapshot) {
      final habit = Habit.fromMap(snapshot.value);
      // An ID is a key of a record from the database.
      habit.id = snapshot.key;
      return habit;
    }).toList();

    // Habits the user reordered explicitly come first in their chosen order;
    // anything never reordered keeps the database's creation order after
    // them, so a newly added habit appears at the bottom of the list.
    habits.sort((a, b) {
      final orderA = a.sortOrder;
      final orderB = b.sortOrder;
      if (orderA != null || orderB != null) {
        final compared = (orderA ?? 1 << 30).compareTo(orderB ?? 1 << 30);
        if (compared != 0) return compared;
      }
      return (a.id ?? 0).compareTo(b.id ?? 0);
    });
    return habits;
  }

  // Persists a manual order for the active habits. [orderedActiveIds] is the
  // new order from the "Reorder habits" mode; any habit not mentioned
  // (archived ones) keeps its place after the reordered list, so restoring an
  // archived habit does not jump it into the middle of the user's order.
  Future<void> reorderActive(List<int> orderedActiveIds) async {
    final all = await getAll();
    final byId = <int, Habit>{
      for (final habit in all)
        if (habit.id != null) habit.id!: habit,
    };

    final ordered = <Habit>[];
    for (final id in orderedActiveIds) {
      final habit = byId.remove(id);
      if (habit != null) ordered.add(habit);
    }
    ordered.addAll(byId.values);

    for (var i = 0; i < ordered.length; i++) {
      final habit = ordered[i];
      if (habit.sortOrder == i) continue;
      habit.sortOrder = i;
      await updateHabit(habit);
    }
  }

  // Active habits drive Home, the drawer, reminders, and statistics; archived
  // ones are only listed on the archive screen. getAll() deliberately keeps
  // returning everything so backups still include archived habits.
  Future<List<Habit>> getActive() async {
    return (await getAll()).where((habit) => !habit.archived).toList();
  }

  Future<List<Habit>> getArchived() async {
    return (await getAll()).where((habit) => habit.archived).toList();
  }
}
