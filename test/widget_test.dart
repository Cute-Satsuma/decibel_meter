import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:decibel_meter/main.dart';

void main() {
  testWidgets('分贝仪应用启动测试', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1280);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const DecibelMeterApp());

    expect(find.text('dB Meter'), findsOneWidget);
    expect(find.text('Start Measuring'), findsOneWidget);
    expect(
      find.text('Tap the button below to start measuring'),
      findsOneWidget,
    );
  });

  testWidgets('分贝仪页面初始状态测试', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1280);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const DecibelMeterApp());

    expect(find.text('dB Meter'), findsOneWidget);
    expect(find.text('Start Measuring'), findsOneWidget);
    expect(
      find.text('Tap the button below to start measuring'),
      findsOneWidget,
    );
    expect(find.text('Stop'), findsNothing);
  });

  testWidgets('横屏测量页不溢出', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const DecibelMeterApp());
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.text('dB Meter'), findsOneWidget);
    expect(find.text('Start Measuring'), findsOneWidget);
    expect(find.text('Tap the button to start measuring'), findsOneWidget);
    expect(find.text('Tap the button below to start measuring'), findsNothing);
  });

  testWidgets('横屏统计区块完整可见', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(740, 360);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const DecibelMeterApp());
    await tester.pump();

    expect(tester.takeException(), isNull);

    final view = tester.getRect(find.byType(Scaffold));
    for (final text in [
      'Statistics',
      'Min: -- dB',
      'Peak: -- dB',
      'P95: -- dB',
    ]) {
      final finder = find.text(text);
      expect(finder, findsOneWidget);
      final rect = tester.getRect(finder);
      expect(
        rect.bottom,
        lessThanOrEqualTo(view.bottom + 0.5),
        reason: '$text 底部被截断',
      );
      expect(
        rect.top,
        greaterThanOrEqualTo(view.top - 0.5),
        reason: '$text 顶部被截断',
      );
    }
  });

  testWidgets('窄屏标题完整可见', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 780);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const DecibelMeterApp());
    await tester.pump();

    expect(tester.takeException(), isNull);
    final title = find.text('dB Meter');
    expect(title, findsOneWidget);
    final view = tester.getRect(find.byType(Scaffold));
    final rect = tester.getRect(title);
    expect(rect.left, greaterThanOrEqualTo(view.left - 0.5));
    expect(rect.right, lessThanOrEqualTo(view.right + 0.5));
    expect(
      (rect.center.dx - view.center.dx).abs(),
      lessThan(2.0),
      reason: '标题应相对屏幕水平居中',
    );
  });
}
