import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Import AuthService
import 'package:flonote/app/services/auth_service.dart';
// Import Routes
import 'package:flonote/app/routes/app_pages.dart';

// Import halaman tujuan
import 'package:flonote/app/modules/edit_profile/views/edit_profile_view.dart';
import 'package:flonote/app/modules/apppreferences/views/apppreferences_view.dart';
import 'package:flonote/app/modules/passwordsecurity/views/passwordsecurity_view.dart';
import 'package:flonote/app/modules/privatenotes/views/privatenotes_view.dart';

class SettingView extends StatelessWidget {
  const SettingView({super.key});

  // Function untuk load profile dari Supabase
  Future<Map<String, dynamic>?> _getUserProfile(AuthService authService) async {
    try {
      final userId = authService.userId;
      if (userId == null) return null;

      final response = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();

      return response;
    } catch (e) {
      print('Error loading profile: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color darkRed = Color(0xFF5D1F1E);
    const Color whiteBg = Color(0xFFF3F3F3);
    
    // Ambil AuthService
    final authService = Get.find<AuthService>();

    return Scaffold(
      backgroundColor: whiteBg,
      appBar: AppBar(
        backgroundColor: darkRed,
        elevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  color: darkRed,
                  width: double.infinity,
                  height: 120,
                ),
                Positioned(
                  bottom: -60,
                  child: FutureBuilder<Map<String, dynamic>?>(
                    future: _getUserProfile(authService),
                    builder: (context, snapshot) {
                      final avatarUrl = snapshot.data?['avatar_url'];
                      final hasAvatar = avatarUrl != null && avatarUrl.isNotEmpty;

                      return Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFFF3F3F3), width: 8),
                        ),
                        child: hasAvatar
                            ? ClipOval(
                                child: Image.network(
                                  avatarUrl,
                                  width: 140,
                                  height: 140,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      width: 140,
                                      height: 140,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xFFAB4F41),
                                      ),
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      padding: const EdgeInsets.all(24),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xFFAB4F41),
                                      ),
                                      child: const Icon(
                                        Icons.person,
                                        size: 80,
                                        color: Colors.white,
                                      ),
                                    );
                                  },
                                ),
                              )
                            : Container(
                                padding: const EdgeInsets.all(24),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFAB4F41),
                                ),
                                child: const Icon(
                                  Icons.person,
                                  size: 80,
                                  color: Colors.white,
                                ),
                              ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 70),
            
            // Tampilkan nama dan email user dari Supabase
            FutureBuilder<Map<String, dynamic>?>(
              future: _getUserProfile(authService),
              builder: (context, snapshot) {
                final profile = snapshot.data;
                final name = profile?['full_name'] ?? authService.userEmail?.split('@')[0] ?? 'User';
                final email = authService.userEmail ?? 'No email';
                
                return Column(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 22,
                        color: Color(0xFF2C2C2C),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      email,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF7A7A7A),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildSettingItem(
                    icon: Icons.edit,
                    title: 'Edit Profile',
                    onTap: () => Get.toNamed(Routes.EDIT_PROFILE),
                  ),
                  _buildSettingItem(
                    icon: Icons.tune,
                    title: 'Application Preferences',
                    onTap: () => Get.to(() => const ApppreferencesView()),
                  ),
                  _buildSettingItem(
                    icon: Icons.lock,
                    title: 'Password and Security',
                    onTap: () => Get.to(() => const PasswordsecurityView()),
                  ),
                  _buildSettingItem(
                    icon: Icons.privacy_tip,
                    title: 'Private Notes Settings',
                    onTap: () => Get.to(() => const PrivatenotesView()),
                  ),
                  const SizedBox(height: 40),

                  // Tombol Sign Out dengan AuthService
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Get.defaultDialog(
                          title: 'Sign Out',
                          middleText: 'Are you sure you want to sign out?',
                          textConfirm: 'Yes',
                          textCancel: 'No',
                          confirmTextColor: Colors.white,
                          buttonColor: darkRed,
                          cancelTextColor: darkRed,
                          onConfirm: () {
                            // Logout menggunakan AuthService
                            authService.logout();
                          },
                        );
                      },
                      icon: const Icon(Icons.logout, color: Colors.white),
                      label: const Text('Sign Out'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: darkRed,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: const Color(0xFFAB4F41),
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF5D1F1E),
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                color: Color(0xFF5D1F1E), size: 18),
          ],
        ),
      ),
    );
  }
}