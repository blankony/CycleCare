import 'package:flutter/material.dart';

import '../design/cycle_care_design.dart';

class CycleCareBackground extends StatelessWidget {
  const CycleCareBackground({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: const BoxDecoration(gradient: CycleCareColors.backgroundGradient),
        child: CustomPaint(
          painter: const _CycleCareBackgroundPainter(),
          child: child,
        ),
      );
}

class _CycleCareBackgroundPainter extends CustomPainter {
  const _CycleCareBackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final shapes = [
      (Offset(size.width * 0.08, size.height * 0.16), size.width * 0.32,
          CycleCareColors.prediction.withValues(alpha: 0.10)),
      (Offset(size.width * 0.92, size.height * 0.30), size.width * 0.36,
          CycleCareColors.fertile.withValues(alpha: 0.12)),
      (Offset(size.width * 0.20, size.height * 0.84), size.width * 0.26,
          CycleCareColors.peach.withValues(alpha: 0.10)),
    ];
    for (final shape in shapes) {
      canvas.drawCircle(shape.$1, shape.$2, Paint()..color = shape.$3);
    }
  }

  @override
  bool shouldRepaint(covariant _CycleCareBackgroundPainter oldDelegate) => false;
}
