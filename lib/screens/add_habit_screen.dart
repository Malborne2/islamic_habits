import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:islamic_habits/components/habit_icon_picker.dart';
import 'package:islamic_habits/l10n/generated/app_localizations.dart';
import 'package:islamic_habits/utility/constants.dart';
import 'package:islamic_habits/utility/data_access_object.dart';
import 'package:islamic_habits/utility/habit.dart';
import 'package:islamic_habits/utility/habit_icons.dart';
import 'package:islamic_habits/utility/notification_service.dart';

List<String> _weekdayShortNames(AppLocalizations l10n) => [
      l10n.weekdayMonShort,
      l10n.weekdayTueShort,
      l10n.weekdayWedShort,
      l10n.weekdayThuShort,
      l10n.weekdayFriShort,
      l10n.weekdaySatShort,
      l10n.weekdaySunShort,
    ];

String _formatTimeOfDay(BuildContext context, TimeOfDay time) {
  return MaterialLocalizations.of(context).formatTimeOfDay(
    time,
    alwaysUse24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context),
  );
}

String _colorHex(Color color) {
  final hex = color.toARGB32().toRadixString(16).padLeft(8, '0');
  return '#${hex.substring(2).toUpperCase()}';
}

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
  late int? _selectedIcon = widget.editingHabit == null
      ? null
      : habitIconCodePoint(widget.editingHabit!);
  late Color _customColor = widget.editingHabit != null &&
          !kHabitColors.contains(widget.editingHabit!.color)
      ? widget.editingHabit!.color
      : kBrandBlueDeep;
  bool _customSelected = false;

  // Habit reminders are created and edited on this screen, which is also the
  // screen opened by the habit detail page's edit button. Turning the switch
  // off keeps the chosen time so it can be re-enabled without re-picking it.
  late bool _reminderEnabled = widget.editingHabit?.reminderEnabled ?? false;
  late TimeOfDay _reminderTime =
      widget.editingHabit?.reminderTime ?? const TimeOfDay(hour: 21, minute: 0);

  String? _scheduleError;

  bool get _isEditing => widget.editingHabit != null;

  @override
  void initState() {
    super.initState();
    _customSelected = !kHabitColors.contains(_selectedColor);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _targetValueController.dispose();
    _unitController.dispose();
    _streakTargetController.dispose();
    _timesPerWeekController.dispose();
    super.dispose();
  }

  Future<void> _pickCustomColor() async {
    final l10n = AppLocalizations.of(context);
    Color selected = _selectedColor;
    final picked = await showDialog<Color>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(l10n.customColor),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      height: 58,
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: selected,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                      child: Text(
                        _colorHex(selected),
                        style: TextStyle(
                          color: foregroundOn(selected),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // A bounded height is required: ColorPicker sizes its
                    // wheel from the available height, and the dialog content
                    // is scrollable (so its height would otherwise be
                    // unbounded).
                    SizedBox(
                      height: 380,
                      child: ColorPicker(
                        pickerColor: selected,
                        onColorChanged: (color) {
                          setDialogState(() => selected = color);
                        },
                        enableAlpha: false,
                        hexInputBar: true,
                        paletteType: PaletteType.hsvWithHue,
                        labelTypes: const <ColorLabelType>[],
                        pickerAreaHeightPercent: 0.55,
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text(l10n.cancel),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(dialogContext, selected),
                  child: Text(l10n.selectColor),
                ),
              ],
            );
          },
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedColor = picked;
        _customColor = picked;
        _customSelected = true;
      });
    }
  }

  Future<void> _pickIcon() async {
    final choice = await showHabitIconPicker(
      context,
      selectedCodePoint: _selectedIcon,
      tint: _selectedColor,
    );
    if (choice != null) {
      setState(() => _selectedIcon = choice.codePoint);
    }
  }

  Future<void> _pickReminderTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
      helpText: AppLocalizations.of(context).reminderTimeLabel,
    );
    if (picked != null) {
      setState(() => _reminderTime = picked);
    }
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
        ..iconCodePoint = _selectedIcon
        ..type = _type
        ..successValue = successValue
        ..successTarget = successTarget
        ..habitDays = _habitDays
        ..habitPeriod = habitPeriod
        ..numberUnit = unit
        ..reminderEnabled = _reminderEnabled
        ..reminderMinutes =
            _reminderTime.hour * 60 + _reminderTime.minute;
      await HabitDao().updateHabit(habit);
    } else {
      habit = Habit(
        name: _nameController.text.trim(),
        color: _selectedColor,
        iconCodePoint: _selectedIcon,
        type: _type,
        criteria: Criteria.AT_LEAST,
        successValue: successValue,
        successTarget: successTarget,
        habitDays: _habitDays,
        habitPeriod: habitPeriod,
        numberUnit: unit,
        reminderEnabled: _reminderEnabled,
        reminderMinutes: _reminderEnabled
            ? _reminderTime.hour * 60 + _reminderTime.minute
            : null,
      );
      await HabitDao().addHabit(habit);
    }

    // The reminder's body uses the habit name and actions use its type, so
    // reschedule after edits as well as after creation.
    try {
      await NotificationService.scheduleHabitReminders();
    } catch (e) {
      debugPrint('[AddHabitScreen] Failed scheduling habit reminders: $e');
    }

    // Tell every screen holding a habit list (Home, drawer, All Habits,
    // statistics) to pick up the new values. Without this, a screen that was
    // pushed before the edit — and therefore isn't refreshed by MainScreen's
    // own reload — kept painting the old color/icon until it was reopened.
    NotificationService.habitDataRevision.value++;

    if (mounted) Navigator.pop(context, habit);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    if (!_unitDefaultSet) {
      _unitDefaultSet = true;
      if (_unitController.text.isEmpty) _unitController.text = l10n.unitPages;
    }
    return Scaffold(
      appBar: AppBar(
          title:
              Text(_isEditing ? l10n.editHabitTitle : l10n.navAddHabit)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            TextFormField(
              controller: _nameController,
              decoration: habitTextFieldDecoration(context)
                  .copyWith(labelText: l10n.habitName),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? l10n.enterName
                  : null,
            ),
            const SizedBox(height: 24),
            Text(l10n.successMetric,
                style: const TextStyle(fontWeight: FontWeight.bold)),
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
                      decoration: habitTextFieldDecoration(context)
                          .copyWith(labelText: l10n.targetAmountLabel),
                      validator: (value) {
                        if (_type != HabitType.NUMBER) return null;
                        final parsed = double.tryParse(value ?? '');
                        if (parsed == null || parsed <= 0) {
                          return l10n.enterNumberGreaterThanZero;
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _unitController,
                      decoration: habitTextFieldDecoration(context)
                          .copyWith(labelText: l10n.unitLabel),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 24),
            Text(l10n.streakTarget,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _streakTargetController,
              keyboardType: TextInputType.number,
              decoration: habitTextFieldDecoration(context)
                  .copyWith(labelText: l10n.targetStreakDays),
              validator: (value) {
                final parsed = int.tryParse(value ?? '');
                if (parsed == null || parsed <= 0) {
                  return l10n.enterNumberGreaterThanZero;
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            Text(l10n.schedule,
                style: const TextStyle(fontWeight: FontWeight.bold)),
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
                      style: TextStyle(color: theme.colorScheme.error)),
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
                decoration: habitTextFieldDecoration(context)
                    .copyWith(labelText: l10n.timesPerWeekLabel),
                validator: (value) {
                  if (_habitDays != HabitDays.TIMES_PER_WEEK) return null;
                  final parsed = int.tryParse(value ?? '');
                  if (parsed == null || parsed < 1 || parsed > 7) {
                    return l10n.enterNumberOneToSeven;
                  }
                  return null;
                },
              ),
            const SizedBox(height: 24),
            Text(l10n.color,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: <Widget>[
                ...kHabitColors.map((color) {
                  return _ColorSwatch(
                    color: color,
                    selected: !_customSelected && color == _selectedColor,
                    label: _colorHex(color),
                    onTap: () {
                      setState(() {
                        _selectedColor = color;
                        _customSelected = false;
                      });
                    },
                  );
                }),
                _ColorSwatch(
                  color: _customSelected ? _selectedColor : _customColor,
                  selected: _customSelected,
                  isCustom: true,
                  label: l10n.customColor,
                  onTap: _pickCustomColor,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(l10n.habitIcon,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: <Widget>[
                Container(
                  width: 46,
                  height: 46,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _selectedColor.withValues(alpha: 0.16),
                    shape: BoxShape.circle,
                    border: Border.all(color: theme.dividerColor),
                  ),
                  child: _selectedIcon == null
                      ? Center(
                          child: CircleAvatar(
                            radius: 6,
                            backgroundColor: _selectedColor,
                          ),
                        )
                      : Icon(
                          habitIconOptionForCodePoint(_selectedIcon)?.icon ??
                              Icons.help_outline,
                          color: _selectedColor,
                          size: 26,
                        ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: _pickIcon,
                  icon: const Icon(Icons.grid_view_rounded),
                  label: Text(l10n.chooseIcon),
                ),
                if (_selectedIcon != null) ...<Widget>[
                  const SizedBox(width: 4),
                  IconButton(
                    tooltip: l10n.removeIcon,
                    onPressed: () => setState(() => _selectedIcon = null),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 24),
            Text(l10n.reminderLabel,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              secondary: Icon(
                Icons.notifications_active_outlined,
                color: _reminderEnabled
                    ? brandAccent(context)
                    : theme.colorScheme.onSurfaceVariant,
              ),
              title: Text(l10n.reminderEnabledLabel),
              subtitle: Text(l10n.reminderEnabledSubtitle),
              value: _reminderEnabled,
              onChanged: (value) =>
                  setState(() => _reminderEnabled = value),
            ),
            if (_reminderEnabled)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.schedule, color: brandAccent(context)),
                title: Text(l10n.reminderTimeLabel),
                subtitle: Text(_formatTimeOfDay(context, _reminderTime)),
                trailing: const Icon(Icons.chevron_right),
                onTap: _pickReminderTime,
              ),
            if (_reminderEnabled)
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 4),
                child: Text(
                  l10n.reminderIndependentHint,
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.brightness == Brightness.dark
                      ? kBrandNavy
                      : theme.colorScheme.surface,
                  foregroundColor: theme.brightness == Brightness.dark
                      ? Colors.white
                      : theme.colorScheme.primary,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  // In dark mode the white outline separates the navy button
                  // from the near-black background. In light mode the button
                  // is a surface-coloured outlined button so the primary
                  // outline is actually visible against the fill.
                  side: BorderSide(
                    color: theme.brightness == Brightness.dark
                        ? Colors.white
                        : theme.colorScheme.primary,
                    width: 1.6,
                  ),
                ),
                child: Text(
                  l10n.saveHabit,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  final Color color;
  final bool selected;
  final bool isCustom;
  final String label;
  final VoidCallback onTap;

  const _ColorSwatch({
    required this.color,
    required this.selected,
    required this.label,
    required this.onTap,
    this.isCustom = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color onSurface = Theme.of(context).colorScheme.onSurface;
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: Tooltip(
        message: label,
        child: InkResponse(
          onTap: onTap,
          radius: 28,
          containedInkWell: true,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: isCustom && !selected ? null : color,
              gradient: isCustom && !selected
                  ? const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[
                        Color(0xFFEF4444),
                        Color(0xFFF59E0B),
                        Color(0xFF22C55E),
                        Color(0xFF0EA5E9),
                        Color(0xFFA855F7),
                      ],
                    )
                  : null,
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? onSurface : Colors.transparent,
                width: 3,
              ),
            ),
            child: Icon(
              selected
                  ? Icons.check
                  : (isCustom ? Icons.colorize : null),
              color: selected
                  ? foregroundOn(color)
                  : (isCustom ? Colors.white : null),
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
