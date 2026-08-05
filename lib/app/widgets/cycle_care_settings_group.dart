import 'package:flutter/material.dart';

import '../design/cycle_care_design.dart';
import 'cycle_care_section_header.dart';

class CycleCareSectionGroup extends StatelessWidget {
  const CycleCareSectionGroup({
    required this.title,
    this.subtitle,
    this.action,
    required this.children,
    this.padding = const EdgeInsets.fromLTRB(
      CycleCareSpacing.lg,
      CycleCareSpacing.md,
      CycleCareSpacing.lg,
      CycleCareSpacing.md,
    ),
    super.key,
  });

  final String title;
  final String? subtitle;
  final Widget? action;
  final List<Widget> children;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[
      CycleCareSectionHeader(
        title: title,
        subtitle: subtitle,
        action: action,
      ),
      const SizedBox(height: CycleCareSpacing.sm),
      for (var i = 0; i < children.length; i++) ...[
        children[i],
        if (i != children.length - 1)
          const SizedBox(height: CycleCareSpacing.sm),
      ],
    ];
    return Semantics(
      container: true,
      label: title,
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: rows,
        ),
      ),
    );
  }
}

class CycleCareSettingsTile extends StatelessWidget {
  const CycleCareSettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.semanticLabel,
    this.destructive = false,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final String? semanticLabel;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foreground =
        destructive ? theme.colorScheme.error : theme.colorScheme.onSurface;
    final accent = destructive
        ? theme.colorScheme.error.withValues(alpha: 0.12)
        : theme.colorScheme.primary.withValues(alpha: 0.10);
    return Semantics(
      button: onTap != null,
      label:
          semanticLabel ?? [title, if (subtitle != null) subtitle!].join('. '),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: CycleCareRadius.mediumBorder,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: CycleCareSpacing.md,
              vertical: CycleCareSpacing.sm,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: BorderRadius.circular(CycleCareRadius.pill),
                  ),
                  child: Icon(icon, size: 20, color: foreground),
                ),
                const SizedBox(width: CycleCareSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: foreground,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: CycleCareSpacing.sm),
                  trailing!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
