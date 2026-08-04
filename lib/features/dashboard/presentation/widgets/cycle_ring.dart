import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../app/design/cycle_care_design.dart';

class CycleRingSegment {
  const CycleRingSegment({
    required this.start,
    required this.end,
    required this.color,
  });

  final double start;
  final double end;
  final Color color;

  @override
  bool operator ==(Object other) =>
      other is CycleRingSegment &&
      start == other.start &&
      end == other.end &&
      color == other.color;

  @override
  int get hashCode => Object.hash(start, end, color);
}

class CycleRingData {
  const CycleRingData({
    required this.title,
    required this.subtitle,
    required this.semanticLabel,
    this.todayProgress,
    this.ovulationProgress,
    this.segments = const [],
    this.centerIcon = Icons.favorite_rounded,
  });

  final String title;
  final String subtitle;
  final String semanticLabel;
  final double? todayProgress;
  final double? ovulationProgress;
  final List<CycleRingSegment> segments;
  final IconData centerIcon;

  @override
  bool operator ==(Object other) =>
      other is CycleRingData &&
      title == other.title &&
      subtitle == other.subtitle &&
      semanticLabel == other.semanticLabel &&
      todayProgress == other.todayProgress &&
      ovulationProgress == other.ovulationProgress &&
      _segmentsEqual(segments, other.segments) &&
      centerIcon == other.centerIcon;

  @override
  int get hashCode => Object.hash(
        title,
        subtitle,
        semanticLabel,
        todayProgress,
        ovulationProgress,
        Object.hashAll(segments),
        centerIcon,
      );
}

class CycleRing extends StatelessWidget {
  const CycleRing({required this.data, super.key});

  final CycleRingData data;

  @override
  Widget build(BuildContext context) => Semantics(
        container: true,
        image: true,
        label: data.semanticLabel,
        child: ExcludeSemantics(
          child: TweenAnimationBuilder<double>(
            tween: Tween(end: 1),
            duration: CycleCareMotion.slow,
            curve: CycleCareMotion.curve,
            builder: (context, progress, child) => CustomPaint(
              painter: _CycleRingPainter(data: data, progress: progress),
              child: child,
            ),
            child: Center(
              child: FractionallySizedBox(
                widthFactor: 0.58,
                heightFactor: 0.58,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.94),
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x100F172A),
                        blurRadius: 24,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(CycleCareSpacing.md),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: CycleCareColors.periodSoft,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              data.centerIcon,
                              size: 21,
                              color: CycleCareColors.periodStrong,
                            ),
                          ),
                          const SizedBox(height: CycleCareSpacing.xs),
                          Text(
                            data.title,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: CycleCareSpacing.xxs),
                          SizedBox(
                            width: 150,
                            child: Text(
                              data.subtitle,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}

class _CycleRingPainter extends CustomPainter {
  const _CycleRingPainter({required this.data, required this.progress});

  final CycleRingData data;
  final double progress;

  static const _startAngle = -math.pi / 2;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final strokeWidth = math.max(14.0, size.shortestSide * 0.055);
    final radius = size.shortestSide / 2 - strokeWidth * 1.3;
    final rect = Rect.fromCircle(center: center, radius: radius);

    canvas.drawArc(
      rect,
      0,
      math.pi * 2,
      false,
      Paint()
        ..color = CycleCareColors.divider.withValues(alpha: 0.72)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );

    for (var index = 0; index < 28; index++) {
      final angle = _startAngle + math.pi * 2 * index / 28;
      final inner = Offset(
        center.dx + math.cos(angle) * (radius - strokeWidth * 1.08),
        center.dy + math.sin(angle) * (radius - strokeWidth * 1.08),
      );
      final outer = Offset(
        center.dx + math.cos(angle) * (radius - strokeWidth * 0.78),
        center.dy + math.sin(angle) * (radius - strokeWidth * 0.78),
      );
      canvas.drawLine(
        inner,
        outer,
        Paint()
          ..color = CycleCareColors.textSecondary.withValues(alpha: 0.18)
          ..strokeWidth = 1.2,
      );
    }

    for (final segment in data.segments) {
      final start = segment.start.clamp(0.0, 1.0);
      final end = segment.end.clamp(0.0, 1.0);
      if (end <= start) continue;
      canvas.drawArc(
        rect,
        _startAngle + math.pi * 2 * start,
        math.pi * 2 * (end - start) * progress,
        false,
        Paint()
          ..color = segment.color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round,
      );
    }

    final ovulation = data.ovulationProgress;
    if (ovulation != null) {
      _drawMarker(
        canvas,
        center,
        radius,
        ovulation * progress,
        CycleCareColors.ovulation,
        strokeWidth * 0.36,
      );
    }
    final today = data.todayProgress;
    if (today != null) {
      _drawMarker(
        canvas,
        center,
        radius,
        today * progress,
        Colors.white,
        strokeWidth * 0.42,
        borderColor: CycleCareColors.textPrimary,
      );
    }
  }

  void _drawMarker(
    Canvas canvas,
    Offset center,
    double radius,
    double position,
    Color color,
    double markerRadius, {
    Color? borderColor,
  }) {
    final angle = _startAngle + math.pi * 2 * position.clamp(0.0, 1.0);
    final marker = Offset(
      center.dx + math.cos(angle) * radius,
      center.dy + math.sin(angle) * radius,
    );
    canvas.drawCircle(marker, markerRadius + 3, Paint()..color = Colors.white);
    canvas.drawCircle(marker, markerRadius, Paint()..color = color);
    if (borderColor != null) {
      canvas.drawCircle(
        marker,
        markerRadius,
        Paint()
          ..color = borderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CycleRingPainter oldDelegate) =>
      oldDelegate.data != data || oldDelegate.progress != progress;
}

bool _segmentsEqual(
    List<CycleRingSegment> first, List<CycleRingSegment> second) {
  if (identical(first, second)) return true;
  if (first.length != second.length) return false;
  for (var index = 0; index < first.length; index++) {
    if (first[index] != second[index]) return false;
  }
  return true;
}
