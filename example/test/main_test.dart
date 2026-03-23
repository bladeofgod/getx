import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_demo/main.dart';

void main() {
  setUp(() => Get.reset());

  tearDown(() => Get.reset());

  test('CounterController increments both simple and reactive state', () {
    final controller = Get.put(CounterController());

    expect(controller.simpleCount, 0);
    expect(controller.rxCount.value, 0);

    controller.increment();
    controller.increment();

    expect(controller.simpleCount, 2);
    expect(controller.rxCount.value, 2);
  });

  test('Get.put registers and Get.delete removes controller', () {
    Get.put(CounterController());

    expect(Get.isRegistered<CounterController>(), isTrue);

    Get.delete<CounterController>();

    expect(Get.isRegistered<CounterController>(), isFalse);
  });
}
