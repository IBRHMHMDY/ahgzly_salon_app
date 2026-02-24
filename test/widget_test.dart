import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ahgzly_salon_app/main.dart' as app;
import 'package:ahgzly_salon_app/core/di/injection_container.dart' as di;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await di.init();
  });

  testWidgets('App boots without crashing (smoke test)', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const app.AhgzlyApp());

    // يتيح لـ SplashPage بدء الـ Timer
    await tester.pump();

    // انتظر مدة الـ Timer الموجود في Splash (2s)
    await tester.pump(const Duration(seconds: 2));

    // أي Pump إضافية لتصفية إعادة البناء بعد التنقل
    await tester.pump();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
