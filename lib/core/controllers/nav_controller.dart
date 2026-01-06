
import 'package:book_app/features/login/login_controller.dart';
import 'package:get/get.dart';

class NavController extends GetxController {
  final RxInt selectedIndex = 0.obs;

  void changeIndex(int index) {
    selectedIndex.value = index;
  }
}



class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NavController(), permanent: true);
    Get.put(LoginController(), permanent: true);
  }
}
