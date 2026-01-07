import 'dart:async';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../routes/app_pages.dart';

class SplashController extends GetxController {
  var showLogo = false.obs;

  @override
  void onInit() {
    super.onInit();
    startAnimation();
    navigateUser();
  }

  void startAnimation() {
    Timer(const Duration(seconds: 1), () {
      showLogo.value = true;
    });
  }

  void navigateUser() async {
    await Future.delayed(const Duration(seconds: 3));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      Get.offAllNamed(Routes.MAIN);
    } else {
      Get.offAllNamed(Routes.WELCOME);
    }
  }
}
