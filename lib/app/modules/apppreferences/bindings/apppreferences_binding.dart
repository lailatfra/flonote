import 'package:get/get.dart';

import '../controllers/apppreferences_controller.dart';

class ApppreferencesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApppreferencesController>(
      () => ApppreferencesController(),
    );
  }
}
