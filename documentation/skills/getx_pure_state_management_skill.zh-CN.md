---
name: getx-pure-state-management
description: 面向 agent 的 GetX 纯状态管理版技能文档。仅涵盖当前仓库真实存在的能力：状态管理、Rx、轻量级依赖注入、生命周期与少量工具；明确禁止假设导航、路由、Snackbar、Dialog、BottomSheet、国际化和网络层等历史能力。
---

# GetX 纯状态管理 Skill

## 适用场景

当 agent 需要在当前仓库中执行以下任务时，应使用本 skill：

- 新增或修改 `GetxController`
- 编写 `GetBuilder` / `Obx` / `GetX<T>` 页面
- 调整依赖注入逻辑（`Get.put` / `Get.lazyPut` / `Get.find`）
- 使用 Rx 与 Worker（`ever` / `once` / `debounce` / `interval`）
- 审查代码是否越过“纯状态管理”边界
- 为当前仓库生成示例、测试或开发文档

---

## 一句话边界

这是一个**纯状态管理版 GetX** 仓库。

只应使用以下能力：

- 状态管理
- Rx 响应式编程
- 轻量级依赖注入
- 生命周期与 Worker
- 少量工具扩展

不要引入或假设存在以下历史版能力：

- 路由 / 导航
- `GetMaterialApp`
- `GetPage`
- `Get.to` / `Get.off` / `Get.back`
- `Snackbar` / `Dialog` / `BottomSheet` 封装
- 国际化 / `Translations`
- 中间件
- 网络层封装（如 `GetConnect`）

---

## 当前仓库事实

### 工程定位

来自 `pubspec.yaml`：

- 包名：`get`
- 描述：`GetX 状态管理精简版 - 高性能状态管理、响应式编程（Rx）和轻量级依赖注入。`
- 运行环境：Dart `>=3.4.0 <4.0.0`，Flutter `>=3.22.0`

### 对外入口

优先使用：

- `lib/get.dart`

可按需使用：

- `lib/state_manager.dart`
- `lib/instance_manager.dart`
- `lib/utils.dart`

`lib/get.dart` 当前只导出：

- `get_core`
- `get_instance`
- `get_rx`
- `get_state_manager`
- `get_utils`

这意味着当前公共能力边界已经收敛，不要按历史版 README 推断更多模块。

### 示例事实

`example/lib/main.dart` 证明：

- 示例应用使用的是 `MaterialApp`
- 页面同时演示 `GetBuilder` 和 `Obx`
- 示例明确说明：**No routing, snackbar, translations, or network layer**

### 测试事实

当前测试主要覆盖：

- `test/state_manager/get_state_test.dart`
- `test/state_manager/get_obx_test.dart`
- `test/state_manager/get_rxstate_test.dart`
- `test/rx/rx_workers_test.dart`

这说明当前真实维护重点是：

- 控制器状态更新
- Rx 响应式渲染
- `GetX<T>` / `GetBuilder` 行为
- Worker 语义

---

## 允许使用的能力

### 1. 依赖注入

来自 `lib/get_instance/src/extension_instance.dart`：

- `Get.put`
- `Get.lazyPut`
- `Get.spawn`
- `Get.find`
- `Get.findOrNull`
- `Get.delete`
- `Get.deleteAll`
- `Get.reload`
- `Get.reloadAll`
- `Get.reset`
- `Get.isRegistered`
- `Get.isPrepared`

推荐原则：

- 局部页面状态：优先 `init:` 或 `global: false`
- 共享状态：用 `Get.put` / `Get.lazyPut`
- 惰性实例：优先 `Get.lazyPut`
- 短生命周期对象：可用 `global: false` 或 `Get.spawn`

### 2. 简单状态管理

来自 `lib/get_state_manager/src/simple/`：

- `GetxController`
- `GetBuilder`
- `update()`
- `update([ids])`
- `Bind` / `Binder`
- `GetView`
- `GetWidget`
- `GetResponsiveView`
- `GetResponsiveWidget`
- `ValueBuilder`

适用场景：

- 由控制器显式触发刷新
- 粗粒度或分组刷新
- 希望手动控制渲染时机

### 3. 响应式状态管理

来自 `lib/get_rx` 与 `lib/get_state_manager/src/rx_flutter/`：

- `.obs`
- `Rx<T>` / `Rxn<T>`
- `RxInt` / `RxDouble` / `RxString` / `RxBool`
- `RxList` / `RxMap` / `RxSet`
- `Obx`
- `ObxValue`
- `GetX<T>`
- `StateMixin<T>`
- `GetNotifier<T>`

适用场景：

- 字段级响应更新
- 高频或局部刷新
- 多个 Rx 字段组合渲染

### 4. 生命周期与服务

来自 `lib/get_instance/src/lifecycle.dart` 与 `get_controllers.dart`：

- `GetLifeCycleMixin`
- `GetxService`
- `FullLifeCycleController`
- `FullLifeCycleMixin`
- `ScrollMixin`

推荐原则：

- 初始化逻辑：`onInit()`
- 首帧后副作用：`onReady()`
- 释放资源：`onClose()`
- 全局长期驻留对象：`GetxService`

### 5. Worker

来自 `lib/get_rx/src/rx_workers/rx_workers.dart`：

- `ever`
- `everAll`
- `once`
- `interval`
- `debounce`

推荐映射：

- 搜索输入防抖：`debounce`
- 高频点击节流：`interval`
- 每次变化都响应：`ever`
- 首次满足条件后执行：`once`

### 6. 工具

来自 `lib/get_utils`：

