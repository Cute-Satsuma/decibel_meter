import 'dart:io' show Platform;
import 'dart:math' as math;

import 'package:decibel_meter/l10n/generated/app_localizations.dart';
import 'package:decibel_meter/theme/app_palette.dart';
import 'package:decibel_meter/theme/palette_picker.dart';
import 'package:decibel_meter/theme/theme_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Desktop window layouts need scroll + row-based swatches; mobile keeps the
/// original grid picker that was already tuned for phone UI.
bool get _useDesktopThemePickerLayout {
  if (kIsWeb) return false;
  return Platform.isWindows || Platform.isLinux;
}

Future<void> showThemePickerDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    useRootNavigator: true,
    barrierDismissible: false,
    builder: (context) => const ThemePickerDialog(),
  );
}

class ThemePickerDialog extends StatelessWidget {
  const ThemePickerDialog({super.key});

  static String paletteLabel(AppLocalizations l10n, AppPalette palette) {
    return switch (palette) {
      AppPalette.orange => l10n.themeOrange,
      AppPalette.green => l10n.themeGreen,
      AppPalette.teal => l10n.themeTeal,
      AppPalette.blue => l10n.themeBlue,
      AppPalette.slate => l10n.themeSlate,
      AppPalette.paper => l10n.themePaper,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final controller = ThemeScope.of(context);
    final desktop = _useDesktopThemePickerLayout;
    final maxHeight = MediaQuery.sizeOf(context).height * 0.88;
    return PopScope(
      canPop: false,
      child: ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          final colorScheme = Theme.of(context).colorScheme;
          final body = Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.themePickerTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.themePickerBody,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  height: 1.45,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),
              if (desktop)
                PalettePickerRows(
                  selected: controller.palette,
                  l10n: l10n,
                  onSelect: (palette) =>
                      controller.setPalette(palette, persist: false),
                )
              else if (!kIsWeb && Platform.isMacOS)
                _MacPaletteGrid(
                  selected: controller.palette,
                  l10n: l10n,
                  onSelect: (palette) =>
                      controller.setPalette(palette, persist: false),
                )
              else
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.78,
                  children: [
                    for (final palette in AppPalette.values)
                      _PickerSwatch(
                        palette: palette,
                        label: paletteLabel(l10n, palette),
                        selected: controller.palette == palette,
                        onTap: () =>
                            controller.setPalette(palette, persist: false),
                      ),
                  ],
                ),
              const SizedBox(height: 16),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(12, 10, desktop ? 12 : 8, 10),
                  child: Row(
                    crossAxisAlignment: desktop
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          width: 44,
                          height: 44,
                          child: CustomPaint(
                            painter: _PaperPreviewPainter(
                              enabled: controller.paperFilter,
                              tint: colorScheme.primary,
                              dark:
                                  Theme.of(context).brightness ==
                                  Brightness.dark,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.themePaperFilter,
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              l10n.themePickerPaperBody,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    height: 1.35,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      if (desktop) const SizedBox(width: 8),
                      Switch(
                        value: controller.paperFilter,
                        materialTapTargetSize: desktop
                            ? MaterialTapTargetSize.shrinkWrap
                            : null,
                        onChanged: (value) => controller.setPaperFilter(
                          value,
                          persist: false,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  style: (!kIsWeb &&
                          (Platform.isMacOS ||
                              Platform.isWindows ||
                              Platform.isLinux))
                      ? FilledButton.styleFrom(
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          overlayColor: colorScheme.primary.withValues(
                            alpha: 0.10,
                          ),
                        )
                      : null,
                  onPressed: () async {
                    await controller.setPalette(controller.palette);
                    await controller.setPaperFilter(controller.paperFilter);
                    if (context.mounted) Navigator.pop(context);
                  },
                  child: Text(l10n.themePickerContinue),
                ),
              ),
            ],
          );

          return Dialog(
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 28,
              vertical: 24,
            ),
            child: desktop
                ? ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 380,
                      maxHeight: maxHeight,
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 22, 20, 16),
                      child: body,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.fromLTRB(20, 22, 20, 16),
                    child: body,
                  ),
          );
        },
      ),
    );
  }
}

