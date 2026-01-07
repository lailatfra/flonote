import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    const Color darkRed = Color(0xFF5D1F1E);
    const Color softRed = Color(0xFFAB4F41);
    const Color whiteBg = Color(0xFFF3F3F3);

    return Scaffold(
      backgroundColor: whiteBg,
      appBar: AppBar(
        backgroundColor: darkRed,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF5D1F1E),
            ),
          );
        }

        return SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                children: [
                  // Header dengan foto profil
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
                        child: Obx(() {
                          final hasAvatar =
                              controller.avatarUrl.value != null &&
                                  controller.avatarUrl.value!.isNotEmpty;

                          print(
                              "🔄 Building avatar widget, URL: ${controller.avatarUrl.value}");

                          return Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(color: whiteBg, width: 8),
                            ),
                            child: hasAvatar
                                ? ClipOval(
                                    child: Image.network(
                                      '${controller.avatarUrl.value}?v=${DateTime.now().millisecondsSinceEpoch}',
                                      width: 140,
                                      height: 140,
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Container(
                                          width: 140,
                                          height: 140,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: softRed,
                                          ),
                                          child: const Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                            ),
                                          ),
                                        );
                                      },
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        print("❌ Error loading avatar: $error");
                                        return _buildDefaultAvatar();
                                      },
                                    ),
                                  )
                                : _buildDefaultAvatar(),
                          );
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 70),

                  // Tampilkan nama
                  Text(
                    controller.nameController.text.isEmpty
                        ? 'Your Name'
                        : controller.nameController.text,
                    style: const TextStyle(
                      fontSize: 22,
                      color: Color(0xFF2C2C2C),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Form fields
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name Field
                        const Text(
                          'Full Name',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: controller.nameController,
                          decoration: InputDecoration(
                            hintText: 'Enter your full name',
                            filled: true,
                            fillColor: const Color(0xFFE6C8C0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),

                        // Birthday Field (Date Picker)
                        const Text(
                          'Birthday',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Obx(() => InkWell(
                              onTap: () => controller.selectBirthday(context),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE6C8C0),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_today,
                                      color: Color(0xFF5D1F1E),
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        controller.birthdayText,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: controller
                                                      .selectedBirthday.value ==
                                                  null
                                              ? Colors.grey.shade600
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                    const Icon(
                                      Icons.arrow_drop_down,
                                      color: Color(0xFF5D1F1E),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                        const SizedBox(height: 28),

                        // Tombol Save
                        Obx(() => SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: controller.isSaving.value
                                    ? null
                                    : controller.saveProfile,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF5D1F1E),
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                child: controller.isSaving.value
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text('Save'),
                              ),
                            )),
                        const SizedBox(height: 14),

                        // Tombol Cancel
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: controller.cancelEdit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 158, 46, 44),
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
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ],
              ),

              // ⚡ TOMBOL KAMERA DI POJOK KANAN BAWAH FOTO PROFIL - LEBIH KE BAWAH
              Positioned(
                top: 120 + 10, // Header height + sedikit ke bawah
                left: MediaQuery.of(context).size.width / 2 + 40,
                child: Obx(() {
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: controller.isUploadingImage.value
                          ? null
                          : () {
                              print('Camera button clicked!');
                              controller.pickAndUploadImage();
                            },
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: darkRed,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: controller.isUploadingImage.value
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20,
                              ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      width: 140,
      height: 140,
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
  }
}