import 'package:get/get.dart';

class MainController extends GetxController {
  // index halaman yang sedang aktif
  final currentIndex = 0.obs;

  void changeTab(int index) {
    currentIndex.value = index;
  }
}
