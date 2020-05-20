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
    await _habitStore.add(await _db, habit.toMap());
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

  Future<List<Habit>> getAll() async {
    // Finder object can also sort data.

    final recordSnapshots = await _habitStore.find(
      await _db,
    );

    // Making a List<Habit> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final habit = Habit.fromMap(snapshot.value);
      // An ID is a key of a record from the database.
      habit.id = snapshot.key;
      return habit;
    }).toList();
  }
}
