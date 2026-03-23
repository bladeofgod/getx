import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const CounterPage(),
    );
  }
}

class CounterController extends GetxController {
  int simpleCount = 0;
  final rxCount = 0.obs;

  void increment() {
    simpleCount++;
    rxCount.value++;
    update();
  }
}

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CounterController>(
      init: CounterController(),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: const Text('GetX State Manager Example'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: controller.increment,
          child: const Icon(Icons.add),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Simple state with GetBuilder',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  '${controller.simpleCount}',
                  key: const Key('simple_count_text'),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 32),
                const Text(
                  'Reactive state with Obx',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Obx(
                  () => Text(
                    '${controller.rxCount.value}',
                    key: const Key('rx_count_text'),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'This example uses MaterialApp + GetX state only.\n'
                  'No routing, snackbar, translations, or network layer.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
