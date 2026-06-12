import 'package:get/get.dart';
import 'package:loyalty_admin/modules/Auth/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<LoginController>(LoginController());
  }
}
