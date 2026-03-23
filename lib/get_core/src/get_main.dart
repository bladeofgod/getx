import 'get_interface.dart';

/// The global GetX instance.
///
/// Provides lightweight dependency injection (`Get.put`, `Get.find`,
/// `Get.lazyPut`) and serves as the anchor for state management
/// extensions (`GetxController`, `Obx`, `GetBuilder`, etc.).
class _GetImpl extends GetInterface {}

// ignore: non_constant_identifier_names
final Get = _GetImpl();
