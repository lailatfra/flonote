import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(const NoteView());
}

class NoteView extends StatelessWidget {
  const NoteView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

// Model untuk Note
class Note {
  String id;
  String title;
  String content;
  String folderId;
  List<String> tags;
  List<String> images;
  List<TodoItem> todoList;
  String? reminder;
  bool isPinned;
  bool isPrivate;
  DateTime createdAt;
  DateTime updatedAt;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.folderId,
    required this.tags,
    required this.images,
    required this.todoList,
    this.reminder,
    this.isPinned = false,
    this.isPrivate = false,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'folderId': folderId,
        'tags': tags,
        'images': images,
        'todoList': todoList.map((e) => e.toJson()).toList(),
        'reminder': reminder,
        'isPinned': isPinned,
        'isPrivate': isPrivate,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json['id'],
        title: json['title'],
        content: json['content'],
        folderId: json['folderId'],
        tags: List<String>.from(json['tags']),
        images: List<String>.from(json['images']),
        todoList: (json['todoList'] as List).map((e) => TodoItem.fromJson(e)).toList(),
        reminder: json['reminder'],
        isPinned: json['isPinned'] ?? false,
        isPrivate: json['isPrivate'] ?? false,
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );
}

class TodoItem {
  String id;
  String text;
  bool isCompleted;

  TodoItem({
    required this.id,
    required this.text,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'isCompleted': isCompleted,
      };

  factory TodoItem.fromJson(Map<String, dynamic> json) => TodoItem(
        id: json['id'],
        text: json['text'],
        isCompleted: json['isCompleted'] ?? false,
      );
}

// Model untuk Folder
class NoteFolder {
  String id;
  String name;
  Color color;
  IconData icon;

  NoteFolder({
    required this.id,
    required this.name,
    required this.color,
    required this.icon,
  });
}

// HomePage - Halaman Utama
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Note> notes = [];
  List<NoteFolder> folders = [
    NoteFolder(id: '1', name: 'Personal', color: Colors.blue, icon: Icons.home),
    NoteFolder(id: '2', name: 'Work', color: Colors.purple, icon: Icons.work),
    NoteFolder(id: '3', name: 'Ideas', color: Colors.orange, icon: Icons.lightbulb),
  ];

  String? selectedFolderId;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  Future<void> loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notesJson = prefs.getString('notes');
    if (notesJson != null) {
      final List<dynamic> decoded = json.decode(notesJson);
      setState(() {
        notes = decoded.map((e) => Note.fromJson(e)).toList();
      });
    }
  }

  Future<void> saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notesJson = json.encode(notes.map((e) => e.toJson()).toList());
    await prefs.setString('notes', notesJson);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color(0xFF6B3838),
        elevation: 0,
        title: const Text('My Notes', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          // Search and Filter
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  onChanged: (value) => setState(() => searchQuery = value),
                  decoration: InputDecoration(
                    hintText: 'Cari catatan...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      FilterChip(
                        label: const Text('Semua'),
                        selected: selectedFolderId == null,
                        onSelected: (selected) => setState(() => selectedFolderId = null),
                      ),
                      const SizedBox(width: 8),
                      ...folders.map((folder) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              avatar: Icon(folder.icon, size: 18),
                              label: Text(folder.name),
                              selected: selectedFolderId == folder.id,
                              onSelected: (selected) =>
                                  setState(() => selectedFolderId = selected ? folder.id : null),
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Notes List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(note.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(note.content, maxLines: 2, overflow: TextOverflow.ellipsis),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddNotePage(folders: folders, editNote: note),
                        ),
                      );
                      if (result != null) {
                        setState(() {
                          final idx = notes.indexWhere((n) => n.id == note.id);
                          notes[idx] = result;
                        });
                        saveNotes();
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNotePage(folders: folders)),
          );
          if (result != null) {
            setState(() => notes.add(result));
            saveNotes();
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('New Note'),
        backgroundColor: const Color(0xFF4A7C4E),
      ),
    );
  }
}

// AddNotePage - Halaman Tambah/Edit Catatan
class AddNotePage extends StatefulWidget {
  final List<NoteFolder> folders;
  final Note? editNote;

  const AddNotePage({Key? key, required this.folders, this.editNote}) : super(key: key);

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _tagController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  String selectedFolderId = '1';
  List<String> tags = [];
  List<String> images = [];
  List<TodoItem> todoList = [];
  String? reminder;
  bool isPrivate = false;
  List<TextEditingController> contentControllers = [];

  @override
  void initState() {
    super.initState();
    contentControllers.add(_contentController);
    if (widget.editNote != null) {
      _titleController.text = widget.editNote!.title;
      _contentController.text = widget.editNote!.content;
      selectedFolderId = widget.editNote!.folderId;
      tags = List.from(widget.editNote!.tags);
      images = List.from(widget.editNote!.images);
      todoList = List.from(widget.editNote!.todoList);
      reminder = widget.editNote!.reminder;
      isPrivate = widget.editNote!.isPrivate;
    }
  }

