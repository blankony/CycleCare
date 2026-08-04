import 'package:flutter/material.dart';

import 'design/cycle_care_design.dart';

export 'widgets/cycle_care_background.dart';
export 'widgets/cycle_care_card.dart';
export 'widgets/cycle_care_section_header.dart';
export 'widgets/cycle_care_states.dart';
export 'widgets/cycle_care_status_chip.dart';

class CycleCareAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CycleCareAppBar({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) => AppBar(
        title: Text(title),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      );

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
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
