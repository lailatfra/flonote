import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/apppreferences_controller.dart';

class ApppreferencesView extends GetView<ApppreferencesController> {
  const ApppreferencesView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ApppreferencesView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ApppreferencesView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
