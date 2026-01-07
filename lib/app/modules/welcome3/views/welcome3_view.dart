import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flonote/app/routes/app_pages.dart';

class Welcome3View extends StatelessWidget {
  const Welcome3View({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 90.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                Image.asset('assets/images/welcome3.png', height: 240),
                const SizedBox(height: 25),
                LinearProgressIndicator(
                  value: 1,
                  color: const Color(0xFF5D1F1E),
                  backgroundColor: const Color(0xFFAB4F41),
                  minHeight: 8,
                ),
                const SizedBox(height: 40),
                Text(
                  'Mulai Perjalananmu Sekarang',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF5D1F1E),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  '🚀 Saatnya menulis kisahmu sendiri.\nMari mulai petualangan bersama Flonote!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17, height: 1.5),
                ),
              ],
            ),
          ),

          /// 🟤 Tombol kanan bawah dengan tinggi & posisi sama persis seperti tombol bundar
          Positioned(
            right: 24,
            bottom: 24,
            child: Container(
              height: 61, // sama dengan ukuran lingkaran (ikon + padding: 25 + 18*2 = 61)
              decoration: BoxDecoration(
                color: const Color(0xFF5D1F1E),
                borderRadius: BorderRadius.circular(30), // bentuk oval
              ),
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: TextButton.icon(
                onPressed: () => Get.offNamed(Routes.WELCOME4),
                icon: const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                label: const Text(
                  'Mulai Sekarang',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    letterSpacing: 0.3,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