- `GetPlatform`
- `BuildContext` 扩展
- `Equality` / `DeepCollectionEquality`

---

## 明确禁止的假设

agent 在当前仓库中**不要**生成以下内容，除非用户明确要求“重新引入架构能力”，并且同步修改框架导出、示例与测试：

- `GetMaterialApp(...)`
- `GetPage(...)`
- `Get.to(...)`
- `Get.off(...)`
- `Get.back()`
- `Get.snackbar(...)`
- `Get.dialog(...)`
- `Get.bottomSheet(...)`
- `Translations`
- middleware / route observer / route tree
- 任何依赖旧导航体系的 binding 写法
- 把 `example_nav2` 当成当前事实来源

如果用户要求这类能力，agent 应先指出：

> 当前仓库已重构为纯状态管理框架，相关模块已被移除；不应直接按历史版 GetX API 继续补代码。

---

## 推荐决策规则

### 规则 1：先选渲染模型

- 需要手动刷新：用 `GetBuilder`
- 需要字段级响应：用 `Obx`
- 需要“控制器 + Rx”一起组织：用 `GetX<T>`

### 规则 2：再选注册方式

- 页面内直接创建：`init: Controller()`
- 共享实例：`Get.put(Controller())`
- 惰性共享实例：`Get.lazyPut(() => Controller())`
- 临时或非全局实例：`global: false`

### 规则 3：副作用走 Worker

- 输入联想：`debounce`
- 频繁事件节流：`interval`
- 每次变化同步外部状态：`ever`
- 一次性触发：`once`

### 规则 4：默认 UI 容器仍是 Flutter 原生

在 example、测试或新增页面里，默认使用：

```dart
MaterialApp(...)
```

不要自行替换成 `GetMaterialApp(...)`。

---

## 推荐代码模式

### 模式 A：简单状态

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CounterController extends GetxController {
  int count = 0;

  void increment() {
    count++;
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
        body: Center(child: Text('${controller.count}')),
        floatingActionButton: FloatingActionButton(
          onPressed: controller.increment,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
```

依据：`example/lib/main.dart`、`test/state_manager/get_state_test.dart`

### 模式 B：响应式状态

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CounterController extends GetxController {
  final count = 0.obs;

  void increment() => count.value++;
}

class CounterPage extends StatelessWidget {
  CounterPage({super.key});

  final controller = Get.put(CounterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(() => Text('${controller.count.value}')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.increment,
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

依据：`example/lib/main.dart`、`test/state_manager/get_obx_test.dart`

### 模式 C：混合状态

当控制器既有普通字段又有 Rx 字段时：

- 普通字段由 `GetBuilder` 管理
- Rx 字段由 `Obx` 管理

当前 `example/lib/main.dart` 就是这种混合模式：

- `simpleCount` → `GetBuilder`
- `rxCount` → `Obx`

### 模式 D：Worker

```dart
class SearchController extends GetxController {
  final keyword = ''.obs;
  Worker? keywordWorker;

  @override
  void onInit() {
    super.onInit();
    keywordWorker = debounce<String>(
      keyword,
      (value) {
        // 执行副作用
      },
      time: const Duration(milliseconds: 300),
    );
  }

  @override
  void onClose() {
    keywordWorker?.dispose();
    super.onClose();
  }
}
```

依据：`test/rx/rx_workers_test.dart`

---

## Ground Truth

当 agent 不确定当前能力边界时，优先读取这些文件，而不是历史 README：

### 框架定位

- `pubspec.yaml`
- `lib/get.dart`
- `lib/state_manager.dart`
- `lib/instance_manager.dart`
- `lib/utils.dart`

### 依赖注入与生命周期

- `lib/get_instance/src/extension_instance.dart`
- `lib/get_instance/src/lifecycle.dart`
- `lib/get_instance/src/bindings_interface.dart`

### 状态管理与 UI 绑定

- `lib/get_state_manager/src/simple/get_controllers.dart`
- `lib/get_state_manager/src/simple/get_state.dart`
- `lib/get_state_manager/src/simple/get_view.dart`
- `lib/get_state_manager/src/simple/get_responsive.dart`
- `lib/get_state_manager/src/rx_flutter/rx_getx_widget.dart`
- `lib/get_state_manager/src/rx_flutter/rx_obx_widget.dart`
- `lib/get_state_manager/src/rx_flutter/rx_notifier.dart`

### Rx 与 Worker

- `lib/get_rx/src/rx_types/rx_types.dart`
- `lib/get_rx/src/rx_types/rx_core/rx_impl.dart`
- `lib/get_rx/src/rx_workers/rx_workers.dart`

### 示例与测试

- `example/lib/main.dart`
- `test/state_manager/get_state_test.dart`
- `test/state_manager/get_obx_test.dart`
- `test/state_manager/get_rxstate_test.dart`
- `test/rx/rx_workers_test.dart`

---

## 修改后验证

agent 在修改当前仓库代码后，至少执行：

```bat
cd /d D:\zhike\bj_zhike\getx
flutter analyze
flutter test
```

本 skill 编写时，当前仓库状态已验证：

- `flutter analyze` 通过
- `flutter test` 通过

---

## 给 agent 的最终提示词

如果只需要一段短提示，可直接使用：

> 当前仓库是纯状态管理版 GetX。只使用 `GetBuilder`、`Obx`、`GetX<T>`、`.obs`、`Get.put/lazyPut/find/delete/reset`、生命周期与 Worker；默认基于 `MaterialApp` 工作；不要引入或假设存在导航、路由、Snackbar、Dialog、BottomSheet、国际化或网络层等历史版 GetX 能力。
