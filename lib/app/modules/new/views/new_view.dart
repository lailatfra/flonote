import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewNoteController extends GetxController {
  var selectedFolder = 'Folder'.obs;
  var noteTitle = ''.obs;
  var noteContent = 'Tulis catatan disini....'.obs;
  var tags = <String>[].obs;
  var reminders = <String>['Pilih Nada Dering'].obs;
  var isPrivate = false.obs;
  var tagInput = ''.obs;

  void addTag(String tag) {
    if (tag.isNotEmpty && !tags.contains(tag)) {
      tags.add(tag);
    }
  }

  void removeTag(String tag) {
    tags.remove(tag);
  }

  void addReminder(String reminder) {
    if (reminders.first == 'Pilih Nada Dering') {
      reminders.clear();
    }
    reminders.add(reminder);
  }

  void togglePrivate() {
    isPrivate.value = !isPrivate.value;
  }
}

class NewView extends StatelessWidget {
  const NewView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NewNoteController());
    final tagController = TextEditingController();

    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 50,
              bottom: 25,
              left: 20,
              right: 20,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF5C2E2E),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  'New Notes',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Folder Dropdown
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF5C2E2E)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Obx(() => DropdownButton<String>(
                          value: controller.selectedFolder.value,
                          isExpanded: true,
                          underline: const SizedBox(),
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: ['Folder', 'Study', 'Work', 'Personal']
                              .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              controller.selectedFolder.value = newValue;
                            }
                          },
                        )),
                  ),
                  const SizedBox(height: 24),

                  // Note Title
                  const Text(
                    'Note Title',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF5C2E2E),
                    ),
                  ),
                  const Divider(
                    color: Color(0xFF5C2E2E),
                    thickness: 1,
                    height: 20,
                  ),

                  // Note Content
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Obx(() => Text(
                              controller.noteContent.value,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF999999),
                              ),
                            )),
                      ),
                      const Icon(
                        Icons.more_vert,
                        size: 20,
                        color: Color(0xFF5C2E2E),
                      ),
                    ],
                  ),
                  const SizedBox(height: 80),

                  const Divider(
                    color: Color(0xFF5C2E2E),
                    thickness: 1,
                  ),
                  const SizedBox(height: 20),

                  // Tags Section
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Tags',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF5C2E2E),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              if (tagController.text.isNotEmpty) {
                                controller.addTag(tagController.text);
                                tagController.clear();
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: Color(0xFF5C2E2E),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.add,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: tagController,
                          decoration: const InputDecoration(
                            hintText: 'Add Tags...',
                            hintStyle: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF999999),
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                      const Icon(
                        Icons.check_circle,
                        size: 20,
                        color: Color(0xFF5C2E2E),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Tags Display
                  Obx(() => Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: controller.tags.map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF9B6B6B),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  tag,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                GestureDetector(
                                  onTap: () => controller.removeTag(tag),
                                  child: const Icon(
                                    Icons.close,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      )),

                  // Default Tags
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildDefaultTag('Study'),
                      _buildDefaultTag('Bussiness'),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Reminder Section
                  Row(
                    children: [
                      const Icon(
                        Icons.notifications,
                        size: 20,
                        color: Color(0xFF5C2E2E),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Reminder',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF5C2E2E),
                        ),
                      ),
                      const Spacer(),
                      Expanded(
                        flex: 3,
                        child: Obx(() => DropdownButton<String>(
                              value: controller.reminders.first,
                              isExpanded: true,
                              underline: const SizedBox(),
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                size: 20,
                              ),
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF5C2E2E),
                              ),
                              items: [
                                'Pilih Nada Dering',
                                'Default',
                                'Ringtone 1',
                                'Ringtone 2'
                              ].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  controller.reminders[0] = newValue;
                                }
                              },
                            )),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Add New Reminder
                  Row(
                    children: [
                      const SizedBox(width: 28),
                      const Text(
                        'Add New Reminder',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF999999),
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => controller.addReminder('New Reminder'),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Color(0xFF5C2E2E),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Private Note
                  Row(
                    children: [
                      Obx(() => Icon(
                            controller.isPrivate.value
                                ? Icons.check_circle
                                : Icons.check_circle_outline,
                            size: 22,
                            color: const Color(0xFF2E7D32),
                          )),
                      const SizedBox(width: 8),
                      const Text(
                        'Pivate Note',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF5C2E2E),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // Save action
                        Get.snackbar(
                          'Success',
                          'Note saved successfully!',
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Cancel Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => Get.back(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD32F2F),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
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

  Widget _buildDefaultTag(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF9B6B6B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            tag,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 6),
          const Icon(
            Icons.close,
            size: 14,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}