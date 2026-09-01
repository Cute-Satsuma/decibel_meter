import 'package:decibel_meter/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// macOS App Store screenshots via golden files (1280×800 APP_DESKTOP).
void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    const recordChannel = MethodChannel('com.llfbandit.record/messages');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(recordChannel, (call) async {
      switch (call.method) {
        case 'create':
          return {'recorderId': 'test'};
        case 'hasPermission':
          return true;
        case 'isRecording':
          return false;
        case 'dispose':
          return null;
        default:
          return null;
      }
    });
  });

  Future<void> pumpDesktopApp(
    WidgetTester tester, {
    Size size = const Size(1280, 800),
    ThemeMode? themeMode,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    await tester.pumpWidget(
      RepaintBoundary(
        key: const Key('mac_store_shot'),
        child: DecibelMeterApp(
          locale: const Locale('en'),
          themeMode: themeMode,
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  testWidgets('macOS store screenshot 1 – desktop home', (tester) async {
    addTearDown(tester.view.reset);
    await pumpDesktopApp(tester);
    await expectLater(
      find.byKey(const Key('mac_store_shot')),
      matchesGoldenFile('../dist/appstore/macos/mac_1.png'),
    );
  });

  testWidgets('macOS store screenshot 2 – history', (tester) async {
    addTearDown(tester.view.reset);
    await pumpDesktopApp(tester);
    await tester.tap(find.byTooltip('History'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('History'), findsOneWidget);
    await expectLater(
      find.byKey(const Key('mac_store_shot')),
      matchesGoldenFile('../dist/appstore/macos/mac_2.png'),
    );
  });

  testWidgets('macOS store screenshot 3 – dark mode', (tester) async {
    addTearDown(tester.view.reset);
    await pumpDesktopApp(tester, themeMode: ThemeMode.dark);
    await expectLater(
      find.byKey(const Key('mac_store_shot')),
      matchesGoldenFile('../dist/appstore/macos/mac_3.png'),
    );
  });
}
