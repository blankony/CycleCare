import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../design/cycle_care_design.dart';
import 'cycle_care_card.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.title,
    required this.message,
    this.action,
    this.icon = Icons.calendar_month_outlined,
    super.key,
  });

  final String title;
  final String message;
  final Widget? action;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(CycleCareSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 34,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(height: CycleCareSpacing.md),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: CycleCareSpacing.xs),
              Text(message, textAlign: TextAlign.center),
              if (action != null) ...[
                const SizedBox(height: CycleCareSpacing.lg),
                action!,
              ],
            ],
          ),
        ),
      );
}

class CycleCareLoadingState extends StatelessWidget {
  const CycleCareLoadingState({
    this.message = 'Preparing your cycle…',
    this.cardCount = 3,
    super.key,
  });

  final String message;
  final int cardCount;

  @override
  Widget build(BuildContext context) => Semantics(
        liveRegion: true,
        label: message,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            CycleCareSpacing.page,
            CycleCareSpacing.lg,
            CycleCareSpacing.page,
            112,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SkeletonBlock(
                    width: 180,
                    height: 28,
                    color: context.cycleCareColors.surfaceMuted,
                  ),
                  const SizedBox(height: CycleCareSpacing.xs),
                  Text(message, style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: CycleCareSpacing.xl),
                  for (var index = 0; index < cardCount; index++) ...[
                    CycleCareCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SkeletonBlock(
                            width: index == 0 ? 150 : 110,
                            height: 18,
                            color: context.cycleCareColors.surfaceMuted,
                          ),
                          const SizedBox(height: CycleCareSpacing.md),
                          _SkeletonBlock(
                            width: double.infinity,
                            height: index == 0 ? 92 : 54,
                            color: context.cycleCareColors.surfaceMuted,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: CycleCareSpacing.md),
                  ],
                ],
              ),
            ),
          ),
        ),
      );
}

class CycleCareErrorState extends StatelessWidget {
  const CycleCareErrorState({
    required this.message,
    required this.onRetry,
    this.title,
    super.key,
  });

  final String? title;
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return EmptyState(
        icon: Icons.cloud_off_outlined,
        title: title ?? l10n.homeInsufficientDataTitle,
        message: message,
        action: FilledButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh),
          label: Text(l10n.commonRetry),
        ),
      );
  }
}

class CycleCareOfflineState extends StatelessWidget {
  const CycleCareOfflineState({
    required this.message,
    this.action,
    super.key,
  });

  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) => EmptyState(
        icon: Icons.cloud_off_outlined,
        title: 'Offline',
        message: message,
        action: action,
      );
}

class _SkeletonBlock extends StatelessWidget {
  const _SkeletonBlock({
    required this.width,
    required this.height,
    required this.color,
  });

  final double width;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: CycleCareRadius.mediumBorder,
          ),
        ),
      );
}
