import 'package:get/get.dart';

import '../controllers/privatenotes_controller.dart';

class PrivatenotesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PrivatenotesController>(
      () => PrivatenotesController(),
    );
  }
}
