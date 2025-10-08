import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:todo/core/controller/splash_controller.dart';

class Splash extends StatelessWidget {
  Splash({super.key});
  final ctrl = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    ctrl.startCountdown(step: const Duration(seconds: 1));
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Obx(
            () => Text(
              ctrl.isWelcomeShownValue ? 'Welcome' : ctrl.countValue.toString(),
              style: TextStyle(fontSize: 64),
            ),
          ),
        ),
      ),
    );
  }
}