/// Mac keeps the large phone swatches but sizes rows to content, so GridView
/// `childAspectRatio` does not leave a tall empty gap between the two rows.
class _MacPaletteGrid extends StatelessWidget {
  const _MacPaletteGrid({
    required this.selected,
    required this.l10n,
    required this.onSelect,
  });

  final AppPalette selected;
  final AppLocalizations l10n;
  final ValueChanged<AppPalette> onSelect;

  static const _rows = [
    [AppPalette.orange, AppPalette.green, AppPalette.teal],
    [AppPalette.blue, AppPalette.slate, AppPalette.paper],
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var r = 0; r < _rows.length; r++) ...[
          if (r > 0) const SizedBox(height: 12),
          Row(
            children: [
              for (var i = 0; i < _rows[r].length; i++) ...[
                if (i > 0) const SizedBox(width: 10),
                Expanded(
                  child: _PickerSwatch(
                    palette: _rows[r][i],
                    label: ThemePickerDialog.paletteLabel(l10n, _rows[r][i]),
                    selected: selected == _rows[r][i],
                    onTap: () => onSelect(_rows[r][i]),
                  ),
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }
}

class _PickerSwatch extends StatelessWidget {
  const _PickerSwatch({
    required this.palette,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final AppPalette palette;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final spec = paletteSpecs[palette]!;
    final swatch = palette == AppPalette.paper
        ? const Color(0xFFE6D3B0)
        : spec.primary;
    final checkColor = palette == AppPalette.paper
        ? spec.primary
        : Colors.white;
    final colorScheme = Theme.of(context).colorScheme;
    final desktopInk = !kIsWeb &&
        (Platform.isMacOS || Platform.isWindows || Platform.isLinux);
    return Align(
      alignment: Alignment.topCenter,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        hoverColor: desktopInk ? Colors.transparent : null,
        highlightColor: desktopInk ? Colors.transparent : null,
        splashFactory: desktopInk ? NoSplash.splashFactory : null,
        overlayColor: desktopInk
            ? const WidgetStatePropertyAll(Colors.transparent)
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 52,
              height: 52,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected
                      ? spec.primary
                      : colorScheme.outline.withValues(alpha: 0.28),
                  width: selected ? 2.5 : 1,
                ),
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: swatch,
                ),
                child: selected
                    ? Icon(Icons.check, size: 22, color: checkColor)
                    : const SizedBox.expand(),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: selected ? spec.primary : colorScheme.onSurfaceVariant,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaperPreviewPainter extends CustomPainter {
  const _PaperPreviewPainter({
    required this.enabled,
    required this.tint,
    required this.dark,
  });

  final bool enabled;
  final Color tint;
  final bool dark;

  @override
  void paint(Canvas canvas, Size size) {
    final base = dark ? const Color(0xFF2A241C) : const Color(0xFFF6EFE4);
    canvas.drawRect(Offset.zero & size, Paint()..color = base);
    if (!enabled) return;
    final wash = Color.lerp(const Color(0xFFD4B896), tint, 0.28)!;
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = wash.withValues(alpha: dark ? 0.22 : 0.18),
    );
    final random = math.Random(11);
    final speckle = Paint()..style = PaintingStyle.fill;
    for (var i = 0; i < 70; i++) {
      speckle.color =
          (random.nextBool()
                  ? (dark ? const Color(0xFFE8D9C0) : const Color(0xFF5D4037))
                  : (dark ? const Color(0xFF1A140E) : const Color(0xFFFFF8E8)))
              .withValues(alpha: 0.28);
      canvas.drawCircle(
        Offset(
          random.nextDouble() * size.width,
          random.nextDouble() * size.height,
        ),
        0.4 + random.nextDouble() * 0.9,
        speckle,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PaperPreviewPainter oldDelegate) {
    return oldDelegate.enabled != enabled ||
        oldDelegate.tint != tint ||
        oldDelegate.dark != dark;
  }
}
