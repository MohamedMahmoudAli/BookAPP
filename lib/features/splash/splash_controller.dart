import 'package:book_app/core/constants/storage_keys.dart';
import 'package:book_app/core/widgets/main_bottom_nav_bar.dart';
import 'package:book_app/features/home/home_view.dart';
import 'package:book_app/features/login/login_view.dart';
import 'package:book_app/features/welcome/welcome_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

///
/// Called when the object is initialized.
///
/// Waits for 2 seconds and then navigates to the WelcomePage.
///
/// @override
class SplashController extends GetxController {
  final GetStorage _box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    _navigate();
  }

  void _navigate() async {
    await Future.delayed(const Duration(seconds: 2));

    final bool isFirstLaunch = _box.read(StorageKeys.isFirstLaunch) ?? true;

    final bool isLoggedIn = _box.read(StorageKeys.isLoggedIn) ?? false;

    if (isFirstLaunch) {
      _box.write(StorageKeys.isFirstLaunch, false);
      Get.offAll(() => const WelcomePage());
      return;
    }

    if (isLoggedIn) {
      Get.offAll(() => ModernBottomNavBar());
    } else {
      Get.offAll(() => const LoginView());
    }
  }
}
