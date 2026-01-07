import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flonote/app/routes/app_pages.dart';

class Welcome4View extends StatelessWidget {
  const Welcome4View({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFD0BDBD),
              Color(0xFFC2948E),
              Color(0xFFAB4F41),
            ],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            /// 🌥️ Awan besar, lebih ke kanan dan mepet bawah
            Positioned(
              bottom: -20, // sedikit ke bawah biar nutup
              left: -100, // geser ke kanan biar kepotong di kanan, bukan kiri
              child: Opacity(
                opacity: 0.5,
                child: Image.asset(
                  'assets/images/awan.png',
                  width: size.width * 2.0, // diperbesar 160% dari lebar layar
                  fit: BoxFit.cover,
                ),
              ),
            ),

            /// 🐿️ Tupai diperbesar lebih proporsional
            Positioned(
              top: 100,
              child: Image.asset(
                'assets/images/welcome4.png',
                width: size.width * 1.2, // lebih besar dari sebelumnya
              ),
            ),

            /// 📝 Teks + tombol
            Positioned(
              bottom: 120,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'MULAI SEKARANG!',
                    style: TextStyle(
                      color: Color(0xFF5D1F1E),
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Tombol Login
                  SizedBox(
                    width: 160,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: () => Get.offNamed(Routes.LOGIN),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5D1F1E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Tombol Register
                  SizedBox(
                    width: 160,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: () => Get.offNamed(Routes.REGISTER),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5D1F1E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Register',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
