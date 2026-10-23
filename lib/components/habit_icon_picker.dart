import 'package:flutter/material.dart';
import 'package:islamic_habits/l10n/generated/app_localizations.dart';
import 'package:islamic_habits/utility/habit_icons.dart';

// Wraps the dialog's result so "remove the icon" (codePoint == null) can be
// told apart from "dismissed without choosing" (null result).
class HabitIconChoice {
  final int? codePoint;
  const HabitIconChoice(this.codePoint);
}

Future<HabitIconChoice?> showHabitIconPicker(
  BuildContext context, {
  int? selectedCodePoint,
  Color? tint,
}) {
  return showDialog<HabitIconChoice>(
    context: context,
    builder: (context) => _HabitIconPickerDialog(
      selectedCodePoint: selectedCodePoint,
      tint: tint,
    ),
  );
}

class _HabitIconPickerDialog extends StatelessWidget {
  final int? selectedCodePoint;
  final Color? tint;
  const _HabitIconPickerDialog({this.selectedCodePoint, this.tint});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    // Icons default to the habit's own color, so the picker previews exactly
    // how the icon will look on the habit row.
    final Color iconColor = tint ?? theme.colorScheme.primary;
    final double maxHeight = MediaQuery.sizeOf(context).height * 0.62;

    return AlertDialog(
      title: Text(l10n.chooseIcon),
      contentPadding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      content: SizedBox(
        width: 420,
        height: maxHeight,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final int columns =
                (constraints.maxWidth / 62).floor().clamp(4, 8);
            return GridView.builder(
              padding: const EdgeInsets.only(bottom: 8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                mainAxisSpacing: 6,
                crossAxisSpacing: 6,
              ),
              itemCount: kHabitIcons.length,
              itemBuilder: (context, index) {
                final option = kHabitIcons[index];
                final bool selected = option.icon.codePoint == selectedCodePoint;
                return Tooltip(
                  message: option.label,
                  child: Semantics(
                    button: true,
                    selected: selected,
                    label: option.label,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () => Navigator.pop(
                        context,
                        HabitIconChoice(option.icon.codePoint),
                      ),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 140),
                        decoration: BoxDecoration(
                          color: selected
                              ? iconColor.withValues(alpha: 0.16)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: selected
                                ? iconColor
                                : theme.dividerColor.withValues(alpha: 0.45),
                            width: selected ? 2 : 1,
                          ),
                        ),
                        child: Icon(
                          option.icon,
                          size: 26,
                          color: iconColor,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      actions: <Widget>[
        if (selectedCodePoint != null)
          TextButton(
            onPressed: () =>
                Navigator.pop(context, const HabitIconChoice(null)),
            child: Text(l10n.removeIcon),
          ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
      ],
    );
  }
}
