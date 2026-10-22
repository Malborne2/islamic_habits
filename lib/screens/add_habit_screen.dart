import 'package:flutter/material.dart';
import 'package:islamic_habits/l10n/generated/app_localizations.dart';
import 'package:islamic_habits/utility/constants.dart';
import 'package:islamic_habits/utility/data_access_object.dart';
import 'package:islamic_habits/utility/habit.dart';

List<String> _weekdayShortNames(AppLocalizations l10n) => [
      l10n.weekdayMonShort,
      l10n.weekdayTueShort,
      l10n.weekdayWedShort,
      l10n.weekdayThuShort,
      l10n.weekdayFriShort,
      l10n.weekdaySatShort,
      l10n.weekdaySunShort,
    ];

class AddHabitScreen extends StatefulWidget {
  // When set, the screen edits this habit in place (keeping its id and
  // logged history) instead of creating a new one.
  final Habit? editingHabit;
  const AddHabitScreen({super.key, this.editingHabit});
  @override
  _AddHabitScreenState createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _nameController =
      TextEditingController(text: widget.editingHabit?.name);
  late final _targetValueController = TextEditingController(
      text: widget.editingHabit != null &&
              widget.editingHabit!.type == HabitType.NUMBER
          ? widget.editingHabit!.successValue.toString()
          : null);
  late final _unitController =
      TextEditingController(text: widget.editingHabit?.numberUnit);
  bool _unitDefaultSet = false;
  late final _streakTargetController = TextEditingController(
      text: (widget.editingHabit?.successTarget ?? 40).toString());
  late final _timesPerWeekController = TextEditingController(
      text: (widget.editingHabit?.habitDays == HabitDays.TIMES_PER_WEEK
              ? widget.editingHabit!.habitPeriod?.first
              : null)
          ?.toString() ??
          '3');

  late HabitType _type = widget.editingHabit?.type ?? HabitType.YES_NO;
  late HabitDays _habitDays =
      widget.editingHabit?.habitDays ?? HabitDays.EVERYDAY;
  late final Set<int> _selectedWeekdays = {
    if (widget.editingHabit?.habitDays == HabitDays.DAYS_OF_WEEK)
      ...?widget.editingHabit?.habitPeriod,
  };
  late Color _selectedColor = widget.editingHabit?.color ?? kHabitColors[0];
  String? _scheduleError;

  bool get _isEditing => widget.editingHabit != null;

