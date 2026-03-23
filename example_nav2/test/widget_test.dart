import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:example_nav2/main.dart';

void main() {
  tearDown(Get.reset);

  testWidgets('example_nav2 state-only demo works', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byKey(const Key('auth_status_text')), findsOneWidget);
    expect(find.text('Guest'), findsOneWidget);
    expect(find.byKey(const Key('selected_product_text')), findsOneWidget);
    expect(find.text('Selected: Desk Lamp'), findsOneWidget);
    expect(find.byKey(const Key('cart_count_text')), findsOneWidget);
    expect(find.text('Cart: 0'), findsOneWidget);

    await tester.tap(find.text('Login'));
    await tester.pump();

    expect(find.text('Logged in'), findsOneWidget);
    expect(find.text('You are logged in.'), findsOneWidget);

    await tester.tap(find.byKey(const Key('product_tile_2')));
    await tester.pump();

    expect(find.text('Selected: Noise Cancelling Headphones'), findsOneWidget);

    await tester.tap(find.text('Add to cart'));
    await tester.pump();

    expect(find.text('Cart: 1'), findsOneWidget);
  });
}
