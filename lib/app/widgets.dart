import 'package:flutter/material.dart';

import 'design/cycle_care_design.dart';

export 'widgets/cycle_care_background.dart';
export 'widgets/cycle_care_card.dart';
export 'widgets/cycle_care_section_header.dart';
export 'widgets/cycle_care_states.dart';
export 'widgets/cycle_care_status_chip.dart';

class CycleCareAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CycleCareAppBar({
    required this.title,
    this.actions = const <Widget>[],
    this.scrim = true,
    super.key,
  });

  final String title;
  final List<Widget> actions;

  /// Whether to paint a soft background scrim behind the app bar so the
  /// title stays legible while content scrolls underneath.
  final bool scrim;

  @override
  Widget build(BuildContext context) {
    final colors = context.cycleCareColors;
    final topInset = MediaQuery.paddingOf(context).top;
    return AppBar(
      title: Text(title),
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      actions: actions,
      flexibleSpace: scrim
          ? _CycleCareAppBarScrim(topInset: topInset)
          : null,
      iconTheme: IconThemeData(color: colors.textPrimary),
      titleTextStyle:
          Theme.of(context).textTheme.titleLarge?.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CycleCareAppBarScrim extends StatelessWidget {
  const _CycleCareAppBarScrim({required this.topInset});

  final double topInset;

  @override
  Widget build(BuildContext context) {
    final colors = context.cycleCareColors;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            colors.background,
            colors.background.withValues(alpha: 0.85),
            colors.background.withValues(alpha: 0.0),
          ],
          stops: const [0.0, 0.55, 1.0],
        ),
      ),
      child: SizedBox(
        height: kToolbarHeight + topInset,
        width: double.infinity,
      ),
    );
  }
}

class MedicalDisclaimer extends StatelessWidget {
  const MedicalDisclaimer({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.cycleCareColors;
    return Semantics(
      label:
          'Informasi medis. Prediksi CycleCare adalah perkiraan berdasarkan riwayat yang dicatat dan bukan diagnosis medis.',
      child: Container(
        padding: const EdgeInsets.all(CycleCareSpacing.md),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: CycleCareRadius.mediumBorder,
          border: Border.all(color: colors.divider),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.health_and_safety_outlined, size: 20),
            const SizedBox(width: CycleCareSpacing.sm),
            Expanded(
              child: Text(
                'Prediksi CycleCare adalah perkiraan berdasarkan riwayat yang dicatat, bukan diagnosis medis.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
