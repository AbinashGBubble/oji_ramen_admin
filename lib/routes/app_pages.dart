import 'package:get/get.dart';
import 'package:loyalty_admin/Modules/Auth/login_binding.dart';

// Import screens + bindings
import 'package:loyalty_admin/Modules/Auth/login_view.dart';
import 'package:loyalty_admin/Modules/Dashboard/common_bottom_bar.dart';
import 'package:loyalty_admin/Modules/ScanQr/earn_redeem_binding.dart';
import 'package:loyalty_admin/Modules/ScanQr/earn_redeem_screen.dart';
import 'package:loyalty_admin/Modules/ScanQr/qr_scanner_binding.dart';
import 'package:loyalty_admin/Modules/ScanQr/qr_screen.dart';
import 'package:loyalty_admin/routes/app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.login,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),

    GetPage(
      name: AppRoutes.home,
      page: () => CommonBottomBar(),
      //binding: LoginBinding(),
    ),

    GetPage(
      name: AppRoutes.scanQr,
      page: () => ScanQrScreen(),
      binding: QrScannerBinding(),
    ),
  ];
}
