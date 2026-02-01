// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:decibel_meter/main.dart';

void main() {
  testWidgets('分贝仪应用启动测试', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DecibelMeterApp());

    // Verify that the app title is displayed.
    expect(find.text('分贝仪'), findsOneWidget);

    // Verify that the start button is displayed.
    expect(find.text('开始测量'), findsOneWidget);

    // Verify that initial state shows "点击下方按钮开始测量"
    expect(find.text('点击下方按钮开始测量'), findsOneWidget);
  });

  testWidgets('分贝仪页面初始状态测试', (WidgetTester tester) async {
    await tester.pumpWidget(const DecibelMeterApp());

    // Verify that the page shows initial state
    expect(find.text('分贝仪'), findsOneWidget);
    expect(find.text('开始测量'), findsOneWidget);
    expect(find.text('点击下方按钮开始测量'), findsOneWidget);
    
    // Verify that stop button is not shown initially
    expect(find.text('停止'), findsNothing);
  });
}
