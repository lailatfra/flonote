import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash_controller.dart';

class SplashView extends StatelessWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      init: SplashController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [


              Center(
                child: Obx(
                  () => AnimatedOpacity(
                    opacity: controller.showLogo.value ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 800),
                    child: Image.asset('assets/images/logo.png', width: 160),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}