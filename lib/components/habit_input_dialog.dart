import 'package:flutter/material.dart';
import 'package:islamic_habits/l10n/generated/app_localizations.dart';
import 'package:islamic_habits/utility/constants.dart';
import 'round_icon_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:islamic_habits/utility/decimalTextInputFormatter.dart';
import 'package:islamic_habits/utility/habit_name_localizer.dart';
import 'dart:async';

class HabitInputDialog extends StatefulWidget {
  final double? initialValue;
  final String unit;
  const HabitInputDialog({super.key, required this.initialValue, this.unit = ''});
  @override
  _HabitInputDialogState createState() => _HabitInputDialogState();
}

class _HabitInputDialogState extends State<HabitInputDialog> {
  final TextEditingController _controller = TextEditingController();
  late double value;
  Timer? _holdTimer;

  @override
  void initState() {
    value = widget.initialValue ?? 0;
    _controller.text = value.toString();
    super.initState();
  }

  @override
  void dispose() {
    _holdTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _step(bool increment) {
    setState(() {
      if (increment) {
        value++;
      } else if (value > 0) {
        value--;
      }
      _controller.text = value.toStringAsFixed(1);
    });
  }

  void _startRepeat(bool increment) {
    _holdTimer = Timer.periodic(
        const Duration(milliseconds: 100), (t) => _step(increment));
  }

  void _stopRepeat() {
    _holdTimer?.cancel();
  }

  void _confirmDelete() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final l10n = AppLocalizations.of(context);
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(l10n.deleteEntryTitle),
          content: Text(l10n.deleteEntryConfirm),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context, value);
              },
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context, null);
              },
              style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error),
              child: Text(l10n.delete),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              widget.unit.isEmpty
                  ? l10n.setValueTitle
                  : l10n.setUnitTitle(localizedUnit(context, widget.unit)),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            TextFormField(
              style: const TextStyle(fontSize: 22),
              controller: _controller,
              textAlign: TextAlign.center,
              cursorColor: brandAccent(context),
              decoration: habitTextFieldDecoration(context),
              onChanged: (v) {
                setState(() {
                  value = double.tryParse(v) ?? value;
                });
              },
              keyboardType: TextInputType.number,
              inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RoundIconButton(
                  onTap: () => _step(true),
                  onLongPressStart: () => _startRepeat(true),
                  onLongPressEnd: _stopRepeat,
                  icon: FontAwesomeIcons.plus,
                ),
                RoundIconButton(
                  onTap: () => _step(false),
                  onLongPressStart: () => _startRepeat(false),
                  onLongPressEnd: _stopRepeat,
                  icon: FontAwesomeIcons.minus,
                ),
              ],
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(context, value),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(l10n.setValue),
              ),
            ),
            const SizedBox(height: 10),
            // Delete and Cancel share the same outlined style so their
            // weight reads as equal; only the color tells them apart —
            // error-red for the destructive action, neutral for the
            // no-op one.
            Row(
              children: <Widget>[
                Expanded(
                  child: OutlinedButton(
                    onPressed: _confirmDelete,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.error,
                      side: BorderSide(
                          color: Theme.of(context).colorScheme.error),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text(l10n.delete),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () =>
                        Navigator.pop(context, widget.initialValue),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text(l10n.cancel),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
