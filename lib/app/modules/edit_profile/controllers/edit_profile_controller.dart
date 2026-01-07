import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'dart:io';

class EditProfileController extends GetxController {
  final supabase = Supabase.instance.client;
  final imagePicker = ImagePicker();

  final nameController = TextEditingController();
  final selectedBirthday = Rxn<DateTime>();

  final avatarUrl = RxnString();
  final isLoading = false.obs;
  final isSaving = false.obs;
  final isUploadingImage = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  // =====================================================
  // =============== LOAD PROFILE =========================
  // =====================================================
  Future<void> loadProfile() async {
    try {
      isLoading.value = true;
      print("Loading profile...");

      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        Get.snackbar("Error", "User tidak login", 
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      final response = await supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();

      print("Profile data: $response");

      if (response != null) {
        nameController.text = response['full_name'] ?? '';
        
        // FIX: Handle birthday format
        if (response['birthday'] != null) {
          if (response['birthday'] is String) {
            selectedBirthday.value = DateTime.parse(response['birthday']);
          } else {
            // Jika sudah dalam format DateTime
            selectedBirthday.value = response['birthday'].toDate();
          }
        }

        avatarUrl.value = response['avatar_url'];
        print("Avatar URL: ${avatarUrl.value}");
      } else {
        // Jika profile belum ada
        final email = supabase.auth.currentUser?.email ?? '';
        nameController.text = email.split('@')[0];
        print("Profile baru dibuat dengan email: $email");
      }
    } catch (e) {
      print("Error load profile: $e");
      Get.snackbar("Error", "Gagal memuat profil: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // =====================================================
  // =============== SELECT BIRTHDAY ======================
  // =====================================================
  Future<void> selectBirthday(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedBirthday.value ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      selectedBirthday.value = picked;
      print("Birthday selected: $picked");
    }
  }

  String get birthdayText {
    if (selectedBirthday.value == null) return "Pilih tanggal lahir";
    return DateFormat("dd-MMM-yyyy").format(selectedBirthday.value!);
  }

  // =====================================================
  // =============== UPLOAD AVATAR ========================
  // =====================================================
Future<void> pickAndUploadImage() async {
  try {
    isUploadingImage.value = true;
    print("🔄 Memulai proses upload...");

    final user = supabase.auth.currentUser;
    if (user == null) throw "User belum login";

    // PILIH GAMBAR
    final XFile? imageFile = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 800,
    );

    if (imageFile == null) {
      isUploadingImage.value = false;
      return;
    }

    print("📁 File dipilih: ${imageFile.name}");

    final bytes = await imageFile.readAsBytes();
    final String fileName =
        "${user.id}/${DateTime.now().millisecondsSinceEpoch}.png";

    print("📤 Uploading file: $fileName");

    // HAPUS GAMBAR LAMA (opsional)
    if (avatarUrl.value != null && avatarUrl.value!.isNotEmpty) {
      try {
        final oldPath = avatarUrl.value!.split("/avatars/").last;
        await supabase.storage.from('avatars').remove([oldPath]);
      } catch (_) {}
    }

    // UPLOAD LANJUTAN
    final uploadResponse = await supabase.storage
        .from('avatars')
        .uploadBinary(fileName, bytes);

    print("📥 Upload result: $uploadResponse");

    // DAPATKAN URL PUBLIC
    final publicUrl =
        supabase.storage.from('avatars').getPublicUrl(fileName);

    print("🌐 Public URL: $publicUrl");

    // UPDATE DATABASE
    await supabase.from('profiles').upsert({
      'id': user.id,
      'avatar_url': publicUrl,
      'updated_at': DateTime.now().toIso8601String(),
    });

    // UPDATE UI (dengan anti cache)
    avatarUrl.value =
        "$publicUrl?ts=${DateTime.now().millisecondsSinceEpoch}";

    update();

    Get.snackbar(
      "Berhasil!",
      "Foto profil berhasil diperbarui",
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  } catch (e) {
    print("❌ ERROR UPLOAD: $e");
    Get.snackbar(
      "Upload Error",
      e.toString(),
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  } finally {
    isUploadingImage.value = false;
  }
}



  // =====================================================
  // ================= SAVE PROFILE =======================
  // =====================================================
  Future<void> saveProfile() async {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar("Error", "Nama tidak boleh kosong",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      isSaving.value = true;
      print("Menyimpan profile...");

      final userId = supabase.auth.currentUser?.id;
      if (userId == null) throw "User tidak login";

      // FIX: Format data dengan benar
      final data = {
        'id': userId,
        'full_name': nameController.text.trim(),
        'birthday': selectedBirthday.value?.toIso8601String(),
        'avatar_url': avatarUrl.value,
        'updated_at': DateTime.now().toIso8601String(),
      };

      print("Data to save: $data");

      final result = await supabase
          .from('profiles')
          .upsert(data)
          .select();

      print("Save result: $result");

      Get.snackbar("Berhasil", "Profil berhasil disimpan!",
          backgroundColor: Colors.green, colorText: Colors.white,
          duration: Duration(seconds: 2));

      await Future.delayed(Duration(milliseconds: 500));
      Get.back(result: true);

    } catch (e) {
      print("ERROR SAVE: $e");
      Get.snackbar("Error", "Gagal menyimpan: $e",
          backgroundColor: Colors.red, colorText: Colors.white,
          duration: Duration(seconds: 3));
    } finally {
      isSaving.value = false;
    }
  }

  // =====================================================
  // ================= CANCEL EDIT ========================
  // =====================================================
  void cancelEdit() {
    Get.back();
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }
}