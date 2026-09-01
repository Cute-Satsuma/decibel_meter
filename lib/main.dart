import 'dart:async';
import 'dart:io' show Platform;
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:record/record.dart';
import 'package:decibel_meter/l10n/generated/app_localizations.dart';
import 'package:decibel_meter/database/database_helper.dart';
import 'package:decibel_meter/database/measurement_record.dart';
import 'package:decibel_meter/history/history_page.dart';
import 'package:decibel_meter/theme/caju_style.dart';
import 'package:decibel_meter/theme/paper_filter.dart';
import 'package:decibel_meter/theme/app_palette.dart';
import 'package:decibel_meter/theme/theme_controller.dart';
import 'package:decibel_meter/theme/theme_guide.dart';
import 'package:decibel_meter/theme/theme_picker_dialog.dart';
import 'package:decibel_meter/theme/theme_sheet.dart';

bool get _isFlutterTest {
  if (kIsWeb) {
    return false;
  }
  return Platform.environment.containsKey('FLUTTER_TEST');
}

bool get _isMacOSPlatform {
  if (kIsWeb || _isFlutterTest) return false;
  return Platform.isMacOS;
}

bool get _isDesktopPointerPlatform {
  if (kIsWeb || _isFlutterTest) return false;
  return Platform.isMacOS || Platform.isWindows || Platform.isLinux;
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Android 15+ 默认无边框；低版本需显式打开，状态栏/导航栏才会叠在内容上并由 SafeArea 让位。
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(const DecibelMeterApp());
}

class DecibelMeterApp extends StatefulWidget {
  const DecibelMeterApp({super.key, this.locale, this.themeMode});

  final Locale? locale;
  final ThemeMode? themeMode;

  @override
  State<DecibelMeterApp> createState() => _DecibelMeterAppState();
}

class _DecibelMeterAppState extends State<DecibelMeterApp> {
  late final ThemeController _themeController;

  @override
  void initState() {
    super.initState();
    _themeController = ThemeController(
      typeface: _isFlutterTest ? AppTypeface.system : AppTypeface.rounded,
    );
    _themeController.ensureLoaded();
  }

  @override
  void dispose() {
    _themeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeScope(
      controller: _themeController,
      child: ListenableBuilder(
        listenable: _themeController,
        builder: (context, _) => MaterialApp(
          onGenerateTitle: (context) =>
              AppLocalizations.of(context)?.appName ?? 'dB Meter',
          debugShowCheckedModeBanner: false,
          locale: widget.locale,
          themeMode: widget.themeMode ?? _themeController.themeMode,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'), // English
            Locale('zh', 'CN'), // Chinese (Simplified)
            Locale('es'), // Spanish
            Locale('hi'), // Hindi
            Locale('ar'), // Arabic
            Locale('pt'), // Portuguese
            Locale('bn'), // Bengali
            Locale('ru'), // Russian
            Locale('ja'), // Japanese
            Locale('de'), // German
          ],
          // 不设置 locale，让应用自动跟随系统语言
          theme: buildAppTheme(
            _themeController.palette,
            Brightness.light,
            typeface: _themeController.typeface,
            paperFilter: _themeController.paperFilter,
          ),
          darkTheme: buildAppTheme(
            _themeController.palette,
            Brightness.dark,
            typeface: _themeController.typeface,
            paperFilter: _themeController.paperFilter,
          ),
          builder: (context, child) {
            final brightness = Theme.of(context).brightness;
            final lightSurface = brightness == Brightness.light;
            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                systemNavigationBarColor: Colors.transparent,
                // Android: icon brightness. iOS: use statusBarBrightness below.
                statusBarIconBrightness: lightSurface
                    ? Brightness.dark
                    : Brightness.light,
                statusBarBrightness: lightSurface
                    ? Brightness.light
                    : Brightness.dark,
                systemNavigationBarIconBrightness: lightSurface
                    ? Brightness.dark
                    : Brightness.light,
                systemStatusBarContrastEnforced: false,
                systemNavigationBarContrastEnforced: false,
              ),
              child: _PhoneFrameShell(
                child: PaperFilterOverlay(
                  child: child ?? const SizedBox.shrink(),
                ),
              ),
            );
          },
          home: const DecibelMeterPage(),
        ),
      ),
    );
  }
}

/// Web / macOS 用手机竖屏宽度居中，避免宽窗口把测量页拉成横屏三列。
class _PhoneFrameShell extends StatelessWidget {
  const _PhoneFrameShell({required this.child});

  final Widget child;
  static const double _phoneWidth = 402;
  static const double _phoneAspect = 874 / 402; // iPhone 16 Pro portrait
  static const double _frameBreakpoint = 520;

  bool _useFrame(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (kIsWeb) return width > _frameBreakpoint;
    return _isMacOSPlatform && width > _frameBreakpoint;
  }

