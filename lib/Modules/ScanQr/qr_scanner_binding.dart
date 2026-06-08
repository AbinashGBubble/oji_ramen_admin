import 'package:get/get.dart';
import 'package:loyalty_admin/Modules/ScanQr/scan_qr_controller.dart';

class QrScannerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScanQrController>(() => ScanQrController());
  }
}
