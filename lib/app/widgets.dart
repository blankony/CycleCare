import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    this.centerTitle = true,
    super.key,
  });

  final String title;
  final List<Widget> actions;
  final bool scrim;
  final bool centerTitle;

  @override
  Widget build(BuildContext context) {
    final colors = context.cycleCareColors;
    final brandStyle = GoogleFonts.playfairDisplay(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      letterSpacing: 2.0,
      color: Theme.of(context).colorScheme.primary,
    );
    return AppBar(
      centerTitle: true,
      title: Text(
        title.toUpperCase(),
        style: brandStyle,
      ),
      backgroundColor: colors.background,
      surfaceTintColor: colors.background,
      elevation: 0,
      scrolledUnderElevation: 0,
      shadowColor: Colors.transparent,
      shape: Border(bottom: BorderSide(color: colors.divider)),
      actions: actions,
      iconTheme: IconThemeData(color: colors.textPrimary),
      titleTextStyle: brandStyle,
    );
  }

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