  @override
  Widget build(BuildContext context) {
    if (!_useFrame(context)) return child;

    final mq = MediaQuery.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final stageColor = isDark
        ? const Color(0xFF12100F)
        : const Color(0xFFFFFAF4);

    return ColoredBox(
      color: stageColor,
      child: LayoutBuilder(
        builder: (context, constraints) {
          const verticalMargin = 20.0;
          final maxPhoneHeight = _phoneWidth * _phoneAspect;
          final phoneHeight = (constraints.maxHeight - verticalMargin * 2)
              .clamp(560.0, maxPhoneHeight);
          return Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _PortalBackdropPainter(isDark: isDark),
                ),
              ),
              if (kIsWeb && constraints.maxWidth >= 920)
                Positioned(
                  left: 34,
                  top: 28,
                  child: _WebBrandMark(isDark: isDark),
                ),
              Center(
                child: Container(
                  width: _phoneWidth,
                  height: phoneHeight,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.10)
                          : const Color(0xFFEADFD5),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: isDark ? 0.32 : 0.10,
                        ),
                        blurRadius: 30,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(21),
                    child: MediaQuery(
                      data: mq.copyWith(
                        size: Size(_phoneWidth, phoneHeight),
                        padding: EdgeInsets.zero,
                        viewPadding: EdgeInsets.zero,
                        viewInsets: EdgeInsets.zero,
                      ),
                      child: child,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _WebBrandMark extends StatelessWidget {
  const _WebBrandMark({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final ink = isDark ? const Color(0xFFF7EFE9) : const Color(0xFF302019);
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: const Color(0xFFE85D18),
            borderRadius: BorderRadius.circular(13),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFE85D18).withValues(alpha: 0.22),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(Icons.eco_rounded, size: 21, color: Colors.white),
        ),
        const SizedBox(width: 11),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Caju',
              style: TextStyle(
                color: ink,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
            const Text(
              'CUTE SATSUMA',
              style: TextStyle(
                color: Color(0xFFE85D18),
                fontSize: 9,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PortalBackdropPainter extends CustomPainter {
  const _PortalBackdropPainter({required this.isDark});

  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = (isDark ? Colors.white : const Color(0xFF3E2723)).withValues(
        alpha: isDark ? 0.025 : 0.035,
      )
      ..strokeWidth = 1;
    const step = 32.0;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    void glow(Offset center, double radius, Color color) {
      final paint = Paint()
        ..shader = RadialGradient(colors: [color, color.withValues(alpha: 0)])
            .createShader(Rect.fromCircle(center: center, radius: radius));
      canvas.drawCircle(center, radius, paint);
    }

    glow(
      Offset(size.width * 0.10, size.height * 0.16),
      250,
      const Color(0xFFFFC85A).withValues(alpha: isDark ? 0.07 : 0.16),
    );
    glow(
      Offset(size.width * 0.92, size.height * 0.58),
      310,
      const Color(0xFFE85D18).withValues(alpha: isDark ? 0.06 : 0.10),
    );
  }

  @override
  bool shouldRepaint(covariant _PortalBackdropPainter oldDelegate) {
    return oldDelegate.isDark != isDark;
  }
}

class DecibelMeterPage extends StatefulWidget {
  const DecibelMeterPage({super.key});

  @override
  State<DecibelMeterPage> createState() => _DecibelMeterPageState();
}

class _DecibelMeterPageState extends State<DecibelMeterPage> {
  final GlobalKey _settingsButtonKey = GlobalKey();
  final AudioRecorder _recorder = AudioRecorder();
  bool _isRecording = false;
  bool _isMeasuring = false; // 是否正在测量（3秒延迟后）
  int _countdown = 0; // 倒计时（3、2、1）
  double _currentDb = 0;
  double _maxDb = 0;
  double? _minDb; // 使用 nullable，初始为 null，从第一次测量值开始
  String? _errorMessage;
  StreamSubscription<Amplitude>? _amplitudeSubscription;
  StreamSubscription<List<int>>? _recordStreamSubscription;
  Timer? _measurementDelayTimer; // 3秒延迟计时器
  Timer? _countdownTimer; // 倒计时更新器
  final List<double> _dbHistory = []; // 存储历史数据用于统计
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  DateTime? _measurementStartTime; // 测量开始时间
  final ValueNotifier<double> _liveDb = ValueNotifier(0);
  DateTime _lastStatsRebuild = DateTime.fromMillisecondsSinceEpoch(0);
  int _audioSession = 0;
  bool _meterBusy = false;
  bool _toggleQueued = false;
  var _showThemeGuide = false;
  var _guidePaletteIndex = 0;
  AppPalette? _paletteBeforeGuide;
  Timer? _paletteTour;
  OverlayEntry? _themeGuideOverlay;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _maybeStartThemeOnboarding();
    });
  }

  Future<void> _maybeStartThemeOnboarding() async {
    if (_isFlutterTest) return;
    final controller = ThemeScope.of(context);
    await controller.ensureLoaded();
    if (!mounted) return;
    if (controller.themeGuideSeen) {
      if (!controller.themePickerSeen) {
        await _waitForSettingsButtonLayout();
        await Future<void>.delayed(const Duration(milliseconds: 400));
        if (mounted && !ThemeScope.of(context).themePickerSeen) {
          await _showThemePicker();
        }
      }
      return;
    }
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    final loaded = ThemeScope.of(context);
    if (loaded.themeGuideSeen) {
      if (!loaded.themePickerSeen) {
        await _waitForSettingsButtonLayout();
        await _showThemePicker();
      }
      return;
    }
    await _waitForSettingsButtonLayout();
    _startThemeGuide();
  }

  Future<void> _showThemePicker() async {
    await showThemePickerDialog(context);
    if (!mounted) return;
    await ThemeScope.of(context).markThemePickerSeen();
  }

  void _startThemeGuide() {
    final controller = ThemeScope.of(context);
    _paletteBeforeGuide = controller.palette;
    _guidePaletteIndex = AppPalette.values.indexOf(controller.palette);
    if (_guidePaletteIndex < 0) _guidePaletteIndex = 0;
    _showThemeGuide = true;
    _insertThemeGuideOverlay();
    _paletteTour = Timer.periodic(const Duration(milliseconds: 1100), (_) {
      if (!mounted) return;
      _guidePaletteIndex = (_guidePaletteIndex + 1) % AppPalette.values.length;
      ThemeScope.of(context).setPalette(
        AppPalette.values[_guidePaletteIndex],
        persist: false,
      );
      _themeGuideOverlay?.markNeedsBuild();
    });
  }

  void _insertThemeGuideOverlay() {
    _themeGuideOverlay?.remove();
    _themeGuideOverlay = OverlayEntry(
      builder: (overlayContext) => ThemeGuideLayer(
        target: _settingsButtonTargetOrFallback(context),
        activePalette: AppPalette.values[_guidePaletteIndex],
        onDismiss: () => _dismissThemeGuide(),
      ),
    );
    Overlay.of(context, rootOverlay: true).insert(_themeGuideOverlay!);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _themeGuideOverlay?.markNeedsBuild();
    });
  }

  void _removeThemeGuideOverlay() {
    _themeGuideOverlay?.remove();
    _themeGuideOverlay = null;
  }

  Future<void> _dismissThemeGuide({bool openSettings = false}) async {
    if (!_showThemeGuide) {
      if (openSettings && mounted) {
        showThemeSettingsSheet(context);
      }
      return;
    }
    _paletteTour?.cancel();
    _paletteTour = null;
    final controller = ThemeScope.of(context);
    final restore = _paletteBeforeGuide;
    if (restore != null) {
      await controller.setPalette(restore, persist: false);
    }
    await controller.markThemeGuideSeen();
    if (!mounted) return;
    _removeThemeGuideOverlay();
    _showThemeGuide = false;
    await Future<void>.delayed(const Duration(milliseconds: 240));
    if (!mounted) return;
    if (!ThemeScope.of(context).themePickerSeen) {
      await _showThemePicker();
      return;
    }
    if (openSettings) showThemeSettingsSheet(context);
  }

  Rect _settingsButtonTarget() {
    final box =
        _settingsButtonKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return Rect.zero;
    final offset = box.localToGlobal(Offset.zero);
    return offset & box.size;
  }

  Rect _settingsButtonTargetOrFallback(BuildContext context) {
    final rect = _settingsButtonTarget();
    if (rect.width > 0 && rect.height > 0) return rect;
    final padding = MediaQuery.paddingOf(context);
    return Rect.fromLTWH(padding.left + 8, padding.top + 6, 40, 40);
  }

  Future<bool> _waitForSettingsButtonLayout() async {
    for (var attempt = 0; attempt < 40; attempt++) {
      if (!mounted) return false;
      final rect = _settingsButtonTarget();
      if (rect.width > 0 && rect.height > 0) return true;
      await Future<void>.delayed(const Duration(milliseconds: 50));
    }
    return false;
  }

  void _onSettingsPressed() {
    _dismissThemeGuide(openSettings: true);
  }

  /// 将 dBFS（相对满量程分贝）映射为近似环境声压级显示值（约 0–120 dB）
  static double _dbfsToDisplayDb(double dbfs) {
    // dBFS 常见范围约 -60 ~ 0，映射到 0 ~ 120 dB 显示
    // 这样可以显示更安静的环境（低于30 dB）
    const double minDb = 0;
    const double maxDb = 120;
    const double dbfsMin = -60;
    const double dbfsMax = 0;
    final double t = (dbfs - dbfsMin) / (dbfsMax - dbfsMin);
    return (minDb + (maxDb - minDb) * t.clamp(0.0, 1.0));
  }

  /// 计算平均值
  double _getAverage() {
    if (_dbHistory.isEmpty) return 0;
    return _dbHistory.reduce((a, b) => a + b) / _dbHistory.length;
  }

  /// 计算百分位值
  double _getPercentile(int percentile) {
    if (_dbHistory.isEmpty) return 0;
    final sorted = List<double>.from(_dbHistory)..sort();
    final index = (sorted.length * percentile / 100).ceil() - 1;
    return sorted[index.clamp(0, sorted.length - 1)];
  }

  Future<void> _toggleRecording() async {
    if (_meterBusy) {
      _toggleQueued = true;
      return;
    }
    _meterBusy = true;
    try {
      do {
        _toggleQueued = false;
        if (!mounted) break;
        if (_isRecording) {
          await _stopMeasuring();
        } else {
          await _startMeasuring();
        }
      } while (_toggleQueued);
    } finally {
      _meterBusy = false;
    }
  }

  Future<void> _tearDownCapture() async {
    _measurementDelayTimer?.cancel();
    _measurementDelayTimer = null;
    _countdownTimer?.cancel();
    _countdownTimer = null;
    await _amplitudeSubscription?.cancel();
    _amplitudeSubscription = null;
    await _recordStreamSubscription?.cancel();
    _recordStreamSubscription = null;
    try {
      if (await _recorder.isRecording()) {
        await _recorder.stop();
      }
    } catch (_) {}
  }

  void _onAmplitude(int session, Amplitude amplitude) {
    if (!mounted || session != _audioSession || !_isRecording) return;
    // 0 dBFS 常是录音尚未出数时的占位，不是真实满量程
    if (amplitude.current.isNaN ||
        amplitude.current.isInfinite ||
        amplitude.current == 0 ||
        amplitude.current < -100 ||
        amplitude.current > 0) {
      return;
    }
    final current = _dbfsToDisplayDb(amplitude.current);
    if (current < 0 || current > 120) return;
    _currentDb += (current - _currentDb) * 0.42;
    _liveDb.value = _currentDb;
    if (_isMeasuring && current > 0) {
      if (current > _maxDb) _maxDb = current;
      if (_minDb == null || current < _minDb!) {
        _minDb = current;
      }
      _dbHistory.add(current);
      final now = DateTime.now();
      if (now.difference(_lastStatsRebuild) >=
          const Duration(milliseconds: 250)) {
        _lastStatsRebuild = now;
        if (mounted) setState(() {});
      }
    }
  }

  Future<void> _startMeasuring() async {
    await _tearDownCapture();
    final session = ++_audioSession;
    if (!mounted) return;

    setState(() {
      _errorMessage = null;
      _currentDb = 0;
      _liveDb.value = 0;
      _maxDb = 0;
      _minDb = null;
      _dbHistory.clear();
      _measurementStartTime = DateTime.now();
      _isRecording = true;
      _isMeasuring = false;
      _countdown = 3;
    });

    final hasPermission = await _recorder.hasPermission();
    if (session != _audioSession) return;
    if (!hasPermission) {
      if (!mounted) return;
      setState(() {
        _isRecording = false;
        _countdown = 0;
        _measurementStartTime = null;
        _errorMessage = AppLocalizations.of(context)!.permissionDenied;
      });
      return;
    }

    try {
      if (await _recorder.isRecording()) {
        await _recorder.stop();
      }
      if (session != _audioSession) return;

      const config = RecordConfig(
        encoder: AudioEncoder.pcm16bits,
        sampleRate: 44100,
        numChannels: 1,
      );

      final recordStream = await _recorder.startStream(config);
      if (session != _audioSession) {
        try {
          await _recorder.stop();
        } catch (_) {}
        return;
      }

      _recordStreamSubscription = recordStream.listen(
        (_) {},
        onError: (Object e) {
          if (session != _audioSession) return;
          if (mounted) setState(() => _errorMessage = e.toString());
        },
      );

      _amplitudeSubscription = _recorder
          .onAmplitudeChanged(const Duration(milliseconds: 50))
          .listen((amplitude) => _onAmplitude(session, amplitude));

      int remainingSeconds = 3;
      _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted || session != _audioSession || !_isRecording) {
          timer.cancel();
          return;
        }
        remainingSeconds--;
        setState(() {
          _countdown = remainingSeconds;
        });
        if (remainingSeconds <= 0) {
          timer.cancel();
          _countdownTimer = null;
        }
      });

      _measurementDelayTimer = Timer(const Duration(seconds: 3), () {
        if (!mounted || session != _audioSession || !_isRecording) return;
        setState(() {
          _isMeasuring = true;
          _countdown = 0;
          final current = _currentDb;
          if (current > 0) {
            _maxDb = current;
            _minDb = current;
            _dbHistory.add(current);
          }
        });
      });
    } catch (e) {
      if (session != _audioSession || !mounted) return;
      setState(() {
        _isRecording = false;
        _isMeasuring = false;
        _countdown = 0;
        _measurementStartTime = null;
        _liveDb.value = 0;
        _currentDb = 0;
        _errorMessage = AppLocalizations.of(context)!.micError(e.toString());
      });
    }
  }

  Future<void> _stopMeasuring() async {
    _audioSession++;
    final shouldSave =
        _isMeasuring && _dbHistory.isNotEmpty && _measurementStartTime != null;
    final duration = shouldSave
        ? DateTime.now().difference(_measurementStartTime!).inSeconds
        : 0;
    final minDb = _minDb;
    final maxDb = _maxDb;
    final avgDb = _getAverage();
    final p50Db = _getPercentile(50);
    final p90Db = _getPercentile(90);
    final p95Db = _getPercentile(95);
    final timestamp = _measurementStartTime?.millisecondsSinceEpoch;

    await _tearDownCapture();

    if (shouldSave && duration > 0 && minDb != null && timestamp != null) {
      try {
        await _dbHelper.insertRecord(
          MeasurementRecord(
            timestamp: timestamp,
            duration: duration,
            minDb: minDb,
            maxDb: maxDb,
            avgDb: avgDb,
            p50Db: p50Db,
            p90Db: p90Db,
            p95Db: p95Db,
          ),
        );
      } catch (e) {
        debugPrint('保存测量记录失败: $e');
      }
    }

    if (mounted) {
      setState(() {
        _isRecording = false;
        _isMeasuring = false;
        _countdown = 0;
        _measurementStartTime = null;
      });
    }
  }

  void _showMeasurementInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.measurementRules),
          content: SingleChildScrollView(
            child: Text(
              AppLocalizations.of(context)!.measurementRulesContent,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _removeThemeGuideOverlay();
    _paletteTour?.cancel();
    _audioSession++;
    _toggleQueued = false;
    _measurementDelayTimer?.cancel();
    _countdownTimer?.cancel();
    _amplitudeSubscription?.cancel();
    _recordStreamSubscription?.cancel();
    _liveDb.dispose();
    _recorder.dispose();
    super.dispose();
  }

  bool get _hasMeasurementData => _isRecording || _dbHistory.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final landscape =
        !_isMacOSPlatform &&
        !kIsWeb &&
        MediaQuery.orientationOf(context) == Orientation.landscape;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: colorScheme.surface,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: landscape ? 12 : 16),
              child: landscape
                  ? _buildLandscapeBody(context, colorScheme)
                  : _buildPortraitBody(context, colorScheme),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPortraitBody(BuildContext context, ColorScheme colorScheme) {
    return Column(
      children: [
        _buildTitleRow(context, colorScheme),
        const SizedBox(height: 24),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (_errorMessage != null)
                  _buildError(context)
                else ...[
                  _DecibelDisplay(
                    liveDb: _liveDb,
                    maxDb: _maxDb,
                    minDb: _minDb ?? 0,
                    averageDb: _getAverage(),
                    p50Db: _getPercentile(50),
                    p90Db: _getPercentile(90),
                    p95Db: _getPercentile(95),
                    isActive: _hasMeasurementData,
                    hasData: _dbHistory.isNotEmpty,
                  ),
                ],
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 32),
          child: _buildControlSection(context),
        ),
      ],
    );
  }

  Widget _buildLandscapeBody(BuildContext context, ColorScheme colorScheme) {
    return Column(
      children: [
        _buildTitleRow(context, colorScheme),
        const SizedBox(height: 8),
        Expanded(
          child: _errorMessage != null
              ? Center(child: _buildError(context))
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 3,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final size = math
                              .min(
                                math.min(
                                  constraints.maxWidth,
                                  constraints.maxHeight - 8,
                                ),
                                188.0,
                              )
                              .clamp(120.0, 188.0);
                          return Align(
                            alignment: Alignment.center,
                            child: _WaterGauge(
                              liveDb: _liveDb,
                              isActive: _hasMeasurementData,
                              size: size,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 6,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final width = math.min(constraints.maxWidth, 300.0);
                          return Align(
                            alignment: Alignment.center,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.center,
                              child: SizedBox(
                                width: width,
                                child: _StatisticsPanel(
                                  compact: true,
                                  minDb: _minDb ?? 0,
                                  averageDb: _getAverage(),
                                  p50Db: _getPercentile(50),
                                  p90Db: _getPercentile(90),
                                  p95Db: _getPercentile(95),
                                  maxDb: _maxDb,
                                  hasData: _dbHistory.isNotEmpty,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Align(
                      alignment: Alignment.center,
                      child: _buildControlSection(context, compact: true),
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildTitleRow(BuildContext context, ColorScheme colorScheme) {
    return SizedBox(
      height: 44,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 80),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                AppLocalizations.of(context)!.appName,
                maxLines: 1,
                softWrap: false,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.4,
                  color: colorScheme.primary,
                ),
              ),
            ),
          ),
          Row(
            children: [
              _HeaderAction(
                key: _settingsButtonKey,
                icon: Icons.tune_rounded,
                onPressed: _onSettingsPressed,
                tooltip: AppLocalizations.of(context)!.settingsTitle,
              ),
              const Spacer(),
              _HeaderAction(
                icon: Icons.info_outline_rounded,
                tooltip: AppLocalizations.of(context)!.measurementInfo,
                onPressed: () => _showMeasurementInfo(context),
              ),
              _HeaderAction(
                icon: Icons.history_rounded,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const HistoryPage(),
                    ),
                  );
                },
                tooltip: AppLocalizations.of(context)!.history,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControlSection(BuildContext context, {bool compact = false}) {
    return SizedBox(
      width: compact ? 160 : double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: compact ? 6 : 10),
            child: _buildStatusRow(context),
          ),
          _buildControlButton(context, compact: compact),
        ],
      ),
    );
  }

  Widget _buildStatusRow(BuildContext context) {
    final message = _isRecording
        ? (_isMeasuring
              ? AppLocalizations.of(context)!.measuring
              : AppLocalizations.of(context)!.initializing)
        : (!_isMacOSPlatform &&
              !kIsWeb &&
              MediaQuery.orientationOf(context) == Orientation.landscape)
        ? AppLocalizations.of(context)!.tapToStartLandscape
        : AppLocalizations.of(context)!.tapToStart;
    final style = Theme.of(context).textTheme.bodyMedium
        ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant);

    if (_isRecording && !_isMeasuring && _countdown > 0) {
      final countdownStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      );
      return Text.rich(
        TextSpan(
          style: style,
          children: [
            TextSpan(text: '$_countdown ', style: countdownStyle),
            TextSpan(text: message),
          ],
        ),
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      );
    }

    return Text(
      message,
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: style,
    );
  }

  Widget _buildError(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.mic_off,
          size: 48,
          color: Theme.of(context).colorScheme.error,
        ),
        const SizedBox(height: 16),
        Text(
          _errorMessage!,
          textAlign: TextAlign.center,
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      ],
    );
  }

  Widget _buildControlButton(BuildContext context, {bool compact = false}) {
    return _ControlButton(
      isRecording: _isRecording,
      label: _isRecording
          ? AppLocalizations.of(context)!.stop
          : AppLocalizations.of(context)!.startMeasuring,
      onPressed: _toggleRecording,
      size: compact ? 64 : 84,
      compact: compact,
    );
  }
}

