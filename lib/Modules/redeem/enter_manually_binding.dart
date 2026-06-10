import 'package:get/get.dart';
import 'package:loyalty_admin/modules/ScanQr/scan_qr_controller.dart';

class EnterManuallyBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ScanQrController>()) {
      Get.lazyPut<ScanQrController>(() => ScanQrController(), fenix: true);
    }
  }
}