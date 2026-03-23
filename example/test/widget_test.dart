import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:get_demo/main.dart';

void main() {
  testWidgets('Counter page increments both GetBuilder and Obx values',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byKey(const Key('simple_count_text')), findsOneWidget);
    expect(find.byKey(const Key('rx_count_text')), findsOneWidget);
    expect(find.text('0'), findsNWidgets(2));

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('1'), findsNWidgets(2));
  });
}