class _DecibelDisplay extends StatelessWidget {
  const _DecibelDisplay({
    required this.liveDb,
    required this.maxDb,
    required this.minDb,
    required this.averageDb,
    required this.p50Db,
    required this.p90Db,
    required this.p95Db,
    required this.isActive,
    required this.hasData,
  });

  final ValueListenable<double> liveDb;
  final double maxDb;
  final double minDb;
  final double averageDb;
  final double p50Db;
  final double p90Db;
  final double p95Db;
  final bool isActive;
  final bool hasData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _WaterGauge(liveDb: liveDb, isActive: isActive),
        const SizedBox(height: 28),
        _StatisticsPanel(
          minDb: minDb,
          averageDb: averageDb,
          p50Db: p50Db,
          p90Db: p90Db,
          p95Db: p95Db,
          maxDb: maxDb,
          hasData: hasData,
        ),
      ],
    );
  }
}

class _StatisticsPanel extends StatelessWidget {
  const _StatisticsPanel({
    required this.minDb,
    required this.averageDb,
    required this.p50Db,
    required this.p90Db,
    required this.p95Db,
    required this.maxDb,
    required this.hasData,
    this.compact = false,
  });

  final double minDb;
  final double averageDb;
  final double p50Db;
  final double p90Db;
  final double p95Db;
  final double maxDb;
  final bool hasData;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Divider(
          height: 1,
          color: colorScheme.outlineVariant.withValues(alpha: 0.45),
        ),
        SizedBox(height: compact ? 10 : 16),
        Text(
          AppLocalizations.of(context)!.statistics,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w500,
            letterSpacing: 2.4,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: compact ? 8 : 14),
        _StatisticsGrid(
          compact: compact,
          minDb: minDb,
          averageDb: averageDb,
          p50Db: p50Db,
          p90Db: p90Db,
          p95Db: p95Db,
          maxDb: maxDb,
          hasData: hasData,
        ),
      ],
    );
  }
}

