import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/privatenotes_controller.dart';

class PrivatenotesView extends GetView<PrivatenotesController> {
  const PrivatenotesView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PrivatenotesView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'PrivatenotesView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
