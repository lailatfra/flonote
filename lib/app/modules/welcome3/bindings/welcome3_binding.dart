import 'package:get/get.dart';

import '../controllers/welcome3_controller.dart';

class Welcome3Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<Welcome3Controller>(
      () => Welcome3Controller(),
    );
  }
}