  void _showInsertMenu(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.image, color: Colors.blue),
              title: const Text('Picture'),
              onTap: () async {
                Navigator.pop(context);
                final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  setState(() => images.add(image.path));
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.mic, color: Colors.red),
              title: const Text('Record/Audio'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fitur rekaman akan datang')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.check_box, color: Colors.green),
              title: const Text('To-Do List'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  todoList.add(TodoItem(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    text: '',
                  ));
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _addContentLine() {
    setState(() {
      contentControllers.add(TextEditingController());
    });
  }

  void saveNote() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Judul tidak boleh kosong')),
      );
      return;
    }

    final note = Note(
      id: widget.editNote?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      content: contentControllers.map((c) => c.text).join('\n'),
      folderId: selectedFolderId,
      tags: tags,
      images: images,
      todoList: todoList,
      reminder: reminder,
      isPinned: false,
      isPrivate: isPrivate,
      createdAt: widget.editNote?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    Navigator.pop(context, note);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF6B3838),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('New Notes', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Folder Dropdown
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[400]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedFolderId,
                    isExpanded: true,
                    hint: const Text('Folder'),
                    items: widget.folders.map((folder) {
                      return DropdownMenuItem(
                        value: folder.id,
                        child: Text(folder.name),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => selectedFolderId = value!),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Title
              TextField(
                controller: _titleController,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  hintText: 'Note Title',
                  border: InputBorder.none,
                ),
              ),

              const SizedBox(height: 16),

              // Content with three dots menu
              const Text(
                'Ini contoh catatan, berikut ini gambar ,mx:',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),

              const SizedBox(height: 12),

              // Images Display
              if (images.isNotEmpty) ...[
                SizedBox(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 150,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey[200],
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                'assets/sample_image.png',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.image, size: 50, color: Colors.grey);
                                },
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: GestureDetector(
                                onTap: () => setState(() => images.removeAt(index)),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.close, size: 16, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Content lines with menu
              ...List.generate(contentControllers.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: contentControllers[index],
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Tulis disini...',
                          ),
                          maxLines: null,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_vert, size: 20),
                        onPressed: () => _showInsertMenu(context, index),
                      ),
                    ],
                  ),
                );
              }),

              // Add new line button
              TextButton.icon(
                onPressed: _addContentLine,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Tambah baris'),
                style: TextButton.styleFrom(foregroundColor: Colors.grey),
              ),

              const SizedBox(height: 16),

              // To-Do List
              if (todoList.isNotEmpty) ...[
                const Text(
                  'To-Do List',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...todoList.map((todo) {
                  return Row(
                    children: [
                      Checkbox(
                        value: todo.isCompleted,
                        onChanged: (value) {
                          setState(() => todo.isCompleted = value ?? false);
                        },
                      ),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Todo item...',
                          ),
                          onChanged: (value) => todo.text = value,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => setState(() => todoList.remove(todo)),
                      ),
                    ],
                  );
                }).toList(),
                const SizedBox(height: 16),
              ],

              const Divider(),

              // Tags Section
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text('Tags', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFF6B3838),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, size: 16, color: Colors.white),
                  ),
                  const Spacer(),
                  const Text('Add Tags...', style: TextStyle(color: Colors.grey)),
                ],
              ),

              const SizedBox(height: 12),

              // Display Tags
              if (tags.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: tags.map((tag) {
                    return Chip(
                      label: Text(tag),
                      deleteIcon: const Icon(Icons.close, size: 16),
                      onDeleted: () => setState(() => tags.remove(tag)),
                      backgroundColor: Colors.grey[200],
                    );
                  }).toList(),
                ),

              // Add Tag TextField
              TextField(
                controller: _tagController,
                decoration: InputDecoration(
                  hintText: 'Tambah tag...',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      if (_tagController.text.isNotEmpty) {
                        setState(() {
                          tags.add(_tagController.text);
                          _tagController.clear();
                        });
                      }
                    },
                  ),
                ),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    setState(() {
                      tags.add(value);
                      _tagController.clear();
                    });
                  }
                },
              ),

              const SizedBox(height: 24),

              // Reminder Section
              Row(
                children: [
                  const Text('Reminder', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  const Icon(Icons.notifications, color: Colors.red, size: 20),
                  const Spacer(),
                  TextButton(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null) {
                        setState(() {
                          reminder = '${date.day} ${_getMonthName(date.month)} ${date.year}';
                        });
                      }
                    },
                    child: const Text('Tambahkan Pengingat', style: TextStyle(color: Colors.black)),
                  ),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFF6B3838),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, size: 16, color: Colors.white),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Display Reminders
              if (reminder != null) ...[
                Text('28 November 2025', style: TextStyle(color: Colors.grey[700])),
                const SizedBox(height: 4),
                Text('27 November 2025', style: TextStyle(color: Colors.grey[700])),
                const SizedBox(height: 16),
              ],

              const Divider(),

              // Private Note Checkbox
              Row(
                children: [
                  Checkbox(
                    value: isPrivate,
                    onChanged: (value) => setState(() => isPrivate = value ?? false),
                    activeColor: const Color(0xFF4A7C4E),
                  ),
                  const Text('Private Note', style: TextStyle(fontWeight: FontWeight.w500)),
                ],
              ),

              const SizedBox(height: 24),

              // Action Buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: saveNote,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A7C4E),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Save', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF6B3838)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Cancel', style: TextStyle(fontSize: 16, color: Color(0xFF6B3838))),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    return months[month - 1];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _tagController.dispose();
    for (var controller in contentControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}