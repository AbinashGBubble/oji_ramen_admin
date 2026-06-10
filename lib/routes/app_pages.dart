import 'package:get/get.dart';
import 'package:loyalty_admin/modules/Auth/login_binding.dart';
import 'package:loyalty_admin/modules/Auth/login_view.dart';
import 'package:loyalty_admin/modules/Dashboard/common_bottom_bar.dart';
import 'package:loyalty_admin/modules/ScanQr/qr_scanner_binding.dart';
import 'package:loyalty_admin/modules/ScanQr/qr_screen.dart';
import 'package:loyalty_admin/modules/redeem/enter_manually_binding.dart';
import 'package:loyalty_admin/modules/redeem/enter_manually_screen.dart';
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
      page: () => const CommonBottomBar(),
    ),

    GetPage(
      name: AppRoutes.scanQr,
      page: () => const ScanQrScreen(),
      binding: QrScannerBinding(),
    ),

    GetPage(
      name: AppRoutes.enterManually,
      page: () => const EnterCodeManuallyScreen(),
      binding: EnterManuallyBinding(),
    ),
  ];
}