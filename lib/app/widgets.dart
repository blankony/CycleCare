import 'package:flutter/material.dart';

import 'design/cycle_care_design.dart';

export 'widgets/cycle_care_background.dart';
export 'widgets/cycle_care_card.dart';
export 'widgets/cycle_care_section_header.dart';

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
  Widget build(BuildContext context) => Semantics(
        label:
            'Informasi medis. Prediksi CycleCare adalah perkiraan berdasarkan riwayat yang dicatat dan bukan diagnosis medis.',
        child: Container(
          padding: const EdgeInsets.all(CycleCareSpacing.md),
          decoration: BoxDecoration(
            color: CycleCareColors.fertileSoft.withValues(alpha: 0.72),
            borderRadius: CycleCareRadius.mediumBorder,
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
                decoration: const BoxDecoration(
                  color: CycleCareColors.periodSoft,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 34, color: CycleCareColors.periodStrong),
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
  const CycleCareLoadingState({this.message = 'Menyiapkan siklusmu…', super.key});

  final String message;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(CycleCareSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: CycleCareSpacing.md),
              Text(message, textAlign: TextAlign.center),
            ],
          ),
        ),
      );
}

class CycleCareErrorState extends StatelessWidget {
  const CycleCareErrorState({
    required this.message,
    required this.onRetry,
    this.title = 'Data belum dapat dimuat',
    super.key,
  });

  final String title;
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => EmptyState(
        icon: Icons.cloud_off_outlined,
        title: title,
        message: message,
        action: FilledButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh),
          label: const Text('Coba lagi'),
        ),
      );
}
