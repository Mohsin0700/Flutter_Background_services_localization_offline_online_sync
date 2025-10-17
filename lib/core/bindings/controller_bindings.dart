import 'package:get/get.dart';
import 'package:todo/core/controller/home_controller.dart';
import 'package:todo/core/controller/splash_controller.dart';

class InitialBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(SplashController());
    Get.put(HomeController());
  }
}