class _StatisticsGrid extends StatelessWidget {
  const _StatisticsGrid({
    required this.minDb,
    required this.averageDb,
    required this.p50Db,
    required this.p90Db,
    required this.p95Db,
    required this.maxDb,
    required this.hasData,
    this.compact = false,
  });

  final double minDb;
  final double averageDb;
  final double p50Db;
  final double p90Db;
  final double p95Db;
  final double maxDb;
  final bool hasData;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dash = '--';
    String num(double value) => hasData ? value.toStringAsFixed(1) : dash;

    Widget row(_StatItem left, _StatItem right) {
      return Row(
        children: [
          Expanded(child: left),
          Expanded(child: right),
        ],
      );
    }

    final gap = SizedBox(height: compact ? 6 : 10);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        row(
          _StatItem(
            compact: compact,
            label: l10n.min(num(minDb)),
            value: hasData ? minDb : null,
          ),
          _StatItem(
            compact: compact,
            label: l10n.percentile(50, num(p50Db)),
            value: hasData ? p50Db : null,
          ),
        ),
        gap,
        row(
          _StatItem(
            compact: compact,
            label: l10n.average(num(averageDb)),
            value: hasData ? averageDb : null,
          ),
          _StatItem(
            compact: compact,
            label: l10n.percentile(90, num(p90Db)),
            value: hasData ? p90Db : null,
          ),
        ),
        gap,
        row(
          _StatItem(
            compact: compact,
            label: l10n.peak(num(maxDb)),
            value: hasData ? maxDb : null,
          ),
          _StatItem(
            compact: compact,
            label: l10n.percentile(95, num(p95Db)),
            value: hasData ? p95Db : null,
          ),
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.label, this.value, this.compact = false});

  final String label;
  final double? value;
  final bool compact;

  /// 根据分贝值返回对应的颜色
  static Color _getColorForDb(double db) {
    if (db < 40) {
      return const Color(0xFF2E7D32);
    } else if (db < 70) {
      return const Color(0xFFFFB300);
    } else if (db < 90) {
      return const Color(0xFFFF7043);
    } else {
      return const Color(0xFFC62828);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = value != null
        ? _getColorForDb(value!)
        : Theme.of(context).colorScheme.onSurfaceVariant;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: compact ? 4 : 6, horizontal: 4),
      child: Text(
        label,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: value != null ? FontWeight.w500 : FontWeight.normal,
        ),
      ),
    );
  }
}

