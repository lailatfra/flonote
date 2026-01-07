import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flonote/app/routes/app_pages.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 90.0), // agak turun
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                Image.asset('assets/images/welcome1.png', height: 240),
                const SizedBox(height: 25),
                LinearProgressIndicator(
                  value: 1 / 3,
                  color: const Color(0xFF5D1F1E),
                  backgroundColor: const Color(0xFFAB4F41),
                  minHeight: 8,
                ),
                const SizedBox(height: 40),
                Text(
                  'Tulis Apapun, Kapanpun',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF5D1F1E),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  '✏️ Catat ide, cerita, atau momen kecil dalam hidupmu.\nSimpan semua inspirasimu di satu tempat.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17, height: 1.5), // naik sedikit
                ),
              ],
            ),
          ),
          Positioned(
            right: 24,
            bottom: 24,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF5D1F1E),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_forward, color: Colors.white, size: 25),
                padding: const EdgeInsets.all(18),
                onPressed: () => Get.offNamed(Routes.WELCOME2), // langsung, tanpa animasi
              ),
            ),
          ),
        ],
      ),
    );
  }
}