  @override
  void dispose() {
    _nameController.dispose();
    _targetValueController.dispose();
    _unitController.dispose();
    _streakTargetController.dispose();
    _timesPerWeekController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final isValid = _formKey.currentState!.validate();
    setState(() {
      _scheduleError = _habitDays == HabitDays.DAYS_OF_WEEK &&
              _selectedWeekdays.isEmpty
          ? l10n.pickAtLeastOneDay
          : null;
    });
    if (!isValid || _scheduleError != null) return;

    final enteredUnit = _unitController.text.trim();
    // Keep the canonical English unit in storage when the user left the
    // auto-filled default untouched, so it still displays correctly if the
    // app language changes later; anything the user actually typed is kept
    // as-is.
    final unit = enteredUnit.isEmpty || enteredUnit == l10n.unitPages
        ? 'pages'
        : enteredUnit;

    final habitPeriod = _habitDays == HabitDays.DAYS_OF_WEEK
        ? (_selectedWeekdays.toList()..sort())
        : _habitDays == HabitDays.TIMES_PER_WEEK
            ? [int.parse(_timesPerWeekController.text)]
            : null;
    final successValue = _type == HabitType.YES_NO
        ? 1.0
        : double.parse(_targetValueController.text);
    final successTarget = int.tryParse(_streakTargetController.text) ?? 40;

    final Habit habit;
    if (_isEditing) {
      habit = widget.editingHabit!
        ..name = _nameController.text.trim()
        ..color = _selectedColor
        ..type = _type
        ..successValue = successValue
        ..successTarget = successTarget
        ..habitDays = _habitDays
        ..habitPeriod = habitPeriod
        ..numberUnit = unit;
      await HabitDao().updateHabit(habit);
    } else {
      habit = Habit(
        name: _nameController.text.trim(),
        color: _selectedColor,
        type: _type,
        criteria: Criteria.AT_LEAST,
        successValue: successValue,
        successTarget: successTarget,
        habitDays: _habitDays,
        habitPeriod: habitPeriod,
        numberUnit: unit,
      );
      await HabitDao().addHabit(habit);
    }
    if (mounted) Navigator.pop(context, habit);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (!_unitDefaultSet) {
      _unitDefaultSet = true;
      if (_unitController.text.isEmpty) _unitController.text = l10n.unitPages;
    }
    return Scaffold(
      appBar:
          AppBar(title: Text(_isEditing ? l10n.editHabitTitle : l10n.navAddHabit)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            TextFormField(
              controller: _nameController,
              decoration: kTextFieldDecoration.copyWith(labelText: l10n.habitName),
              validator: (value) =>
                  (value == null || value.trim().isEmpty) ? 'Enter a name' : null,
            ),
            const SizedBox(height: 24),
            Text(l10n.successMetric,
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SegmentedButton<HabitType>(
              segments: [
                ButtonSegment(value: HabitType.YES_NO, label: Text(l10n.yesNo)),
                ButtonSegment(value: HabitType.NUMBER, label: Text(l10n.number)),
              ],
              selected: {_type},
              onSelectionChanged: (selection) {
                setState(() => _type = selection.first);
              },
            ),
            if (_type == HabitType.NUMBER) ...[
              const SizedBox(height: 12),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      controller: _targetValueController,
                      keyboardType: TextInputType.number,
                      decoration:
                          kTextFieldDecoration.copyWith(labelText: l10n.targetAmountLabel),
                      validator: (value) {
                        if (_type != HabitType.NUMBER) return null;
                        final parsed = double.tryParse(value ?? '');
                        if (parsed == null || parsed <= 0) {
                          return 'Enter a number > 0';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _unitController,
                      decoration: kTextFieldDecoration.copyWith(labelText: l10n.unitLabel),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 24),
            Text(l10n.streakTarget,
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _streakTargetController,
              keyboardType: TextInputType.number,
              decoration:
                  kTextFieldDecoration.copyWith(labelText: l10n.targetStreakDays),
              validator: (value) {
                final parsed = int.tryParse(value ?? '');
                if (parsed == null || parsed <= 0) return 'Enter a number > 0';
                return null;
              },
            ),
            const SizedBox(height: 24),
            Text(l10n.schedule, style: const TextStyle(fontWeight: FontWeight.bold)),
            RadioListTile<HabitDays>(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.everyDay),
              value: HabitDays.EVERYDAY,
              groupValue: _habitDays,
              onChanged: (value) => setState(() => _habitDays = value!),
            ),
            RadioListTile<HabitDays>(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.certainDaysOfWeek),
              value: HabitDays.DAYS_OF_WEEK,
              groupValue: _habitDays,
              onChanged: (value) => setState(() => _habitDays = value!),
            ),
            if (_habitDays == HabitDays.DAYS_OF_WEEK) ...[
              Wrap(
                spacing: 8,
                children: List.generate(7, (i) {
                  final weekday = i + 1;
                  return FilterChip(
                    label: Text(_weekdayShortNames(l10n)[i]),
                    selected: _selectedWeekdays.contains(weekday),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedWeekdays.add(weekday);
                        } else {
                          _selectedWeekdays.remove(weekday);
                        }
                        _scheduleError = null;
                      });
                    },
                  );
                }),
              ),
              if (_scheduleError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(_scheduleError!,
                      style: TextStyle(color: Theme.of(context).colorScheme.error)),
                ),
            ],
            RadioListTile<HabitDays>(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.timesPerWeek),
              value: HabitDays.TIMES_PER_WEEK,
              groupValue: _habitDays,
              onChanged: (value) => setState(() => _habitDays = value!),
            ),
            if (_habitDays == HabitDays.TIMES_PER_WEEK)
              TextFormField(
                controller: _timesPerWeekController,
                keyboardType: TextInputType.number,
                decoration:
                    kTextFieldDecoration.copyWith(labelText: l10n.timesPerWeekLabel),
                validator: (value) {
                  if (_habitDays != HabitDays.TIMES_PER_WEEK) return null;
                  final parsed = int.tryParse(value ?? '');
                  if (parsed == null || parsed < 1 || parsed > 7) {
                    return 'Enter a number from 1 to 7';
                  }
                  return null;
                },
              ),
            const SizedBox(height: 24),
            Text(l10n.color, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: kHabitColors.map((color) {
                final selected = color == _selectedColor;
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = color),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: color,
                    child: selected
                        ? const Icon(Icons.check, color: Colors.white)
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _save,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(l10n.saveHabit),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