class _WaterGauge extends StatefulWidget {
  const _WaterGauge({
    required this.liveDb,
    required this.isActive,
    this.size = 188,
  });

  final ValueListenable<double> liveDb;
  final bool isActive;
  final double size;

  static const double maxDb = 120;

  @override
  State<_WaterGauge> createState() => _WaterGaugeState();
}

class _WaterGaugeState extends State<_WaterGauge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _waveController;
  late double _targetDb;
  late double _displayedDb;

  static const double _lerpFactor = 0.14;

  @override
  void initState() {
    super.initState();
    _targetDb = widget.liveDb.value;
    _displayedDb = _targetDb;
    widget.liveDb.addListener(_onLiveDb);
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..addListener(_tick);
    if (_isFlutterTest) {
      _waveController.value = 0.35;
    } else {
      _waveController.repeat();
    }
  }

  void _onLiveDb() {
    _targetDb = widget.liveDb.value;
  }

  void _tick() {
    _displayedDb += (_targetDb - _displayedDb) * _lerpFactor;
  }

  @override
  void didUpdateWidget(covariant _WaterGauge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.liveDb != widget.liveDb) {
      oldWidget.liveDb.removeListener(_onLiveDb);
      widget.liveDb.addListener(_onLiveDb);
      _targetDb = widget.liveDb.value;
    }
  }

  @override
  void dispose() {
    widget.liveDb.removeListener(_onLiveDb);
    _waveController.dispose();
    super.dispose();
  }

  static Color _waterColor(ColorScheme scheme, double db) {
    final t = (db / 120).clamp(0.0, 1.0);
    if (t < 40 / 120) {
      return Color.lerp(
        scheme.primary,
        const Color(0xFFFFB300),
        t / (40 / 120),
      )!;
    }
    if (t < 70 / 120) {
      return Color.lerp(
        const Color(0xFFFFB300),
        const Color(0xFFFF7043),
        (t - 40 / 120) / (30 / 120),
      )!;
    }
    if (t < 90 / 120) {
      return Color.lerp(
        const Color(0xFFFF7043),
        scheme.error,
        (t - 70 / 120) / (20 / 120),
      )!;
    }
    return scheme.error;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return RepaintBoundary(
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: AnimatedBuilder(
          animation: _waveController,
          builder: (context, child) {
            final accent = _waterColor(colorScheme, _displayedDb);
            return CustomPaint(
              painter: _PaperDialPainter(
                value: _displayedDb,
                accent: accent,
                scheme: colorScheme,
                active: widget.isActive,
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(top: widget.size * 0.10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.current,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          letterSpacing: 2.2,
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        _displayedDb.toStringAsFixed(1),
                        style: Theme.of(context).textTheme.displayMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: widget.isActive
                                  ? accent
                                  : colorScheme.onSurface,
                              letterSpacing: -2,
                              height: 0.95,
                            ),
                      ),
                      Text(
                        'dB',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          letterSpacing: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _PaperDialPainter extends CustomPainter {
  const _PaperDialPainter({
    required this.value,
    required this.accent,
    required this.scheme,
    required this.active,
  });

  final double value;
  final Color accent;
  final ColorScheme scheme;
  final bool active;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide * 0.43;
    const start = math.pi * 0.72;
    const sweep = math.pi * 1.56;
    final rect = Rect.fromCircle(center: center, radius: radius);

    canvas.drawArc(
      rect,
      start,
      sweep,
      false,
      Paint()
        ..color = scheme.outlineVariant.withValues(alpha: 0.45)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round,
    );

    final progress = (value / _WaterGauge.maxDb).clamp(0.0, 1.0);
    if (active || progress > 0) {
      canvas.drawArc(
        rect,
        start,
        sweep * progress,
        false,
        Paint()
          ..color = accent
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5
          ..strokeCap = StrokeCap.round,
      );
    }

    for (var i = 0; i <= 24; i++) {
      final angle = start + sweep * i / 24;
      final major = i % 4 == 0;
      final outer = Offset(
        center.dx + math.cos(angle) * (radius - 10),
        center.dy + math.sin(angle) * (radius - 10),
      );
      final innerRadius = radius - (major ? 22 : 16);
      final inner = Offset(
        center.dx + math.cos(angle) * innerRadius,
        center.dy + math.sin(angle) * innerRadius,
      );
      canvas.drawLine(
        inner,
        outer,
        Paint()
          ..color = (i / 24 <= progress ? accent : scheme.onSurfaceVariant)
              .withValues(alpha: major ? 0.72 : 0.30)
          ..strokeWidth = major ? 1.8 : 1,
      );
    }

    canvas.drawCircle(
      center,
      radius * 0.90,
      Paint()
        ..color = scheme.outlineVariant.withValues(alpha: 0.18)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(covariant _PaperDialPainter oldDelegate) {
    return oldDelegate.value != value ||
        oldDelegate.accent != accent ||
        oldDelegate.scheme != scheme ||
        oldDelegate.active != active;
  }
}

class _HeaderAction extends StatelessWidget {
  const _HeaderAction({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return IconButton(
      icon: Icon(icon, size: 22),
      color: primary,
      tooltip: tooltip,
      onPressed: onPressed,
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
      style: _isDesktopPointerPlatform
          ? IconButton.styleFrom(
              shape: const CircleBorder(),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              minimumSize: const Size(40, 40),
              maximumSize: const Size(40, 40),
              padding: const EdgeInsets.all(9),
              hoverColor: primary.withValues(alpha: 0.10),
              highlightColor: primary.withValues(alpha: 0.16),
            )
          : null,
    );
  }
}

class _ControlButton extends StatelessWidget {
  const _ControlButton({
    required this.isRecording,
    required this.label,
    required this.onPressed,
    this.size = 84,
    this.compact = false,
  });

  final bool isRecording;
  final String label;
  final VoidCallback onPressed;
  final double size;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final accent = isRecording ? colorScheme.error : colorScheme.primary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onPressed,
            customBorder: const CircleBorder(),
            splashFactory: _isDesktopPointerPlatform
                ? NoSplash.splashFactory
                : InkRipple.splashFactory,
            overlayColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.pressed)) {
                return Colors.white.withValues(alpha: 0.22);
              }
              if (states.contains(WidgetState.hovered)) {
                return Colors.white.withValues(alpha: 0.14);
              }
              return Colors.transparent;
            }),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: size,
              height: size,
              decoration: BoxDecoration(shape: BoxShape.circle, color: accent),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  child: isRecording
                      ? Container(
                          key: const ValueKey('stop'),
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        )
                      : Icon(
                          key: const ValueKey('mic'),
                          Icons.mic_rounded,
                          color: Colors.white,
                          size: compact ? 28 : 36,
                        ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: compact ? 6 : 10),
        Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: accent,
            fontWeight: FontWeight.w500,
            letterSpacing: compact ? 0.6 : 1.4,
          ),
        ),
      ],
    );
  }
}
