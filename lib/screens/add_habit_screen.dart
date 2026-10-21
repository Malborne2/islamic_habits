import 'package:flutter/material.dart';
import 'package:islamic_habits/utility/constants.dart';
import 'package:islamic_habits/utility/data_access_object.dart';
import 'package:islamic_habits/utility/habit.dart';

const List<String> _kWeekdayShortNames = [
  'Mon',
  'Tue',
  'Wed',
  'Thu',
  'Fri',
  'Sat',
  'Sun',
];

class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({super.key});
  @override
  _AddHabitScreenState createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _targetValueController = TextEditingController();
  final _unitController = TextEditingController(text: 'pages');
  final _streakTargetController = TextEditingController(text: '40');
  final _timesPerWeekController = TextEditingController(text: '3');

  HabitType _type = HabitType.YES_NO;
  HabitDays _habitDays = HabitDays.EVERYDAY;
  final Set<int> _selectedWeekdays = {};
  Color _selectedColor = kHabitColors[0];
  String? _scheduleError;

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
    final isValid = _formKey.currentState!.validate();
    setState(() {
      _scheduleError = _habitDays == HabitDays.DAYS_OF_WEEK &&
              _selectedWeekdays.isEmpty
          ? 'Pick at least one day of the week'
          : null;
    });
    if (!isValid || _scheduleError != null) return;

    final habit = Habit(
      name: _nameController.text.trim(),
      color: _selectedColor,
      type: _type,
      criteria: Criteria.AT_LEAST,
      successValue:
          _type == HabitType.YES_NO ? 1 : double.parse(_targetValueController.text),
      successTarget: int.tryParse(_streakTargetController.text) ?? 40,
      habitDays: _habitDays,
      habitPeriod: _habitDays == HabitDays.DAYS_OF_WEEK
          ? (_selectedWeekdays.toList()..sort())
          : _habitDays == HabitDays.TIMES_PER_WEEK
              ? [int.parse(_timesPerWeekController.text)]
              : null,
      numberUnit:
          _unitController.text.trim().isEmpty ? 'pages' : _unitController.text.trim(),
    );
    await HabitDao().addHabit(habit);
    if (mounted) Navigator.pop(context, habit);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add new habit')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            TextFormField(
              controller: _nameController,
              decoration: kTextFieldDecoration.copyWith(labelText: 'Habit name'),
              validator: (value) =>
                  (value == null || value.trim().isEmpty) ? 'Enter a name' : null,
            ),
            const SizedBox(height: 24),
            const Text('Success metric',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SegmentedButton<HabitType>(
              segments: const [
                ButtonSegment(value: HabitType.YES_NO, label: Text('Yes / No')),
                ButtonSegment(value: HabitType.NUMBER, label: Text('Number')),
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
                          kTextFieldDecoration.copyWith(labelText: 'Target amount'),
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
                      decoration: kTextFieldDecoration.copyWith(labelText: 'Unit'),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 24),
            const Text('Streak target',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _streakTargetController,
              keyboardType: TextInputType.number,
              decoration:
                  kTextFieldDecoration.copyWith(labelText: 'Target streak (days)'),
              validator: (value) {
                final parsed = int.tryParse(value ?? '');
                if (parsed == null || parsed <= 0) return 'Enter a number > 0';
                return null;
              },
            ),
            const SizedBox(height: 24),
            const Text('Schedule', style: TextStyle(fontWeight: FontWeight.bold)),
            RadioListTile<HabitDays>(
              contentPadding: EdgeInsets.zero,
              title: const Text('Every day'),
              value: HabitDays.EVERYDAY,
              groupValue: _habitDays,
              onChanged: (value) => setState(() => _habitDays = value!),
            ),
            RadioListTile<HabitDays>(
              contentPadding: EdgeInsets.zero,
              title: const Text('Certain days of the week'),
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
                    label: Text(_kWeekdayShortNames[i]),
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
              title: const Text('A number of times per week'),
              value: HabitDays.TIMES_PER_WEEK,
              groupValue: _habitDays,
              onChanged: (value) => setState(() => _habitDays = value!),
            ),
            if (_habitDays == HabitDays.TIMES_PER_WEEK)
              TextFormField(
                controller: _timesPerWeekController,
                keyboardType: TextInputType.number,
                decoration:
                    kTextFieldDecoration.copyWith(labelText: 'Times per week'),
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
            const Text('Color', style: TextStyle(fontWeight: FontWeight.bold)),
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
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text('Save habit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
