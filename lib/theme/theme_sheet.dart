import 'package:decibel_meter/app_info.dart';
import 'package:decibel_meter/l10n/generated/app_localizations.dart';
import 'package:decibel_meter/theme/app_palette.dart';
import 'package:decibel_meter/theme/caju_fonts.dart';
import 'package:decibel_meter/theme/palette_picker.dart';
import 'package:decibel_meter/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> showThemeSettingsSheet(BuildContext context) {
  final maxHeight = MediaQuery.sizeOf(context).height * 0.75;
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    constraints: BoxConstraints(maxHeight: maxHeight),
    builder: (context) => const ThemeSettingsSheet(),
  );
}

class ThemeSettingsSheet extends StatelessWidget {
  const ThemeSettingsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final controller = ThemeScope.of(context);
    final zh = Localizations.localeOf(context).languageCode == 'zh';
    String tr(String zhText, String enText) => zh ? zhText : enText;
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) => SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          24,
          8,
          24,
          24 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.settingsTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            _AppAboutSection(l10n: l10n),
            const SizedBox(height: 22),
            _BrandSection(l10n: l10n),
            const SizedBox(height: 28),
            Divider(color: Theme.of(context).colorScheme.outlineVariant),
            const SizedBox(height: 20),
            _label(context, tr('外观', 'Appearance')),
            const SizedBox(height: 8),
            SegmentedButton<AppBrightnessMode>(
              showSelectedIcon: false,
              segments: [
                ButtonSegment(
                  value: AppBrightnessMode.system,
                  label: Text(tr('系统', 'System')),
                ),
                ButtonSegment(
                  value: AppBrightnessMode.light,
                  label: Text(tr('浅色', 'Light')),
                ),
                ButtonSegment(
                  value: AppBrightnessMode.dark,
                  label: Text(tr('深色', 'Dark')),
                ),
              ],
              selected: {controller.brightnessMode},
              onSelectionChanged: (value) =>
                  controller.setBrightnessMode(value.first),
            ),
            const SizedBox(height: 22),
            _label(context, l10n.themeColor),
            const SizedBox(height: 10),
            PalettePickerRows(
              selected: controller.palette,
              l10n: l10n,
              onSelect: controller.setPalette,
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(tr('纸质滤镜', 'Paper filter')),
              value: controller.paperFilter,
              onChanged: controller.setPaperFilter,
            ),
            ValueListenableBuilder<double>(
              valueListenable: controller.paperGrain,
              builder: (context, value, _) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label(context, tr('粗糙度', 'Roughness')),
                  Slider(
                    value: value,
                    divisions: 20,
                    onChanged: controller.paperFilter
                        ? controller.setPaperGrain
                        : null,
                    onChangeEnd: (value) =>
                        controller.setPaperGrain(value, persist: true),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            _label(context, tr('字体', 'Font')),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final typeface in AppTypeface.values)
                  TextButton(
                    onPressed: () => controller.setTypeface(typeface),
                    style: TextButton.styleFrom(
                      foregroundColor: typeface == controller.typeface
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                    ),
                    child: Text(
                      _fontName(typeface, zh),
                      style: cajuPreviewStyle(
                        typeface,
                        Theme.of(context).textTheme.labelLarge,
                      ).copyWith(
                        fontWeight: typeface == controller.typeface
                            ? FontWeight.w700
                            : FontWeight.w400,
                        decoration: typeface == controller.typeface
                            ? TextDecoration.underline
                            : TextDecoration.none,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(BuildContext context, String text) => Text(
    text,
    style: Theme.of(context).textTheme.labelLarge?.copyWith(
      color: Theme.of(context).colorScheme.onSurfaceVariant,
      letterSpacing: 1,
    ),
  );

  String _fontName(AppTypeface value, bool zh) => switch (value) {
    AppTypeface.rounded => zh ? '圆润' : 'Rounded',
    AppTypeface.maru => zh ? '圆体' : 'Maru',
    AppTypeface.xiaowei => zh ? '小薇' : 'XiaoWei',
    AppTypeface.nunito => zh ? '软圆' : 'Nunito',
    AppTypeface.system => zh ? '系统' : 'System',
  };
}

class _AppAboutSection extends StatelessWidget {
  const _AppAboutSection({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel(text: l10n.aboutTitle),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/brand/caju_icon_512.png',
                width: 52,
                height: 52,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.appName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.versionLabel(appVersionName),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    l10n.buildLabel(appBuildNumber),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          l10n.aboutContent,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            height: 1.45,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _BrandSection extends StatelessWidget {
  const _BrandSection({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel(text: l10n.brandTitle),
        const SizedBox(height: 10),
        Text(
          l10n.brandTagline,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          l10n.brandContent,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            height: 1.45,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 10),
        _ExternalLink(
          label: l10n.privacyPolicyLink,
          url: privacyPolicyUrl,
        ),
        _ExternalLink(
          label: l10n.productPageLink,
          url: productPageUrl,
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        letterSpacing: 1,
      ),
    );
  }
}

class _ExternalLink extends StatelessWidget {
  const _ExternalLink({required this.label, required this.url});

  final String label;
  final String url;

  Future<void> _open(BuildContext context) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(url)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: InkWell(
        onTap: () => _open(context),
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Icon(
                Icons.open_in_new,
                size: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  decoration: TextDecoration.underline,
                  decorationColor: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
