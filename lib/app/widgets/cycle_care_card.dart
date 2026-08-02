import 'package:flutter/material.dart';

import '../design/cycle_care_design.dart';

class CycleCareCard extends StatelessWidget {
  const CycleCareCard({
    required this.child,
    this.padding = const EdgeInsets.all(CycleCareSpacing.lg),
    this.color,
    this.onTap,
    this.semanticLabel,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final VoidCallback? onTap;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final content = Material(
      color: color ?? Colors.white.withValues(alpha: 0.92),
      borderRadius: CycleCareRadius.cardBorder,
      child: InkWell(
        onTap: onTap,
        borderRadius: CycleCareRadius.cardBorder,
        child: Padding(padding: padding, child: child),
      ),
    );
    return Semantics(
      container: true,
      button: onTap != null,
      label: semanticLabel,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: CycleCareRadius.cardBorder,
          boxShadow: const [
            BoxShadow(
              color: Color(0x120F172A),
              blurRadius: 24,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: content,
      ),
    );
  }
}
