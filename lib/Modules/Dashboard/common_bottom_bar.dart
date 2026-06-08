import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loyalty_admin/Modules/Dashboard/pwaWebview_screen.dart';
import 'package:loyalty_admin/Modules/ScanQr/qr_screen.dart';
import 'package:loyalty_admin/routes/app_routes.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

import 'package:loyalty_admin/services/storage/secure_storage_service.dart';

/// =============================
/// COMMON BOTTOM BAR
/// =============================
class CommonBottomBar extends StatefulWidget {
  const CommonBottomBar({super.key});

  @override
  State<CommonBottomBar> createState() => _CommonBottomBarState();
}

class _CommonBottomBarState extends State<CommonBottomBar> {
  int selectedIndex = 0;

  final List<Widget> pages = [
    /// DASHBOARD
    const PwaWebViewScreen(
      title: "Dashboard",
      url: "https://master.d1qi4h2imco1od.amplifyapp.com/",
    ),

    /// USERS
    const PwaWebViewScreen(
      title: "Users",
      url: "https://master.d1qi4h2imco1od.amplifyapp.com/users",
    ),

    /// ANALYTICS
    const PwaWebViewScreen(
      title: "Analytics",
      url: "https://master.d1qi4h2imco1od.amplifyapp.com/analytics",
    ),

    /// SETTINGS
    const PwaWebViewScreen(
      title: "Settings",
      url: "https://master.d1qi4h2imco1od.amplifyapp.com/settings",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F7F7),
      
        body: IndexedStack(index: selectedIndex, children: pages),
      
        //floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: GestureDetector(
          onTap: () {
            Get.offNamed(AppRoutes.scanQr);
            // Get.to( ScanQrScreen()
            // () => const PwaWebViewScreen(
            //   title: "QR Scanner",
            //   url: "https://master.d1qi4h2imco1od.amplifyapp.com/scan",
            // ),
            //);
          },
      
          child: Container(
            height: 72,
            width: 72,
      
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
      
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.qr_code_2, color: Colors.white, size: 30),
      
                SizedBox(height: 2),
      
                Text(
                  "QR",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      
        bottomNavigationBar: Container(
          margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      
          decoration: BoxDecoration(
            color: Colors.white,
      
            borderRadius: BorderRadius.circular(40),
      
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
      
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              navItem(icon: Icons.home_rounded, label: "Home", index: 0),
      
              navItem(icon: Icons.people_alt_outlined, label: "Users", index: 1),
      
              //const SizedBox(width: 40),
              navItem(icon: Icons.bar_chart_rounded, label: "Stats", index: 2),
      
              navItem(icon: Icons.settings_outlined, label: "Settings", index: 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget navItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 26,
            color: isSelected ? const Color(0xFFD7425B) : Colors.grey,
          ),

          const SizedBox(height: 4),

          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isSelected ? const Color(0xFFD7425B) : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
