import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends GetxService {
  final supabase = Supabase.instance.client;
  
  final isLoggedIn = false.obs;
  final currentUser = Rxn<User>();

  Future<AuthService> init() async {
    // Cek status login saat aplikasi dibuka
    final session = supabase.auth.currentSession;
    if (session != null) {
      isLoggedIn.value = true;
      currentUser.value = session.user;
    }

    // Listen perubahan auth state
    supabase.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      if (session != null) {
        isLoggedIn.value = true;
        currentUser.value = session.user;
      } else {
        isLoggedIn.value = false;
        currentUser.value = null;
      }
    });

    return this;
  }

  Future<void> logout() async {
    try {
      await supabase.auth.signOut();
      
      // Hapus SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      
      isLoggedIn.value = false;
      currentUser.value = null;
      
      // Redirect ke login
      Get.offAllNamed('/login');
    } catch (e) {
      print('Logout error: $e');
    }
  }

  bool get isAuthenticated => isLoggedIn.value;
  
  String? get userEmail => currentUser.value?.email;
  
  String? get userId => currentUser.value?.id;
}