import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:record/record.dart';
import 'package:decibel_meter/l10n/generated/app_localizations.dart';
import 'package:decibel_meter/database/database_helper.dart';
import 'package:decibel_meter/database/measurement_record.dart';
import 'package:decibel_meter/history/history_page.dart';

void main() {
  runApp(const DecibelMeterApp());
}

class DecibelMeterApp extends StatelessWidget {
  const DecibelMeterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CS Decibel Meter',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),       // English
        Locale('zh', 'CN'), // Chinese (Simplified)
        Locale('es'),       // Spanish
        Locale('hi'),       // Hindi
        Locale('ar'),       // Arabic
        Locale('pt'),       // Portuguese
        Locale('bn'),       // Bengali
        Locale('ru'),       // Russian
        Locale('ja'),       // Japanese
        Locale('de'),       // German
      ],
      // 不设置 locale，让应用自动跟随系统语言
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1B5E20),
          brightness: Brightness.light,
          primary: const Color(0xFF2E7D32),
        ),
        useMaterial3: true,
        fontFamily: 'system',
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4CAF50),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const DecibelMeterPage(),
    );
  }
}

class DecibelMeterPage extends StatefulWidget {
  const DecibelMeterPage({super.key});

  @override
  State<DecibelMeterPage> createState() => _DecibelMeterPageState();
}

