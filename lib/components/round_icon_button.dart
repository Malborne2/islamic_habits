import 'package:flutter/material.dart';

class RoundIconButton extends StatefulWidget {
  final VoidCallback onTap;
  final VoidCallback onLongPressStart;
  final VoidCallback onLongPressEnd;
  final IconData icon;

  const RoundIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    required this.onLongPressStart,
    required this.onLongPressEnd,
  });

  @override
  State<RoundIconButton> createState() => _RoundIconButtonState();
}

class _RoundIconButtonState extends State<RoundIconButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    // A single GestureDetector so onTap and onLongPressStart/End stay
    // mutually exclusive (Flutter arbitrates that itself): nesting this
    // inside a RawMaterialButton/InkWell — each with its own tap
    // recognizer — was swallowing quick taps, which only the long-press
    // timer happened to survive.
    return GestureDetector(
      onTap: widget.onTap,
      onLongPressStart: (_) => widget.onLongPressStart(),
      onLongPressEnd: (_) => widget.onLongPressEnd(),
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: Builder(builder: (context) {
        final primary = Theme.of(context).colorScheme.primary;
        return AnimatedScale(
          scale: _pressed ? 0.92 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: primary.withValues(alpha: _pressed ? 0.7 : 0.85),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    color: primary.withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 2)),
              ],
            ),
            child: Icon(widget.icon,
                color: Theme.of(context).colorScheme.onPrimary),
          ),
        );
      }),
    );
  }
}
