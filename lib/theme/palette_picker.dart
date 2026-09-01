import 'package:decibel_meter/l10n/generated/app_localizations.dart';
import 'package:decibel_meter/theme/app_palette.dart';
import 'package:flutter/material.dart';

String paletteLabel(AppLocalizations l10n, AppPalette palette) {
  return switch (palette) {
    AppPalette.orange => l10n.themeOrange,
    AppPalette.green => l10n.themeGreen,
    AppPalette.teal => l10n.themeTeal,
    AppPalette.blue => l10n.themeBlue,
    AppPalette.slate => l10n.themeSlate,
    AppPalette.paper => l10n.themePaper,
  };
}

class PalettePickerRows extends StatelessWidget {
  const PalettePickerRows({
    super.key,
    required this.selected,
    required this.l10n,
    required this.onSelect,
  });

  final AppPalette selected;
  final AppLocalizations l10n;
  final ValueChanged<AppPalette> onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _PaletteRow(
          palettes: const [
            AppPalette.orange,
            AppPalette.green,
            AppPalette.teal,
          ],
          selected: selected,
          l10n: l10n,
          onSelect: onSelect,
        ),
        const SizedBox(height: 8),
        _PaletteRow(
          palettes: const [
            AppPalette.blue,
            AppPalette.slate,
            AppPalette.paper,
          ],
          selected: selected,
          l10n: l10n,
          onSelect: onSelect,
        ),
      ],
    );
  }
}

class _PaletteRow extends StatelessWidget {
  const _PaletteRow({
    required this.palettes,
    required this.selected,
    required this.l10n,
    required this.onSelect,
  });

  final List<AppPalette> palettes;
  final AppPalette selected;
  final AppLocalizations l10n;
  final ValueChanged<AppPalette> onSelect;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < palettes.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Expanded(
            child: PaletteChoice(
              palette: palettes[i],
              selected: selected == palettes[i],
              label: paletteLabel(l10n, palettes[i]),
              onTap: () => onSelect(palettes[i]),
            ),
          ),
        ],
      ],
    );
  }
}

class PaletteChoice extends StatelessWidget {
  const PaletteChoice({
    super.key,
    required this.palette,
    required this.selected,
    required this.label,
    required this.onTap,
  });

  final AppPalette palette;
  final bool selected;
  final String label;
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 36,
              height: 36,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected
                      ? spec.primary
                      : colorScheme.outline.withValues(alpha: 0.28),
                  width: selected ? 2 : 1,
                ),
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(shape: BoxShape.circle, color: swatch),
                child: selected
                    ? Icon(Icons.check, size: 16, color: checkColor)
                    : const SizedBox.expand(),
              ),
            ),
            const SizedBox(height: 6),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                maxLines: 1,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: selected
                      ? spec.primary
                      : colorScheme.onSurfaceVariant,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
