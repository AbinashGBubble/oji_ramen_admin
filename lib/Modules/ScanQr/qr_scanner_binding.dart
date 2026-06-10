import 'package:get/get.dart';
import 'package:loyalty_admin/modules/ScanQr/scan_qr_controller.dart';

class QrScannerBinding extends Bindings {
  @override
  void dependencies() {
     Get.lazyPut<ScanQrController>(() => ScanQrController(), fenix: true);
  }
}
