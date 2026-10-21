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
  late Timer timer;

  @override
  void initState() {
    value = widget.initialValue ?? 0;
    _controller.text = value.toString();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
              cursorColor: Colors.deepPurple,
              decoration: kTextFieldDecoration,
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
                  onTapDown: (TapDownDetails details) {
                    timer = Timer.periodic(const Duration(milliseconds: 100),
                        (t) {
                      setState(() {
                        value++;
                        _controller.text = value.toStringAsFixed(1);
                      });
                    });
                  },
                  onTapUp: (TapUpDetails details) => timer.cancel(),
                  onTapCancel: () => timer.cancel(),
                  icon: FontAwesomeIcons.plus,
                ),
                RoundIconButton(
                  onTapDown: (TapDownDetails details) {
                    timer = Timer.periodic(const Duration(milliseconds: 100),
                        (t) {
                      setState(() {
                        if (value > 0) {
                          value--;
                          _controller.text = value.toStringAsFixed(1);
                        }
                      });
                    });
                  },
                  onTapUp: (TapUpDetails details) => timer.cancel(),
                  onTapCancel: () => timer.cancel(),
                  icon: FontAwesomeIcons.minus,
                ),
              ],
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, value),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(l10n.setValue),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: <Widget>[
                Expanded(
                  child: OutlinedButton(
                    onPressed: _confirmDelete,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text(l10n.delete),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context, widget.initialValue),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
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
