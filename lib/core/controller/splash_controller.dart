import 'dart:async';

import 'package:get/get.dart';
import 'package:todo/ui/screens/home.dart';

class SplashController extends GetxController {
  // private reactive state
  final RxInt _count = 3.obs;
  final RxBool _isWelcomeShown = false.obs;

  // expose as Rx so UI can use Obx/GetX, and also helper value getters
  RxInt get count => _count;
  int get countValue => _count.value;

  RxBool get isWelcomeShown => _isWelcomeShown;
  bool get isWelcomeShownValue => _isWelcomeShown.value;

  Timer? _timer;

  /// call this to start countdown (e.g. from onInit or from the view)
  void startCountdown({Duration step = const Duration(milliseconds: 750)}) {
    // cancel previous timer if any
    _timer?.cancel();

    _timer = Timer.periodic(step, (timer) async {
      if (_count.value > 0) {
        _count.value -= 1;
      }

      if (_count.value <= 0) {
        timer.cancel();
        _isWelcomeShown.value = true;

        // navigate to Home (replace current route)
        // Use Get.offNamed if you prefer named routes
        await Future.delayed(const Duration(milliseconds: 1000));
        Get.off(() => Home());
      }
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
