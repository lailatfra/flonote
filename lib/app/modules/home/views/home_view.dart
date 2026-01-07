import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Import AuthService
import 'package:flonote/app/services/auth_service.dart';

class NoteController extends GetxController {
  var selectedFilter = 'Semua'.obs;
  var sortBy = 'Terakhir Diubah'.obs;
}

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  // Function untuk load profile dari Supabase
  Future<Map<String, dynamic>?> _getUserProfile() async {
    try {
      final userId = Get.find<AuthService>().userId;
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
    final controller = Get.put(NoteController());
    final authService = Get.find<AuthService>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header dengan nama user dan avatar
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Nama user dari Supabase
                  FutureBuilder<Map<String, dynamic>?>(
                    future: _getUserProfile(),
                    builder: (context, snapshot) {
                      final profile = snapshot.data;
                      final name = profile?['full_name'] ?? 
                                  authService.userEmail?.split('@')[0] ?? 
                                  'User';
                      
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Good Day,',
                            style: TextStyle(
                              fontSize: 16,
                              color: const Color(0xFF5D1F1E).withOpacity(0.7),
                            ),
                          ),
                          Text(
                            '$name!',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF5D1F1E),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  
                  // Avatar user dari Supabase
                  FutureBuilder<Map<String, dynamic>?>(
                    future: _getUserProfile(),
                    builder: (context, snapshot) {
                      final avatarUrl = snapshot.data?['avatar_url'];
                      final hasAvatar = avatarUrl != null && avatarUrl.isNotEmpty;

                      return Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFF5D1F1E),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        child: hasAvatar
                            ? ClipOval(
                                child: Image.network(
                                  avatarUrl,
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 20,
                                    );
                                  },
                                ),
                              )
                            : const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 20,
                              ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Search Bar
              Row(
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4A5A5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.lock,
                      color: Color(0xFF5D1F1E),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: const Color(0xFF5D1F1E),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Row(
                        children: [
                          SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              style: TextStyle(color: Colors.white, fontSize: 13),
                              decoration: InputDecoration(
                                hintText: 'Search...',
                                hintStyle: TextStyle(color: Colors.white70, fontSize: 13),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Icon(Icons.search, color: Colors.white, size: 20),
                          SizedBox(width: 16),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Filter Buttons & Sort Dropdown
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Obx(() => _buildFilterButton(
                                'Semua',
                                controller.selectedFilter.value == 'Semua',
                                () => controller.selectedFilter.value = 'Semua',
                              )),
                          const SizedBox(width: 8),

                          Obx(() => _buildFilterButton(
                                'Belajar',
                                controller.selectedFilter.value == 'Belajar',
                                () => controller.selectedFilter.value = 'Belajar',
                              )),
                          const SizedBox(width: 8),

                          Obx(() => _buildFilterButton(
                                'Kerja',
                                controller.selectedFilter.value == 'Kerja',
                                () => controller.selectedFilter.value = 'Kerja',
                              )),
                          const SizedBox(width: 8),

                          _buildAddFolderButton(),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.015),

                  // Sort Dropdown (posisi di kanan)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF5D1F1E),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Obx(() => DropdownButton<String>(
                            value: controller.sortBy.value,
                            icon: const Icon(Icons.keyboard_arrow_down,
                                color: Colors.white, size: 16),
                            dropdownColor: const Color(0xFF5D1F1E),
                            underline: const SizedBox(),
                            isDense: true,
                            style: const TextStyle(color: Colors.white, fontSize: 11),
                            items: ['Terakhir Diubah', 'Terbaru', 'Terlama']
                                .map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              if (newValue != null) {
                                controller.sortBy.value = newValue;
                              }
                            },
                          )),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Notes Grid (2 columns, setengah layar per card)
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.72,
                  children: [
                    _buildNoteCard(
                      date: '20 Nov 2025',
                      title: 'Contoh Note',
                      tags: ['Study', 'Productivity'],
                      tasks: [
                        'Ngerjain mapel produktif',
                        'Matematika',
                        'Baca 10 halaman l8...',
                      ],
                      hasImage: true,
                    ),
                    _buildNoteCard(
                      date: '20 Nov 2025',
                      title: 'Programming',
                      tags: ['Study', 'Programming'],
                      description:
                          'Normalization is the process of ordering basic data structures to ensure that the basic data created is of good quality. Used to minimize data redun.....',
                      hasAudio: true,
                    ),
                    _buildNoteCard(
                      date: '20 Nov 2025',
                      title: 'Bussines Plan',
                      tags: ['Study', 'Bussines'],
                      description:
                          'CrunchyBite is the name of our business plan.',
                    ),
                    _buildNoteCard(
                      date: '20 Nov 2025',
                      title: 'Programming',
                      tags: ['Study', 'Programming'],
                      description:
                          'Normalization is the process of ordering basic data structures to ensure that the basic data created is of good quality. Used to minimize data redun.....',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF5D1F1E) : Colors.transparent,
          border: Border.all(
            color: const Color(0xFF5D1F1E),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF5D1F1E),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildAddFolderButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: const Color(0xFF5D1F1E),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.add, color: Color(0xFF5C2E2E), size: 16),
          SizedBox(width: 4),
          Text(
            'New Folder',
            style: TextStyle(
              color: Color(0xFF5D1F1E),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteCard({
    required String date,
    required String title,
    required List<String> tags,
    List<String>? tasks,
    String? description,
    bool hasImage = false,
    bool hasAudio = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFD4A5A5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasImage)
            Container(
              width: double.infinity,
              height: 100,
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: const DecorationImage(
                  image: NetworkImage(
                      'https://images.unsplash.com/photo-1466692476868-aef1dfb1e735?w=400'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    date,
                    style: const TextStyle(
                      fontSize: 9,
                      color: Color(0xFF5C2E2E),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5C2E2E),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 4,
                    runSpacing: 3,
                    children: tags
                        .map((tag) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFF9B6B6B),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                tag,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (tasks != null)
                            ...tasks.map((task) => Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        task.contains('Matematika')
                                            ? Icons.check_box
                                            : Icons.check_box_outline_blank,
                                        size: 14,
                                        color: task.contains('Matematika')
                                            ? Colors.green
                                            : const Color(0xFF5C2E2E),
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          task,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: Color(0xFF5C2E2E),
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          if (description != null)
                            Text(
                              description,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF5C2E2E),
                                height: 1.3,
                              ),
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                  ),
                  if (hasAudio)
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF5C2E2E),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.mic, color: Colors.white, size: 16),
                          const SizedBox(width: 6),
                          Expanded(
                            child: SizedBox(
                              height: 20,
                              child: CustomPaint(
                                painter: WaveformPainter(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WaveformPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final heights = [6, 12, 8, 16, 10, 14, 6, 13, 11, 16, 8, 12, 9];
    final spacing = size.width / heights.length;

    for (int i = 0; i < heights.length; i++) {
      final x = i * spacing;
      final height = heights[i].toDouble();
      canvas.drawLine(
        Offset(x, size.height / 2 - height / 2),
        Offset(x, size.height / 2 + height / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}