# FloNote – Aplikasi Catatan Flutter (GetX)

## Deskripsi

FloNote adalah aplikasi catatan berbasis Flutter yang dibangun menggunakan GetX dengan struktur modular. Aplikasi ini memiliki fitur autentikasi, pengelolaan catatan, pengaturan akun, serta navigasi berbasis route GetX.

Struktur kode dipisahkan antara view, controller, dan binding agar mudah dipahami dan dikembangkan.


## Teknologi

- Flutter
- Dart
- GetX (State Management, Routing, Dependency Injection)


## Struktur Folder

lib/
├── main.dart
└── app/
    ├── data/
    ├── modules/
    │   ├── login/
    │   ├── register/
    │   ├── home/
    │   ├── note/
    │   ├── privatenotes/
    │   ├── setting/
    │   ├── edit_profile/
    │   ├── passwordsecurity/
    │   ├── splash/
    │   └── welcome/
    │       (setiap module berisi bindings, controllers, dan views)
    ├── routes/
    │   ├── app_pages.dart
    │   └── app_routes.dart
    └── services/
        └── auth_service.dart


## Cara Kerja Kode

### 1. main.dart
`main.dart` adalah entry point aplikasi. File ini menjalankan aplikasi utama dan menghubungkan routing GetX (`GetMaterialApp`) dengan daftar halaman di `app_pages.dart`.


### 2. Modular GetX (modules)
Setiap fitur dibuat dalam satu module terpisah yang terdiri dari:
- **bindings** → mendaftarkan controller ke GetX
- **controllers** → menangani logika dan state
- **views** → tampilan UI
Contoh: module `note`
- `note_controller.dart` mengelola data dan aksi catatan
- `note_view.dart` menampilkan daftar atau isi catatan
- `note_binding.dart` menghubungkan controller ke view


### 3. Controller
Controller bertanggung jawab atas:
- Mengelola state
- Menangani input user
- Menjalankan logika aplikasi
UI tidak langsung mengolah data, tetapi melalui controller.


### 4. Routing
Routing dikelola di folder `routes`:
- `app_routes.dart` berisi nama route
- `app_pages.dart` berisi mapping route ke halaman dan binding
Navigasi antar halaman menggunakan GetX tanpa `Navigator.push`.


### 5. Service
`auth_service.dart` digunakan untuk menangani proses autentikasi dan logika terkait user, agar tidak bercampur dengan UI.


## Alur Aplikasi Singkat

Splash → Welcome → Login/Register → Home → Add Note / Setting

## Tujuan

- Menerapkan arsitektur GetX modular
- Melatih pemisahan UI dan logika
- Membuat aplikasi Flutter yang terstruktur
- Digunakan sebagai portofolio seleksi PKL
