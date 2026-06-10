import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty_admin/modules/redeem/enter_manually_screen.dart';
import 'package:loyalty_admin/routes/app_routes.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:loyalty_admin/modules/ScanQr/scan_qr_controller.dart';

class ScanQrScreen extends StatefulWidget {
  const ScanQrScreen({super.key});

  @override
  State<ScanQrScreen> createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends State<ScanQrScreen> {
  // CONTROLLER

  //final scanQrController = Get.put(ScanQrController());
  final scanQrController = Get.find<ScanQrController>();

  // MOBILE SCANNER

  final MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    returnImage: false,
  );

  // STATES

  bool isProcessing = false;

  bool isNavigating = false;

  bool hasNavigated = false;

  bool _isCameraStarting = false;

  // QR DETECT

  Future<void> onDetect(BarcodeCapture capture) async {
    // HARD LOCK
    if (isProcessing || isNavigating || hasNavigated) {
      return;
    }

    final code = capture.barcodes.firstOrNull?.rawValue;

    if (code == null || code.isEmpty) {
      return;
    }

    isProcessing = true;

    try {
      // STOP CAMERA
      await controller.stop();

      final success = await scanQrController.handleQrCode(code);

      if (!mounted) return;

      if (success) {
        isNavigating = true;

        Get.toNamed(AppRoutes.enterManually);

        return;
      }

      isProcessing = false;

      if (mounted) {
        await _safeStartCamera();
      }
    } catch (e) {
      debugPrint("SCAN ERROR => $e");

      isProcessing = false;

      if (mounted) {
        await _safeStartCamera();
      }
    }
  }

  /// Safely restarts the camera, ignoring "still initializing" errors
  Future<void> _safeStartCamera() async {
    if (_isCameraStarting) return;
    _isCameraStarting = true;
    try {
      await controller.start();
    } catch (e) {
      debugPrint("Camera start skipped: \$e");
    } finally {
      _isCameraStarting = false;
    }
  }

  // DISPOSE

  @override
  void dispose() {
    isProcessing = false;
    isNavigating = false;

    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: Stack(
        children: [
          //----------------------------------
          // CAMERA
          //----------------------------------
          MobileScanner(
            controller: controller,

            fit: BoxFit.cover,

            onDetect: onDetect,
          ),

          //----------------------------------
          // DARK OVERLAY
          //----------------------------------
          Container(color: Colors.black.withOpacity(0.45)),

          //----------------------------------
          // TOP SECTION
          //----------------------------------
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      // if (Get.isOverlaysOpen) {
                      //   Get.back();
                      // } else {
                        Navigator.of(context).pop();
                      // }
                    },

                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),

                  const SizedBox(width: 10),

                  const Text(
                    "Scan QR Code",

                    style: TextStyle(
                      color: Colors.white,

                      fontSize: 24,

                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),

          //----------------------------------
          // CENTER SCANNER
          //----------------------------------
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Align QR code within the frame",

                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),

                const SizedBox(height: 25),

                //----------------------------------
                // QR FRAME
                //----------------------------------
                Container(
                  width: 250,
                  height: 250,

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),

                    border: Border.all(color: Colors.white.withOpacity(.3)),
                  ),

                  child: Stack(
                    children: [
                      //----------------------------------
                      // TOP LEFT
                      //----------------------------------
                      _corner(Alignment.topLeft),

                      //----------------------------------
                      // TOP RIGHT
                      //----------------------------------
                      _corner(Alignment.topRight),

                      //----------------------------------
                      // BOTTOM LEFT
                      //----------------------------------
                      _corner(Alignment.bottomLeft),

                      //----------------------------------
                      // BOTTOM RIGHT
                      //----------------------------------
                      _corner(Alignment.bottomRight),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                //----------------------------------
                // FLASH BUTTON
                //----------------------------------
                GestureDetector(
                  onTap: () async {
                    await controller.toggleTorch();
                  },

                  child: Container(
                    height: 70,
                    width: 70,

                    decoration: BoxDecoration(
                      color: Colors.black54,

                      shape: BoxShape.circle,

                      border: Border.all(color: Colors.white24),
                    ),

                    child: const Icon(
                      Icons.flash_on,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              ],
            ),
          ),

          //----------------------------------
          // BOTTOM SHEET
          //----------------------------------
          Align(
            alignment: Alignment.bottomCenter,

            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 34),

              decoration: const BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),

                  topRight: Radius.circular(28),
                ),
              ),

              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Having trouble scanning?",

                      style: TextStyle(color: Colors.black87, fontSize: 16),
                    ),

                    const SizedBox(height: 24),

                    //----------------------------------
                    // MANUAL BUTTON
                    //----------------------------------
                    SizedBox(
                      width: double.infinity,

                      height: 58,

                      child: ElevatedButton.icon(
                        onPressed: () async {
                          if (isNavigating) return;

                          isNavigating = true;

                          await controller.stop();

                          Get.toNamed(AppRoutes.enterManually);
                        },

                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffE91E63),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),

                        icon: const Icon(Icons.qr_code_2, color: Colors.white),

                        label: const Text(
                          "Enter Code Manually",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    //----------------------------------
                    // CANCEL BUTTON
                    //----------------------------------
                    SizedBox(
                      width: double.infinity,

                      height: 58,

                      child: OutlinedButton(
                        onPressed: () {
                          Get.back();
                        },

                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey.shade300),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),

                        child: const Text(
                          "Cancel and Return",

                          style: TextStyle(
                            color: Colors.black87,

                            fontSize: 18,

                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //----------------------------------
  // QR CORNER
  //----------------------------------

  Widget _corner(Alignment alignment) {
    return Align(
      alignment: alignment,

      child: Container(
        width: 42,
        height: 42,

        decoration: BoxDecoration(
          border: Border(
            top:
                alignment == Alignment.topLeft ||
                    alignment == Alignment.topRight
                ? const BorderSide(color: Color(0xffFF2D7A), width: 4)
                : BorderSide.none,

            left:
                alignment == Alignment.topLeft ||
                    alignment == Alignment.bottomLeft
                ? const BorderSide(color: Color(0xffFF2D7A), width: 4)
                : BorderSide.none,

            right:
                alignment == Alignment.topRight ||
                    alignment == Alignment.bottomRight
                ? const BorderSide(color: Color(0xffFF2D7A), width: 4)
                : BorderSide.none,

            bottom:
                alignment == Alignment.bottomLeft ||
                    alignment == Alignment.bottomRight
                ? const BorderSide(color: Color(0xffFF2D7A), width: 4)
                : BorderSide.none,
          ),

          borderRadius: BorderRadius.only(
            topLeft: alignment == Alignment.topLeft
                ? const Radius.circular(14)
                : Radius.zero,

            topRight: alignment == Alignment.topRight
                ? const Radius.circular(14)
                : Radius.zero,

            bottomLeft: alignment == Alignment.bottomLeft
                ? const Radius.circular(14)
                : Radius.zero,

            bottomRight: alignment == Alignment.bottomRight
                ? const Radius.circular(14)
                : Radius.zero,
          ),
        ),
      ),
    );
  }
}