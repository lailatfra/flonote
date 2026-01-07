import 'package:get/get.dart';

import '../controllers/welcome4_controller.dart';

class Welcome4Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<Welcome4Controller>(
      () => Welcome4Controller(),
    );
  }
}
