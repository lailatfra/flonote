import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/routes/app_pages.dart';
import 'app/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'https://ceahuxrdmjrvishobleb.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNlYWh1eHJkbWpydmlzaG9ibGViIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQyNzEzNTMsImV4cCI6MjA3OTg0NzM1M30.rnJQvMoOosY1ga7GFESIXYoR5iABx-JSSaHAUZWTOwQ',
  );
  
  await Get.putAsync(() => AuthService().init());

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Flonote",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}

// Helper untuk akses Supabase client
final supabase = Supabase.instance.client;