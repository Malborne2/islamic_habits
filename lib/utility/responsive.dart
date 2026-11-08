import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Material 3 window size classes, in logical pixels.
///
/// Compact: phones in portrait (< 600)
/// Medium: small tablets / foldables (600–839)
/// Expanded: tablets (840–1199)
/// Large: large tablets / desktop (>= 1200)
class AppBreakpoints {
  const AppBreakpoints._();

  static const double compact = 600;
  static const double medium = 840;
  static const double expanded = 1200;
  static const double large = 1600;
}

/// True when the window is at least tablet width (Material "expanded").
bool isTabletWidth(BuildContext context) =>
    MediaQuery.sizeOf(context).width >= AppBreakpoints.medium;

/// True when the window is wide enough for two content columns.
bool isWideLayout(BuildContext context) =>
    MediaQuery.sizeOf(context).width >= AppBreakpoints.medium;

/// Centers [child] and caps its width so forms, lists, and cards do not
/// stretch edge-to-edge on tablets. The child still fills the width on
/// phones, and gets a tight width so `Row`/`Column` stretch layouts behave
/// exactly as they do inside a full-width body.
class ContentWidth extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final Alignment alignment;
  final EdgeInsetsGeometry? padding;

  const ContentWidth({
    super.key,
    required this.child,
    this.maxWidth = 720,
    this.alignment = Alignment.topCenter,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final available = constraints.maxWidth;
        final width =
            available.isFinite && available < maxWidth ? available : maxWidth;
        Widget content = child;
        if (padding != null) {
          content = Padding(padding: padding!, child: content);
        }
        return Align(
          alignment: alignment,
          child: SizedBox(width: width, child: content),
        );
      },
    );
  }
}

/// A responsive two-column row that stacks vertically below [breakpoint].
/// [leftFlex] / [rightFlex] let the caller give one side more room.
class ResponsiveTwoColumn extends StatelessWidget {
  final Widget left;
  final Widget right;
  final double breakpoint;
  final double gap;
  final int leftFlex;
  final int rightFlex;
  final CrossAxisAlignment crossAxisAlignment;

  const ResponsiveTwoColumn({
    super.key,
    required this.left,
    required this.right,
    this.breakpoint = AppBreakpoints.medium,
    this.gap = 16,
    this.leftFlex = 1,
    this.rightFlex = 1,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < breakpoint) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              left,
              SizedBox(height: gap),
              right,
            ],
          );
        }
        return Row(
          crossAxisAlignment: crossAxisAlignment,
          children: <Widget>[
            Expanded(flex: leftFlex, child: left),
            SizedBox(width: gap),
            Expanded(flex: rightFlex, child: right),
          ],
        );
      },
    );
  }
}

/// Lays [children] out in a wrapping grid with at least [minItemWidth] per
/// item, up to [maxColumns]. On phones this is a single column.
class ResponsiveCardGrid extends StatelessWidget {
  final List<Widget> children;
  final double minItemWidth;
  final double maxWidth;
  final double spacing;
  final int maxColumns;

  const ResponsiveCardGrid({
    super.key,
    required this.children,
    this.minItemWidth = 340,
    this.maxWidth = 1400,
    this.spacing = 14,
    this.maxColumns = 2,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final available = constraints.maxWidth.isFinite
            ? constraints.maxWidth.clamp(0.0, maxWidth)
            : maxWidth;
        final possible = math.max(
          1,
          math.min(
            maxColumns,
            ((available + spacing) / (minItemWidth + spacing)).floor(),
          ),
        );
        final itemWidth = (available - spacing * (possible - 1)) / possible;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: <Widget>[
            for (final child in children)
              SizedBox(width: itemWidth, child: child),
          ],
        );
      },
    );
  }
}
