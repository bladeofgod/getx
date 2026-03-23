import 'package:flutter/widgets.dart';

import '../../../instance_manager.dart';
import '../../../get_utils/src/extensions/event_loop_extensions.dart';
import 'get_state.dart';
import 'get_widget_cache.dart';

/// GetView is a great way of quickly access your Controller
/// without having to call `Get.find<AwesomeController>()` yourself.
///
/// It automatically does `Get.find<T>()` for you and provides a
/// [controller] getter to access the registered controller.
///
/// Sample:
/// ```dart
/// // 1. Define your controller
/// class AwesomeController extends GetxController {
///   final title = 'My Awesome View'.obs;
///   final count = 0.obs;
///
///   void increment() => count.value++;
/// }
///
/// // 2. Register the controller (e.g. in your route or main)
/// // Get.put(AwesomeController());
///
/// // 3. Create a view that extends GetView
/// class AwesomeView extends GetView<AwesomeController> {
///   const AwesomeView({super.key});
///
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       appBar: AppBar(title: Obx(() => Text(controller.title.value))),
///       body: Center(
///         child: Obx(() => Text('Count: ${controller.count.value}')),
///       ),
///       floatingActionButton: FloatingActionButton(
///         onPressed: controller.increment,
///         child: const Icon(Icons.add),
///       ),
///     );
///   }
/// }
///
/// // 4. If you need a tagged controller, override [tag]:
/// class AnotherView extends GetView<AwesomeController> {
///   @override
///   final String tag = "myTag";
///
///   const AnotherView({super.key});
///
///   @override
///   Widget build(BuildContext context) {
///     // This will call Get.find<AwesomeController>(tag: "myTag")
///     return Text(controller.title.value);
///   }
/// }
/// ```
abstract class GetView<T> extends StatelessWidget {
  const GetView({super.key});

  final String? tag = null;

  T get controller => Get.find<T>(tag: tag)!;

  @override
  Widget build(BuildContext context);
}

/// GetWidget is a great way of quickly access your individual Controller
/// without having to call `Get.find<AwesomeController>()` yourself.
/// Get save you controller on cache, so, you can to use Get.create() safely
/// GetWidget is perfect to multiples instance of a same controller. Each
/// GetWidget will have your own controller, and will be call events as `onInit`
/// and `onClose` when the controller get in/get out on memory.
abstract class GetWidget<S extends GetLifeCycleMixin> extends GetWidgetCache {
  const GetWidget({super.key});

  @protected
  final String? tag = null;

  S get controller => GetWidget._cache[this] as S;

  // static final _cache = <GetWidget, GetLifeCycleBase>{};

  static final _cache = Expando<GetLifeCycleMixin>();

  @protected
  Widget build(BuildContext context);

  @override
  WidgetCache createWidgetCache() => _GetCache<S>();
}

class _GetCache<S extends GetLifeCycleMixin> extends WidgetCache<GetWidget<S>> {
  S? _controller;
  bool _isCreator = false;
  InstanceInfo? info;
  @override
  void onInit() {
    info = Get.getInstanceInfo<S>(tag: widget!.tag);

    _isCreator = info!.isPrepared && info!.isCreate;

    if (info!.isRegistered) {
      _controller = Get.find<S>(tag: widget!.tag);
    }

    GetWidget._cache[widget!] = _controller;

    super.onInit();
  }

  @override
  void onClose() {
    if (_isCreator) {
      Get.asap(() {
        widget!.controller.onDelete();
        Get.log('"${widget!.controller.runtimeType}" onClose() called');
        Get.log('"${widget!.controller.runtimeType}" deleted from memory');
        // GetWidget._cache[widget!] = null;
      });
    }
    info = null;
    super.onClose();
  }

  @override
  Widget build(BuildContext context) {
    return Binder(
      init: () => _controller,
      child: widget!.build(context),
    );
  }
}
