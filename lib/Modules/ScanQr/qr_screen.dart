import 'package:flutter/material.dart';
import 'package:loyalty_admin/Modules/redeem/enter_manually_screen.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanQrScreen extends StatefulWidget {
  const ScanQrScreen({super.key});

  @override
  State<ScanQrScreen> createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends State<ScanQrScreen> {

  final MobileScannerController controller = MobileScannerController();

  void onDetect(BarcodeCapture capture) {
    final barcode = capture.barcodes.first;
    final String? code = barcode.rawValue;

    if (code != null) {
      controller.stop();
      print("Scanned: $code");
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [

          /// CAMERA
          MobileScanner(
            controller: controller,
            onDetect: onDetect,
          ),

          /// DARK OVERLAY
          Container(
            color: Colors.black.withOpacity(0.5),
          ),

          /// SCAN AREA
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.transparent),
              ),
              child: Stack(
                children: [

                  /// CORNERS
                  buildCorner(top: true, left: true),
                  buildCorner(top: true, left: false),
                  buildCorner(top: false, left: true),
                  buildCorner(top: false, left: false),

                ],
              ),
            ),
          ),

          /// TITLE + BACK BUTTON
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [

                  IconButton(
                    icon: const Icon(Icons.arrow_back,color: Colors.white),
                    onPressed: (){
                      Navigator.pop(context);
                    },
                  ),

                  const Text(
                    "Scan QR Code",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  )

                ],
              ),
            ),
          ),

          /// INSTRUCTION TEXT
          const Positioned(
            top: 120,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                "Align QR code within the frame",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ),
          ),

          /// FLASH BUTTON
          Positioned(
            bottom: 250,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: (){
                  controller.toggleTorch();
                },
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.flash_on,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          /// BOTTOM SHEET
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xffF2F2F2),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  const Text(
                    "Having trouble scanning?",
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// ENTER MANUALLY
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EnterCodeManuallyScreen(),
                        ),
                        (route) => route.isFirst,
                      );
                      },
                      child: const Text(
                        "Enter Code Manually",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// CANCEL
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel and Return"),
                    ),
                  ),

                ],
              ),
            ),
          ),

        ],
      ),
    );
  }

  /// CORNER WIDGET
  Widget buildCorner({required bool top, required bool left}) {

    return Positioned(
      top: top ? 0 : null,
      bottom: top ? null : 0,
      left: left ? 0 : null,
      right: left ? null : 0,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          border: Border(
            top: top ? const BorderSide(color: Colors.orange,width: 4) : BorderSide.none,
            left: left ? const BorderSide(color: Colors.orange,width: 4) : BorderSide.none,
            right: !left ? const BorderSide(color: Colors.orange,width: 4) : BorderSide.none,
            bottom: !top ? const BorderSide(color: Colors.orange,width: 4) : BorderSide.none,
          ),
        ),
      ),
    );
  }
}
