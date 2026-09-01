import 'dart:math' as math;

import 'package:decibel_meter/theme/caju_style.dart';
import 'package:decibel_meter/theme/theme_controller.dart';
import 'package:flutter/material.dart';

class PaperFilterOverlay extends StatelessWidget {
  const PaperFilterOverlay({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final enabled =
        Theme.of(context).extension<CajuThemeExtras>()?.paperFilter ?? false;
    if (!enabled) return child;
    return ValueListenableBuilder<double>(
      valueListenable: ThemeScope.of(context).paperGrain,
      builder: (context, grain, _) => Stack(
        fit: StackFit.expand,
        children: [
          child,
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _PaperPainter(
                  grain: grain,
                  dark: Theme.of(context).brightness == Brightness.dark,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaperPainter extends CustomPainter {
  const _PaperPainter({required this.grain, required this.dark});
  final double grain;
  final bool dark;

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(2026);
    final amount = grain.clamp(0, 1);
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..color = (dark ? const Color(0xFFC4A574) : const Color(0xFFD4B896))
            .withValues(alpha: .04 + amount * .1),
    );
    final paint = Paint();
    final count = (size.width * size.height / (180 - amount * 100))
        .clamp(300, 3000)
        .toInt();
    for (var i = 0; i < count; i++) {
      paint.color =
          (random.nextBool()
                  ? (dark ? Colors.white : const Color(0xFF5D4037))
                  : (dark ? Colors.black : const Color(0xFFFFF8E8)))
              .withValues(alpha: .025 + amount * .16);
      canvas.drawCircle(
        Offset(
          random.nextDouble() * size.width,
          random.nextDouble() * size.height,
        ),
        .15 + random.nextDouble() * (.3 + amount * .5),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PaperPainter oldDelegate) =>
      oldDelegate.grain != grain || oldDelegate.dark != dark;
}
