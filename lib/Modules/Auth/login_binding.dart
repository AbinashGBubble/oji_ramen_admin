import 'package:get/get.dart';
import 'package:loyalty_admin/Modules/Auth/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    print("🔥 LoginBinding executed!");
    Get.lazyPut<LoginController>(() => LoginController());
  }
}
