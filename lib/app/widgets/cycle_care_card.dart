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
    final colors = context.cycleCareColors;
    final content = Material(
      color: color ?? colors.surfaceTranslucent,
      shape: RoundedRectangleBorder(
        borderRadius: CycleCareRadius.cardBorder,
        side: BorderSide(color: colors.divider),
      ),
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
      child: content,
    );
  }
}
