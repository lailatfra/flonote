import 'package:get/get.dart';
import 'dart:math';
import '../../../routes/app_pages.dart';

class SettingController extends GetxController {
  // Data statistik tahunan (12 bulan terakhir)
  final yearlyData = <Map<String, dynamic>>[].obs;
  final selectedMonth = 'Oktober 2024'.obs;
  
  // Data statistik bulanan (30 hari)
  final monthlyData = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _generateYearlyData();
    _generateMonthlyData();
  }

  // Generate data kunjungan tahunan (random untuk demo)
  void _generateYearlyData() {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 
                    'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    final random = Random();
    
    yearlyData.value = months.map((month) {
      return {
        'month': month,
        'visits': random.nextInt(100) + 20, // 20–120 kunjungan
      };
    }).toList();
  }

  // Generate data kunjungan bulanan (30 hari)
  void _generateMonthlyData() {
    final random = Random();
    
    monthlyData.value = List.generate(30, (index) {
      return {
        'day': index + 1,
        'visits': random.nextInt(12), // 0–12 kunjungan per hari
      };
    });
  }

  // Hitung total kunjungan tahunan
  int get totalYearlyVisits {
    return yearlyData.fold(0, (sum, data) => sum + (data['visits'] as int));
  }

  // Hitung kunjungan tertinggi untuk scaling bar chart
  int get maxYearlyVisits {
    if (yearlyData.isEmpty) return 100;
    return yearlyData.map((e) => e['visits'] as int).reduce((a, b) => a > b ? a : b);
  }

  // Hitung rata-rata kunjungan harian bulan ini
  double get averageDailyVisits {
    if (monthlyData.isEmpty) return 0;
    final total = monthlyData.fold(0, (sum, data) => sum + (data['visits'] as int));
    return total / monthlyData.length;
  }

  // === Navigasi & Snackbars ===
  void showStatistics() {
    Get.toNamed('/statistics');
  }

  void editProfile() {
    Get.toNamed(Routes.EDIT_PROFILE);
  }

  void applicationPreferences() {
    Get.snackbar(
      'Info',
      'Fitur Application Preferences akan segera hadir',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void passwordsAndSecurity() {
    Get.snackbar(
      'Info',
      'Fitur Passwords and Security akan segera hadir',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void privateNotes() {
    Get.snackbar(
      'Info',
      'Fitur Private Notes akan segera hadir',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
