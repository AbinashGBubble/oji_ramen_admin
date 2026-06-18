import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty_admin/routes/app_routes.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:loyalty_admin/modules/ScanQr/scan_qr_controller.dart';

class ScanQrScreen extends StatefulWidget {
  const ScanQrScreen({super.key});

  @override
  State<ScanQrScreen> createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends State<ScanQrScreen>
    with WidgetsBindingObserver {
  final scanQrController = Get.find<ScanQrController>();

  final bool _isSimulator =
      Platform.isIOS &&
      const bool.fromEnvironment('dart.vm.product') == false &&
      _isIOSSimulator();

  MobileScannerController? _cameraController;

  bool isProcessing = false;
  bool isNavigating = false;
  bool _isCameraStarting = false;

  // ── detect iOS simulator via SIMULATOR_DEVICE_NAME env ──
  static bool _isIOSSimulator() {
    try {
      return Platform.environment.containsKey('SIMULATOR_DEVICE_NAME');
    } catch (_) {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    if (!_isSimulator) {
      _cameraController = MobileScannerController(
        detectionSpeed: DetectionSpeed.noDuplicates,
        returnImage: false,
      );
    }
  }

  // ── QR detect ──
  Future<void> _onDetect(BarcodeCapture capture) async {
    if (isProcessing || isNavigating) return;

    final code = capture.barcodes.firstOrNull?.rawValue;
    if (code == null || code.isEmpty) return;

    isProcessing = true;

    // ✅ Stop camera FIRST before any async work
    await _cameraController?.stop();

    try {
      final success = await scanQrController.handleQrCode(code);

      if (!mounted) return;

      if (success) {
        isNavigating = true;
        Get.toNamed(AppRoutes.enterManually);
        return; // do NOT restart camera — we're leaving this screen
      }

      // Only restart if we're staying on this screen
      isProcessing = false;
      if (mounted && !isNavigating) await _safeStartCamera();
    } catch (e) {
      debugPrint("SCAN ERROR => $e");
      isProcessing = false;
      if (mounted && !isNavigating) await _safeStartCamera();
    }
  }

  Future<void> _safeStartCamera() async {
    if (_isCameraStarting || _cameraController == null) return;
    _isCameraStarting = true;
    try {
      await _cameraController!.start();
    } catch (e) {
      debugPrint("Camera start skipped: $e");
    } finally {
      _isCameraStarting = false;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null) return;
    if (state == AppLifecycleState.resumed) {
      if (!isNavigating) _safeStartCamera();
    } else if (state == AppLifecycleState.paused) {
      _cameraController!.stop();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    isProcessing = false;
    isNavigating = false;
    _cameraController?.stop();
    _cameraController?.dispose();
    super.dispose();
  }

  // ── Build ──
  @override
  Widget build(BuildContext context) {
    // Show a friendly fallback on iOS Simulator
    if (_isSimulator) {
      return _buildSimulatorFallback();
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // CAMERA
          MobileScanner(
            controller: _cameraController!,
            fit: BoxFit.cover,
            onDetect: _onDetect,
          ),

          // DARK OVERLAY
          Container(color: Colors.black.withOpacity(0.45)),

          // TOP BAR
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
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

          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 180),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Align QR code within the frame",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 25),

                  Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(.3)),
                    ),
                    child: Stack(
                      children: [
                        _corner(Alignment.topLeft),
                        _corner(Alignment.topRight),
                        _corner(Alignment.bottomLeft),
                        _corner(Alignment.bottomRight),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  GestureDetector(
                    onTap: () async {
                      await _cameraController?.toggleTorch();
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white24),
                      ),
                      child: const Icon(
                        Icons.flash_on,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // BOTTOM SHEET
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
                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          if (isNavigating) return;
                          isNavigating = true;
                          await _cameraController?.stop();
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
                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
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

  // ── Simulator fallback UI ──
  Widget _buildSimulatorFallback() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Fake camera bg
          Container(color: Colors.grey.shade900),

          // TOP BAR
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
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

          // CENTER message
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.videocam_off_rounded,
                  size: 64,
                  color: Colors.white.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  "Camera not available\non iOS Simulator",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Use a real device to scan QR codes",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          // BOTTOM SHEET — manual entry still works
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
                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          if (isNavigating) return;
                          isNavigating = true;
                          await _cameraController?.stop();
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
                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
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

  // ── QR Corner widget ──
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
