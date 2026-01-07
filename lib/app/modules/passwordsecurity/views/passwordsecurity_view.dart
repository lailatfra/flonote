import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/passwordsecurity_controller.dart';

class PasswordsecurityView extends GetView<PasswordsecurityController> {
  const PasswordsecurityView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PasswordsecurityView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'PasswordsecurityView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