class _DecibelMeterPageState extends State<DecibelMeterPage> {
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
    if (_isRecording) {
      await _stopMeasuring();
      return;
    }
    await _startMeasuring();
  }

  Future<void> _startMeasuring() async {
    setState(() {
      _errorMessage = null;
      _currentDb = 0; // 重置当前值
      _maxDb = 0;
      _minDb = null; // 重置为 null，从第一次测量值开始
      _dbHistory.clear(); // 清空历史数据
      _measurementStartTime = DateTime.now(); // 记录开始时间
    });

    final hasPermission = await _recorder.hasPermission();
    if (!hasPermission) {
      if (!mounted) return;
      setState(() {
        _errorMessage = AppLocalizations.of(context)!.permissionDenied;
      });
      return;
    }

    try {
      if (await _recorder.isRecording()) {
        await _recorder.stop();
      }

      const config = RecordConfig(
        encoder: AudioEncoder.pcm16bits,
        sampleRate: 44100,
        numChannels: 1,
      );

      final recordStream = await _recorder.startStream(config);
      _recordStreamSubscription = recordStream.listen(
        (_) {},
        onError: (Object e) {
          if (mounted) setState(() => _errorMessage = e.toString());
        },
      );

      _amplitudeSubscription = _recorder
          .onAmplitudeChanged(const Duration(milliseconds: 100))
          .listen((Amplitude amplitude) {
        if (!mounted) return;
        // 过滤异常值：如果振幅值异常（NaN、无穷大或超出合理范围），跳过更新
        if (amplitude.current.isNaN || 
            amplitude.current.isInfinite ||
            amplitude.current < -100 || 
            amplitude.current > 10) {
          return;
        }
        final current = _dbfsToDisplayDb(amplitude.current);
        // 确保转换后的值在合理范围内
        if (current < 0 || current > 120) {
          return;
        }
        setState(() {
          _currentDb = current; // 实时显示当前值
          // 只有在开始测量后（3秒延迟后）才记录统计数据
          if (_isMeasuring && current > 0) {
            if (current > _maxDb) _maxDb = current;
            // 更新最小值：如果还没有最小值，或者当前值更小
            if (_minDb == null || current < _minDb!) {
              _minDb = current;
            }
            _dbHistory.add(current); // 记录历史数据
          }
        });
      });

      // 开始倒计时（3、2、1）
      _countdown = 3;
      int remainingSeconds = 3;
      _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted || !_isRecording) {
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

      // 3秒后开始正式测量和统计
      _measurementDelayTimer = Timer(const Duration(seconds: 3), () {
        if (mounted && _isRecording) {
          setState(() {
            _isMeasuring = true;
            _countdown = 0; // 倒计时结束
            // 使用当前值初始化统计值（如果有效且大于0）
            final current = _currentDb;
            if (current > 0) {
              _maxDb = current;
              _minDb = current;
              _dbHistory.add(current);
            }
          });
        }
      });

      setState(() {
        _isRecording = true;
        _isMeasuring = false; // 初始为 false，3秒后才开始测量
        _countdown = 3; // 开始倒计时
        _currentDb = 0; // 初始值设为0，等待实际测量值
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = AppLocalizations.of(context)!.micError(e.toString());
      });
    }
  }

  Future<void> _stopMeasuring() async {
    _measurementDelayTimer?.cancel();
    _measurementDelayTimer = null;
    _countdownTimer?.cancel();
    _countdownTimer = null;
    await _amplitudeSubscription?.cancel();
    _amplitudeSubscription = null;
    await _recordStreamSubscription?.cancel();
    _recordStreamSubscription = null;
    try {
      await _recorder.stop();
    } catch (_) {}
    
    // 保存测量记录到数据库
    if (_isMeasuring && _dbHistory.isNotEmpty && _measurementStartTime != null) {
      final duration = DateTime.now().difference(_measurementStartTime!).inSeconds;
      if (duration > 0 && _minDb != null) {
        try {
          final record = MeasurementRecord(
            timestamp: _measurementStartTime!.millisecondsSinceEpoch,
            duration: duration,
            minDb: _minDb!,
            maxDb: _maxDb,
            avgDb: _getAverage(),
            p50Db: _getPercentile(50),
            p90Db: _getPercentile(90),
            p95Db: _getPercentile(95),
          );
          await _dbHelper.insertRecord(record);
        } catch (e) {
          // 保存失败不影响停止测量
          debugPrint('保存测量记录失败: $e');
        }
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
    _measurementDelayTimer?.cancel();
    _countdownTimer?.cancel();
    _amplitudeSubscription?.cancel();
    _recordStreamSubscription?.cancel();
    _recorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  // 标题行：标题居中，历史记录按钮在右侧
                  Row(
                    children: [
                      // 左侧占位（保持对称）
                      SizedBox(
                        width: 48, // IconButton 的宽度
                      ),
                      // 中间标题（居中）
                      Expanded(
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.decibelMeter,
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.info_outline, size: 20, color: Colors.red),
                                onPressed: () => _showMeasurementInfo(context),
                                tooltip: AppLocalizations.of(context)!.measurementInfo,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // 右侧历史记录按钮
                      IconButton(
                        icon: const Icon(Icons.history),
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
                  const SizedBox(height: 32),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_errorMessage != null) ...[
                      Icon(Icons.mic_off, size: 48, color: Theme.of(context).colorScheme.error),
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage!,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Theme.of(context).colorScheme.error),
                      ),
                    ] else ...[
                      _DecibelDisplay(
                        currentDb: _currentDb,
                        maxDb: _maxDb,
                        minDb: _minDb ?? 0,
                        averageDb: _getAverage(),
                        p50Db: _getPercentile(50),
                        p90Db: _getPercentile(90),
                        p95Db: _getPercentile(95),
                        isActive: _isRecording,
                        hasData: _isMeasuring && _dbHistory.isNotEmpty,
                      ),
                      const SizedBox(height: 32),
                      _LevelBar(
                        value: _isRecording ? _currentDb : 0,
                        countdown: _isRecording && !_isMeasuring ? _countdown : null,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _isRecording 
                            ? (_isMeasuring 
                                ? AppLocalizations.of(context)!.measuring
                                : AppLocalizations.of(context)!.initializing)
                            : AppLocalizations.of(context)!.tapToStart,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: FilledButton.icon(
                  onPressed: _toggleRecording,
                  icon: Icon(_isRecording ? Icons.stop : Icons.mic),
                  label: Text(_isRecording 
                      ? AppLocalizations.of(context)!.stop
                      : AppLocalizations.of(context)!.startMeasuring),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    backgroundColor: _isRecording
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DecibelDisplay extends StatelessWidget {
  const _DecibelDisplay({
    required this.currentDb,
    required this.maxDb,
    required this.minDb,
    required this.averageDb,
    required this.p50Db,
    required this.p90Db,
    required this.p95Db,
    required this.isActive,
    required this.hasData,
  });

  final double currentDb;
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
        Text(
          AppLocalizations.of(context)!.current,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          currentDb.toStringAsFixed(1),
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: isActive ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurfaceVariant,
                letterSpacing: -2,
              ),
        ),
        Text(
          'dB',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 32),
        Divider(),
        const SizedBox(height: 16),
        Text(
          AppLocalizations.of(context)!.statistics,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 16),
        _StatisticsGrid(
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
  });

  final double minDb;
  final double averageDb;
  final double p50Db;
  final double p90Db;
  final double p95Db;
  final double maxDb;
  final bool hasData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 第一行：最小值、平均值、峰值
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: _StatItem(
                label: AppLocalizations.of(context)!.min(
                  hasData ? minDb.toStringAsFixed(1) : '--',
                ),
                value: hasData ? minDb : null,
              ),
            ),
            Expanded(
              child: _StatItem(
                label: AppLocalizations.of(context)!.average(
                  hasData ? averageDb.toStringAsFixed(1) : '--',
                ),
                value: hasData ? averageDb : null,
              ),
            ),
            Expanded(
              child: _StatItem(
                label: AppLocalizations.of(context)!.peak(
                  hasData ? maxDb.toStringAsFixed(1) : '--',
                ),
                value: hasData ? maxDb : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // 第二行：百分位值
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: _StatItem(
                label: AppLocalizations.of(context)!.percentile(
                  50,
                  hasData ? p50Db.toStringAsFixed(1) : '--',
                ),
                value: hasData ? p50Db : null,
              ),
            ),
            Expanded(
              child: _StatItem(
                label: AppLocalizations.of(context)!.percentile(
                  90,
                  hasData ? p90Db.toStringAsFixed(1) : '--',
                ),
                value: hasData ? p90Db : null,
              ),
            ),
            Expanded(
              child: _StatItem(
                label: AppLocalizations.of(context)!.percentile(
                  95,
                  hasData ? p95Db.toStringAsFixed(1) : '--',
                ),
                value: hasData ? p95Db : null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.label,
    this.value,
  });

  final String label;
  final double? value;

  /// 根据分贝值返回对应的颜色
  static Color _getColorForDb(double db) {
    if (db < 40) {
      return Colors.green; // 安静 (0-40 dB)
    } else if (db < 70) {
      return Colors.orange; // 中等 (40-70 dB)
    } else if (db < 90) {
      return Colors.deepOrange; // 较响 (70-90 dB)
    } else {
      return Colors.red; // 很响 (90-120 dB)
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = value != null 
        ? _getColorForDb(value!)
        : Theme.of(context).colorScheme.onSurfaceVariant;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: value != null ? FontWeight.w600 : FontWeight.normal,
            ),
      ),
    );
  }
}


class _LevelBar extends StatelessWidget {
  const _LevelBar({
    required this.value,
    this.countdown,
  });

  final double value;
  final int? countdown; // 倒计时（3、2、1）

  static const double minDb = 0;
  static const double maxDb = 120;

  @override
  Widget build(BuildContext context) {
    final t = ((value - minDb) / (maxDb - minDb)).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$minDb', style: Theme.of(context).textTheme.labelSmall),
              // 倒计时显示在中间
              Opacity(
                opacity: (countdown != null && countdown! > 0) ? 1.0 : 0.0,
                child: Text(
                  countdown?.toString() ?? '',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ),
              Text('$maxDb', style: Theme.of(context).textTheme.labelSmall),
            ],
          ),
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: t,
            minHeight: 12,
            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(
              t > 0.8
                  ? Theme.of(context).colorScheme.error
                  : t > 0.5
                      ? Colors.orange
                      : Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
