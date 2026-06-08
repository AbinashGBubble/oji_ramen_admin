import 'package:get/get.dart';
import 'package:loyalty_admin/Modules/ScanQr/scan_qr_controller.dart';

class EnterManuallyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScanQrController>(() => ScanQrController(), fenix: true);
  }
}