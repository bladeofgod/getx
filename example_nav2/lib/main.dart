import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'models/demo_product.dart';
import 'services/auth_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Application',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: Binds(
        binds: [
          Bind.put(AuthService()),
          Bind.put(CatalogController()),
        ],
        child: const CatalogPage(),
      ),
    );
  }
}

class CatalogController extends GetxController {
  final products = <DemoProduct>[
    DemoProduct(id: 'P-1001', name: 'Desk Lamp'),
    DemoProduct(id: 'P-1002', name: 'Mechanical Keyboard'),
    DemoProduct(id: 'P-1003', name: 'Noise Cancelling Headphones'),
  ];

  int selectedIndex = 0;
  final cartCount = 0.obs;

  DemoProduct get selectedProduct => products[selectedIndex];

  void selectProduct(int index) {
    selectedIndex = index;
    update(['selection']);
  }

  void addToCart() {
    cartCount.value++;
  }
}

class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthService>();
    final catalog = Get.find<CatalogController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('GetX State + DI Example'),
        actions: [
          Obx(
            () => Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  auth.isLoggedInValue ? 'Logged in' : 'Guest',
                  key: const Key('auth_status_text'),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'AuthService (reactive state via Obx)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Obx(
                      () => Text(
                        auth.isLoggedInValue
                            ? 'You are logged in.'
                            : 'You are browsing as a guest.',
                        key: const Key('auth_message_text'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      children: [
                        FilledButton(
                          onPressed: auth.login,
                          child: const Text('Login'),
                        ),
                        OutlinedButton(
                          onPressed: auth.logout,
                          child: const Text('Logout'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'CatalogController (targeted updates via GetBuilder)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: catalog.products.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final product = catalog.products[index];
                  return GetBuilder<CatalogController>(
                    id: 'selection',
                    builder: (controller) => ListTile(
                      key: Key('product_tile_$index'),
                      tileColor: controller.selectedIndex == index
                          ? Theme.of(context).colorScheme.primaryContainer
                          : null,
                      title: Text(product.name),
                      subtitle: Text(product.id),
                      onTap: () => controller.selectProduct(index),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            GetBuilder<CatalogController>(
              id: 'selection',
              builder: (controller) => Text(
                'Selected: ${controller.selectedProduct.name}',
                key: const Key('selected_product_text'),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: catalog.addToCart,
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text('Add to cart'),
                  ),
                ),
                const SizedBox(width: 12),
                Obx(
                  () => Text(
                    'Cart: ${catalog.cartCount.value}',
                    key: const Key('cart_count_text'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
