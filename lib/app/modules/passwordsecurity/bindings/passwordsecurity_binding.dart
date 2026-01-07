import 'package:get/get.dart';

import '../controllers/passwordsecurity_controller.dart';

class PasswordsecurityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PasswordsecurityController>(
      () => PasswordsecurityController(),
    );
  }
}
