import 'package:decibel_meter/l10n/generated/app_localizations.dart';
import 'package:decibel_meter/theme/app_palette.dart';
import 'package:flutter/material.dart';

class ThemeGuideLayer extends StatefulWidget {
  const ThemeGuideLayer({
    super.key,
    required this.target,
    required this.activePalette,
    required this.onDismiss,
  });

  final Rect target;
  final AppPalette activePalette;
  final VoidCallback onDismiss;

  @override
  State<ThemeGuideLayer> createState() => _ThemeGuideLayerState();
}

class _ThemeGuideLayerState extends State<ThemeGuideLayer>
    with TickerProviderStateMixin {
  late final AnimationController _fade;
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _fade = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    )..forward();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();
  }

  @override
  void dispose() {
    _fade.dispose();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final hole = widget.target.inflate(8);

    return FadeTransition(
      opacity: CurvedAnimation(parent: _fade, curve: Curves.easeOut),
      child: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: widget.onDismiss,
              child: AnimatedBuilder(
                animation: _pulse,
                builder: (context, _) {
                  return CustomPaint(
                    size: Size.infinite,
                    painter: _SpotlightPainter(
                      hole: hole,
                      dimColor: Colors.black.withValues(alpha: 0.42),
                      pulse: _pulse.value,
                      ringColor: colorScheme.primary.withValues(alpha: 0.9),
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            left: 12,
            right: 12,
            top: hole.bottom + 4,
            child: Align(
              alignment: AlignmentDirectional.topStart,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 276),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 18),
                      child: CustomPaint(
                        size: const Size(16, 8),
                        painter: _BubbleTailPainter(color: colorScheme.surface),
                      ),
                    ),
                    Material(
                      color: colorScheme.surface,
                      elevation: 8,
                      shadowColor: Colors.black.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(18),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.themeGuideTitle,
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              l10n.themeGuideBody,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    height: 1.45,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                for (final palette in AppPalette.values) ...[
                                  _GuideSwatch(
                                    palette: palette,
                                    selected: palette == widget.activePalette,
                                  ),
                                  if (palette != AppPalette.values.last)
                                    const SizedBox(width: 6),
                                ],
                                const Spacer(),
                                TextButton(
                                  onPressed: widget.onDismiss,
                                  style: TextButton.styleFrom(
                                    visualDensity: VisualDensity.compact,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                  ),
                                  child: Text(l10n.themeGotIt),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GuideSwatch extends StatelessWidget {
  const _GuideSwatch({required this.palette, required this.selected});

  final AppPalette palette;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final spec = paletteSpecs[palette]!;
    final color = palette == AppPalette.paper
        ? const Color(0xFFE6D3B0)
        : spec.primary;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
      width: selected ? 18 : 12,
      height: selected ? 18 : 12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(
          color: selected
              ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.28)
              : Colors.transparent,
          width: selected ? 2 : 0,
        ),
      ),
    );
  }
}

class _BubbleTailPainter extends CustomPainter {
  const _BubbleTailPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _BubbleTailPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class _SpotlightPainter extends CustomPainter {
  const _SpotlightPainter({
    required this.hole,
    required this.dimColor,
    required this.pulse,
    required this.ringColor,
  });

  final Rect hole;
  final Color dimColor;
  final double pulse;
  final Color ringColor;

  @override
  void paint(Canvas canvas, Size size) {
    final overlay = Path()..addRect(Offset.zero & size);
    final cut = Path()..addOval(hole);
    canvas.drawPath(
      Path.combine(PathOperation.difference, overlay, cut),
      Paint()..color = dimColor,
    );

    final center = hole.center;
    for (final start in const [0.0, 0.5]) {
      final t = (pulse + start) % 1.0;
      final radius = hole.width / 2 + 6 + (22 * t);
      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..color = ringColor.withValues(alpha: (1 - t) * 0.42)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SpotlightPainter oldDelegate) {
    return oldDelegate.hole != hole ||
        oldDelegate.dimColor != dimColor ||
        oldDelegate.pulse != pulse ||
        oldDelegate.ringColor != ringColor;
  }
}
