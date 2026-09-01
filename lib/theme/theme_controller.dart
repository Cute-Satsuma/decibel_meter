import 'package:decibel_meter/theme/app_palette.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends ChangeNotifier {
  ThemeController({
    this.palette = AppPalette.orange,
    this.brightnessMode = AppBrightnessMode.system,
    this.typeface = AppTypeface.rounded,
    this.paperFilter = false,
    double paperGrain = defaultPaperGrain,
  }) : paperGrain = ValueNotifier(paperGrain.clamp(0, 1));

  static const defaultPaperGrain = 0.35;
  static const _paletteKey = 'db_meter_palette_v1';
  static const _brightnessKey = 'db_meter_brightness_v1';
  static const _typefaceKey = 'db_meter_typeface_v1';
  static const _paperFilterKey = 'db_meter_paper_filter_v1';
  static const _paperGrainKey = 'db_meter_paper_grain_v1';
  static const _themePickerSeenKey = 'db_meter_theme_picker_seen_v1';
  static const _themeGuideSeenKey = 'db_meter_theme_guide_seen_v1';

  AppPalette palette;
  AppBrightnessMode brightnessMode;
  AppTypeface typeface;
  bool paperFilter;
  bool themePickerSeen = false;
  bool themeGuideSeen = false;
  final ValueNotifier<double> paperGrain;

  ThemeMode get themeMode => themeModeOf(brightnessMode);

  Future<void>? _loadFuture;

  Future<void> ensureLoaded() => _loadFuture ??= load();

  Future<void> load() async {
    final SharedPreferences prefs;
    try {
      prefs = await SharedPreferences.getInstance();
      await prefs.reload();
    } catch (error) {
      debugPrint('Theme preferences unavailable: $error');
      return;
    }
    themeGuideSeen = prefs.getBool(_themeGuideSeenKey) ?? false;
    themePickerSeen = prefs.getBool(_themePickerSeenKey) ?? false;
    palette =
        _valueOf(AppPalette.values, prefs.getString(_paletteKey)) ?? palette;
    brightnessMode =
        _valueOf(AppBrightnessMode.values, prefs.getString(_brightnessKey)) ??
        brightnessMode;
    typeface =
        _valueOf(AppTypeface.values, prefs.getString(_typefaceKey)) ?? typeface;
    paperFilter =
        prefs.getBool(_paperFilterKey) ?? (palette == AppPalette.paper);
    paperGrain.value = (prefs.getDouble(_paperGrainKey) ?? paperGrain.value)
        .clamp(0, 1);
    notifyListeners();
  }

  T? _valueOf<T extends Enum>(Iterable<T> values, String? name) {
    if (name == null) return null;
    for (final value in values) {
      if (value.name == name) return value;
    }
    return null;
  }

  Future<void> setPalette(AppPalette value, {bool persist = true}) async {
    final changed = palette != value;
    if (changed) {
      palette = value;
      notifyListeners();
    }
    if (!persist) return;
    await (await SharedPreferences.getInstance()).setString(
      _paletteKey,
      value.name,
    );
  }

  Future<void> setBrightnessMode(AppBrightnessMode value) async {
    if (brightnessMode == value) return;
    brightnessMode = value;
    notifyListeners();
    await (await SharedPreferences.getInstance()).setString(
      _brightnessKey,
      value.name,
    );
  }

  Future<void> setTypeface(AppTypeface value) async {
    if (typeface == value) return;
    typeface = value;
    notifyListeners();
    await (await SharedPreferences.getInstance()).setString(
      _typefaceKey,
      value.name,
    );
  }

  Future<void> setPaperFilter(bool value, {bool persist = true}) async {
    final changed = paperFilter != value;
    if (changed) {
      paperFilter = value;
      notifyListeners();
    }
    if (!persist) return;
    await (await SharedPreferences.getInstance()).setBool(
      _paperFilterKey,
      value,
    );
  }

  Future<void> setPaperGrain(double value, {bool persist = false}) async {
    paperGrain.value = value.clamp(0, 1);
    if (persist) {
      await (await SharedPreferences.getInstance()).setDouble(
        _paperGrainKey,
        paperGrain.value,
      );
    }
  }

  Future<void> markThemePickerSeen() async {
    if (themePickerSeen) return;
    themePickerSeen = true;
    await (await SharedPreferences.getInstance()).setBool(
      _themePickerSeenKey,
      true,
    );
  }

  Future<void> markThemeGuideSeen() async {
    if (themeGuideSeen) return;
    themeGuideSeen = true;
    await (await SharedPreferences.getInstance()).setBool(
      _themeGuideSeenKey,
      true,
    );
  }

  /// Clears onboarding flags so guide + picker can run again (also fixes stale
  /// prefs after manual plist edits while the app was running).
  Future<void> resetThemeOnboarding() async {
    themeGuideSeen = false;
    themePickerSeen = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_themeGuideSeenKey);
    await prefs.remove(_themePickerSeenKey);
    notifyListeners();
  }

  @override
  void dispose() {
    paperGrain.dispose();
    super.dispose();
  }
}

class ThemeScope extends InheritedNotifier<ThemeController> {
  const ThemeScope({
    super.key,
    required ThemeController controller,
    required super.child,
  }) : super(notifier: controller);

  static ThemeController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ThemeScope>();
    assert(scope != null, 'ThemeScope not found');
    return scope!.notifier!;
  }
}
