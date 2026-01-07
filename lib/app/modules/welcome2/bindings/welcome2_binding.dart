import 'package:get/get.dart';

import '../controllers/welcome2_controller.dart';

class Welcome2Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<Welcome2Controller>(
      () => Welcome2Controller(),
    );
  }
}
